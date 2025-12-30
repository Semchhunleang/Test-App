import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:umgkh_mobile/models/hr/overtime/overtime_attendance.dart';
import 'package:umgkh_mobile/models/hr/overtime/overtime.dart';
import 'package:umgkh_mobile/services/api/base/auth/token_service.dart';
import 'package:umgkh_mobile/models/base/custom_ui/api_response.dart';
import 'package:umgkh_mobile/utils/constants.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'dart:io';
import 'package:http/io_client.dart';

class OvertimeAPIService {
  final AuthAPIService _tokenManager = AuthAPIService();
  final ioClient = IOClient(HttpClient()..findProxy = (_) => "DIRECT");

  Future<ApiResponse<List<Overtime>>> fetchEmployeeOvertime(int year) async {
    final token = await _tokenManager.getValidToken();

    try {
      var response = await ioClient.get(
        Uri.parse('${Constants.getEmpoyeeOt}/$year'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // Adjust content type as needed
        },
      );
      if (response.statusCode == 200) {
        final List<Overtime> responseData = (json.decode(response.body) as List)
            .map(
              (json) => Overtime.fromJson(json),
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

  Future<ApiResponse> insert(data) async {
    final token = await _tokenManager.getValidToken();
    final response = await ioClient.post(Uri.parse(Constants.getEmpoyeeOt),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data));
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

  Future<ApiResponse> insertMultiOT(data) async {
    final token = await _tokenManager.getValidToken();
    final response = await ioClient.post(
        Uri.parse(Constants.submitEmployeeOvertime),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(data));
    if (response.statusCode == 201) {
      return ApiResponse(
          statusCode: response.statusCode,
          message: getResponseMessage(response));
    } else {
      return ApiResponse(
          error: getResponseErrorMessage(response),
          statusCode: response.statusCode);
    }
  }

  Future<ApiResponse<OvertimeAttendance>> fetchAttendanceByEmp(
      DateTime? date, int hour, int min, int dis, int empId) async {
    final token = await _tokenManager.getValidToken();
    try {
      var response = await ioClient.get(
          Uri.parse('${Constants.attendanceByEmp}/${toApiformatDate(
            toApiformatDateTime(date!),
          )}/$hour/$min/$dis/$empId'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          });
      if (response.statusCode == 200) {
        final responseData =
            OvertimeAttendance.fromJson(json.decode(response.body)['result']);
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

  Future<ApiResponse<List<Overtime>>> fetchApprovalOvertime(int year) async {
    final token = await _tokenManager.getValidToken();

    try {
      final response = await ioClient.get(
        Uri.parse(
          Constants.getApproveEmployeeOT(year),
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // Adjust content type as needed
        },
      );

      if (response.statusCode == 200) {
        final List<Overtime> responseData = (json.decode(response.body) as List)
            .map(
              (json) => Overtime.fromJson(json),
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

  ///Fetch Approve on Overtime HR
  Future<ApiResponse<List<Overtime>>> fetchApprovalOvertimeHr(int year) async {
    final token = await _tokenManager.getValidToken();

    try {
      final response = await ioClient.get(
        Uri.parse(
          Constants.getApproveEmployeeOvertimeHR(year),
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // Adjust content type as needed
        },
      );
      if (response.statusCode == 200) {
        final List<Overtime> responseData = (json.decode(response.body) as List)
            .map(
              (json) => Overtime.fromJson(json),
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

  Future<ApiResponse<Overtime>> updateStateEmployeeOvertime({
    required int overtimeId,
    required String state,
    required int approveHours,
    required int approveMinute,
    required String dhApprovedReason,
  }) async {
    final token = await _tokenManager.getValidToken();
    try {
      final encodeBody = json.encode({
        'id': overtimeId,
        'state': state,
        'approved_overtime_hours': approveHours,
        'approved_overtime_minutes': approveMinute,
        if (dhApprovedReason.isNotEmpty) 'dh_approved_reason': dhApprovedReason,
      });
      final response = await ioClient.put(
          Uri.parse(Constants.submitApprovalEmployeeOvertime),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json'
          },
          body: encodeBody);

      if (response.statusCode == 200) {
        final responseData =
            Overtime.fromJson(json.decode(response.body)['result']);
        final responseMessage = json.decode(response.body)['message'];
        return ApiResponse(
            data: responseData,
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
