import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:umgkh_mobile/models/base/custom_ui/api_response.dart';
import 'package:umgkh_mobile/models/hr/attendance/attendance.dart';
import 'package:umgkh_mobile/services/api/base/auth/token_service.dart';
import 'package:umgkh_mobile/utils/constants.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'dart:io';
import 'package:http/io_client.dart';

class AttendanceAPIService {
  final AuthAPIService _tokenManager = AuthAPIService();
  final ioClient = IOClient(HttpClient()..findProxy = (_) => "DIRECT");

  Future<ApiResponse<List<Attendance>>> fetchAttendance(
      DateTime startDate, DateTime endDate) async {
    final token = await _tokenManager.getValidToken();
    try {
      var response = await ioClient.get(
        Uri.parse(
            '${Constants.getAttendanceByToken}/${DateFormat('yyyy-MM-dd').format(startDate)}/${DateFormat('yyyy-MM-dd').format(endDate)}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final List<Attendance> responseData =
            (json.decode(response.body) as List)
                .map(
                  (json) => Attendance.fromJson(json),
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

  Future<ApiResponse> checkIn(String? reasonCheckIn, File? picture) async {
    final token = await _tokenManager.getValidToken();

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(Constants.checkIn),
    );
    request.headers['Authorization'] = 'Bearer $token';

    request.fields['reason_check_in'] = reasonCheckIn ?? '';
    if (picture != null) {
      request.files.add(
        await http.MultipartFile.fromPath('picture', picture.path),
      );
    }

    var streamedResponse = await ioClient.send(request);
    final response = await http.Response.fromStream(streamedResponse);

    if (streamedResponse.statusCode == 201) {
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

  Future<ApiResponse> checkOutMorning(
      String? reasonCheckOutMorning, File? picture) async {
    final token = await _tokenManager.getValidToken();

    var request = http.MultipartRequest(
      'PUT',
      Uri.parse(Constants.checkOutMorning),
    );
    request.headers['Authorization'] = 'Bearer $token';

    request.fields['reason_check_out_morning'] = reasonCheckOutMorning ?? '';
    if (picture != null) {
      request.files.add(
        await http.MultipartFile.fromPath('picture', picture.path),
      );
    }

    // var response = await request.send();
    var streamedResponse = await ioClient.send(request);
    final response = await http.Response.fromStream(streamedResponse);

    if (streamedResponse.statusCode == 200) {
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

  Future<ApiResponse> checkInAfternoon(
      String? reasoncheckInAfternoon, File? picture) async {
    final token = await _tokenManager.getValidToken();

    var request = http.MultipartRequest(
      'PUT',
      Uri.parse(Constants.checkInAfternoon),
    );
    request.headers['Authorization'] = 'Bearer $token';

    request.fields['reason_check_in_afternoon'] = reasoncheckInAfternoon ?? '';
    if (picture != null) {
      request.files.add(
        await http.MultipartFile.fromPath('picture', picture.path),
      );
    }

    var streamedResponse = await ioClient.send(request);
    final response = await http.Response.fromStream(streamedResponse);

    if (streamedResponse.statusCode == 200) {
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

  Future<ApiResponse> checkOut(String? reasoncheckOut, File? picture) async {
    final token = await _tokenManager.getValidToken();

    var request = http.MultipartRequest(
      'PUT',
      Uri.parse(Constants.checkOut),
    );
    request.headers['Authorization'] = 'Bearer $token';

    request.fields['reason_check_out'] = reasoncheckOut ?? '';
    if (picture != null) {
      request.files.add(
        await http.MultipartFile.fromPath('picture', picture.path),
      );
    }

    var streamedResponse = await ioClient.send(request);
    final response = await http.Response.fromStream(streamedResponse);

    if (streamedResponse.statusCode == 200) {
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
