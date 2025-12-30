import 'dart:async';
import 'dart:convert';
import 'package:umgkh_mobile/models/hr/request_overtime/request_overtime.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import '../../../../models/base/custom_ui/api_response.dart';
import '../../../../utils/constants.dart';
import '../../base/auth/token_service.dart';
import 'package:http/http.dart' as http; // For HTTP requests
import 'dart:io';
import 'package:http/io_client.dart';

class ApproveRequestOvertimeAPIService {
  final AuthAPIService _tokenManager = AuthAPIService();
  final ioClient = IOClient(HttpClient()..findProxy = (_) => "DIRECT");

  ///Fetch Approve on Overtime Request
  Future<ApiResponse<List<RequestOvertime>>> fetchApprovalOvertime(
      int year) async {
    final token = await _tokenManager.getValidToken();

    try {
      final response = await ioClient.get(
        Uri.parse(
          Constants.getApproveRequestOT(year),
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<RequestOvertime> responseData = json
            .decode(response.body)
            .map(
              (json) => RequestOvertime.fromJson(json),
            )
            .toList();
        return ApiResponse(
          data: responseData,
          statusCode: response.statusCode,
        );
      } else {
        return ApiResponse(
            error: getResponseErrorMessage(response),
            statusCode: response.statusCode);
      }
    } on TimeoutException catch (_) {
      return ApiResponse(error: 'Request timed out', statusCode: 408);
    } catch (e) {
      return ApiResponse(error: getCatchExceptionMessage(e), statusCode: 503);
    }
  }

  ///update request overtime state of approve or reject
  Future<ApiResponse<RequestOvertime>> updateStateRequestOvertime({
    required int requestOvertimeId,
    required String state,
    required int dhApproveHours,
    required int dhApproveMinute,
  }) async {
    final token = await _tokenManager.getValidToken();

    try {
      final response = await ioClient.put(
        Uri.parse(Constants
            .submitApprovalRequestOvertime), // Update this with your endpoint for creating a request
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'id': requestOvertimeId,
          'state': state,
          'dh_overtime_hours': dhApproveHours,
          'dh_overtime_minutes': dhApproveMinute
        }),
      );

      if (response.statusCode == 200) {
        // Assuming 200 update state is the success status code
        final responseData =
            RequestOvertime.fromJson(json.decode(response.body)['result']);
        return ApiResponse(data: responseData, statusCode: response.statusCode);
      } else {
        return ApiResponse(
            error: getResponseErrorMessage(response),
            statusCode: response.statusCode);
      }
    } on TimeoutException catch (_) {
      return ApiResponse(error: 'Request timed out', statusCode: 408);
    } catch (e) {
      return ApiResponse(error: getCatchExceptionMessage(e), statusCode: 503);
    }
  }

  ///update batch request overtime state of approve or reject
  Future<ApiResponse<List<RequestOvertime>>> batchApprovalRequestOvertime({
    required List<int> requestOvertimeIds,
    required String state,
  }) async {
    final token = await _tokenManager.getValidToken();

    try {
      final response = await ioClient.put(
        Uri.parse(Constants.batchApprovalRequestOvertime),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({'id': requestOvertimeIds, 'state': state}),
      );

      if (response.statusCode == 200) {
        final responseData = (json.decode(response.body)['result'] as List)
            .map((item) => RequestOvertime.fromJson(item))
            .toList();

        return ApiResponse(
            data: responseData,
            statusCode: response.statusCode,
            message: getResponseMessage(response));
      } else {
        return ApiResponse(
          error: getResponseErrorMessage(response),
          message: getResponseMessage(response),
          statusCode: response.statusCode,
        );
      }
    } on TimeoutException catch (_) {
      return ApiResponse(error: 'Request timed out', statusCode: 408);
    } catch (e) {
      return ApiResponse(error: getCatchExceptionMessage(e), statusCode: 503);
    }
  }
}
