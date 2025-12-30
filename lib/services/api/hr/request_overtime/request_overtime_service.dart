import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:umgkh_mobile/models/hr/request_overtime/request_overtime.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import '../../../../models/base/custom_ui/api_response.dart';
import '../../../../utils/constants.dart';
import '../../base/auth/token_service.dart';
import 'dart:io';
import 'package:http/io_client.dart';

class RequestOvertimeAPIService {
  final AuthAPIService _tokenManager = AuthAPIService();
  final ioClient = IOClient(HttpClient()..findProxy = (_) => "DIRECT");

  ///Fetch Overtime Request
  Future<ApiResponse<List<RequestOvertime>>> fetchOvertimeRequests(
      int year) async {
    final token = await _tokenManager.getValidToken();

    try {
      final response = await ioClient.get(
        Uri.parse(
          Constants.getRequestOvertime(year),
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<RequestOvertime> responseData =
            (json.decode(response.body) as List)
                .map(
                  (json) => RequestOvertime.fromJson(json),
                )
                .toList();
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

  ///Create request overtime data
  Future<ApiResponse<RequestOvertime>> createOvertimeRequest({
    required int employeeId,
    required String overtimeDate,
    required int overtimeHours,
    required int overtimeMinutes,
    required String reason,
  }) async {
    final token = await _tokenManager.getValidToken();

    try {
      final response = await ioClient.post(
        Uri.parse(Constants.submitRequestOvertime),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'employee_id': employeeId,
          'overtime_date': overtimeDate,
          'overtime_hours': overtimeHours,
          'overtime_minutes': overtimeMinutes,
          'reason': reason,
        }),
      );

      if (response.statusCode == 201) {
        final responseData =
            RequestOvertime.fromJson(json.decode(response.body)['result']);
        return ApiResponse(
          data: responseData,
          statusCode: response.statusCode,
          message: getResponseMessage(response),
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

//

  Future<ApiResponse<String>> createMultiOvertimeRequest(
      Map<String, dynamic> data) async {
    try {
      final token = await _tokenManager.getValidToken();

      final response = await ioClient.post(
          Uri.parse(Constants.submitMultiRequestOvertime),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json'
          },
          body: json.encode(data));

      if (response.statusCode == 201) {
        return ApiResponse(
            statusCode: response.statusCode,
            message: getResponseMessage(response));
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
          'Content-Type': 'application/json', // Adjust content type as needed
        },
      );

      if (response.statusCode == 200) {
        final List<RequestOvertime> responseData =
            (json.decode(response.body) as List)
                .map(
                  (json) => RequestOvertime.fromJson(json),
                )
                .toList();
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
        final responseData = json.decode(response.body);
        final createdRequestOvertime =
            RequestOvertime.fromJson(responseData['result']);
        final responseMessage = json.decode(response.body)['message'];
        return ApiResponse(
            data: createdRequestOvertime,
            statusCode: response.statusCode,
            message: responseMessage);
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
}
