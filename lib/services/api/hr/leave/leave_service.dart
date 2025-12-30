import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:umgkh_mobile/models/base/custom_ui/api_response.dart';
import 'package:umgkh_mobile/models/hr/leave/leave.dart';
import 'package:umgkh_mobile/models/base/user/user.dart';
import 'package:umgkh_mobile/services/api/base/auth/token_service.dart';
import 'package:umgkh_mobile/services/local_storage/models/user_local_storage_service.dart';
import 'package:umgkh_mobile/utils/constants.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'dart:io';
import 'package:http/io_client.dart';

class LeaveAPIService {
  final AuthAPIService _tokenManager = AuthAPIService();
  final UserLocalStorageService _userLocalStorageService =
      UserLocalStorageService();
  final ioClient = IOClient(HttpClient()..findProxy = (_) => "DIRECT");

  Future<ApiResponse<List<Leave>>> fetchLeave() async {
    final token = await _tokenManager.getValidToken();

    try {
      var response = await ioClient.get(
        Uri.parse(Constants.getLeaveByToken),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // Adjust content type as needed
        },
      );

      if (response.statusCode == 200) {
        final List<Leave> responseData = (json.decode(response.body) as List)
            .map(
              (json) => Leave.fromJson(json),
            )
            .toList();
        return ApiResponse(statusCode: response.statusCode, data: responseData);
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

  Future<ApiResponse<List<Leave>>> fetchLeaveDH() async {
    final token = await _tokenManager.getValidToken();

    try {
      var response = await ioClient.get(
        Uri.parse(Constants.getLeaveByTokenDH),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // Adjust content type as needed
        },
      );

      if (response.statusCode == 200) {
        final List<Leave> responseData = (json.decode(response.body) as List)
            .map(
              (json) => Leave.fromJson(json),
            )
            .toList();
        return ApiResponse(statusCode: response.statusCode, data: responseData);
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

  Future<ApiResponse<List<Leave>>> fetchLeaveByDept(int deptId) async {
    final token = await _tokenManager.getValidToken();

    try {
      var response = await ioClient
          .get(Uri.parse('${Constants.getLeaveByDept}/$deptId'), headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      });

      if (response.statusCode == 200) {
        final List<Leave> responseData = (json.decode(response.body) as List)
            .map((json) => Leave.fromJson(json))
            .toList();
        return ApiResponse(statusCode: response.statusCode, data: responseData);
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

  Future<ApiResponse> insert(
      String description,
      int leaveTypeId,
      String requestDateFrom,
      String requestDateTo,
      String requestDateFromPeriod,
      bool requestUnitHalf) async {
    final token = await _tokenManager.getValidToken();
    User? user = await _userLocalStorageService.getUser();

    final response = await ioClient.post(
      Uri.parse(Constants.insertLeave),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'description': description,
        'leave_type_id': leaveTypeId.toString(), // Convert int to String
        'department_id':
            user!.department!.id.toString(), // Convert int to String
        'request_date_from': requestDateFrom,
        'request_date_to': requestDateTo,
        'request_date_from_period': requestDateFromPeriod,
        'request_unit_half': requestUnitHalf.toString(),
      }),
    );
    if (response.statusCode == 201) {
      return ApiResponse(
        statusCode: response.statusCode,
        message: getResponseMessage(response),
      );
    } else {
      return ApiResponse(
          error: getResponseErrorMessage(response),
          statusCode: response.statusCode);
    }
  }

  Future<ApiResponse> updateState(String state, int id) async {
    final token = await _tokenManager.getValidToken();

    final response = await ioClient.put(
      Uri.parse(Constants.updateLeaveState),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'state': state,
        'id': id.toString(),
      }),
    );
    if (response.statusCode == 200) {
      return ApiResponse(
        statusCode: response.statusCode,
        message: getResponseMessage(response),
      );
    } else {
      return ApiResponse(
          error: getResponseErrorMessage(response),
          statusCode: response.statusCode);
    }
  }
}
