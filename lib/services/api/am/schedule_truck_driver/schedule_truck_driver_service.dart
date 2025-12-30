import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:umgkh_mobile/models/am/schedule_truck_driver/schedule_truck_driver.dart';
import 'package:umgkh_mobile/models/base/custom_ui/api_response.dart';
import 'package:umgkh_mobile/services/api/base/auth/token_service.dart';
import 'package:umgkh_mobile/utils/constants.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'package:http/io_client.dart';

class ScheduleTruckDriverAPIService {
  final AuthAPIService _tokenManager = AuthAPIService();
  final ioClient = IOClient(HttpClient()..findProxy = (_) => "DIRECT");

  Future<ApiResponse<List<ScheduleTruckDriver>>> fetchData() async {
    try {
      final token = await _tokenManager.getValidToken();
      final response = await ioClient
          .get(Uri.parse(Constants.scheduleTruckDriver), headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      });

      if (response.statusCode == 200) {
        final List<ScheduleTruckDriver> data =
            (jsonDecode(response.body) as List)
                .map((json) => ScheduleTruckDriver.fromJson(json))
                .toList();
        return ApiResponse(data: data, statusCode: response.statusCode);
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
    final response =
        await ioClient.post(Uri.parse(Constants.scheduleTruckDriver),
            headers: <String, String>{
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
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

  Future<ApiResponse> update(data) async {
    final token = await _tokenManager.getValidToken();
    final response = await ioClient.put(
        Uri.parse(Constants.scheduleTruckDriver),
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

  Future<ApiResponse<String>> updateDone(
      List<File>? files, Map<String, dynamic> data) async {
    try {
      final token = await _tokenManager.getValidToken();

      var request = http.MultipartRequest(
          'PUT', Uri.parse(Constants.updateDoneSmallPaper));
      request.headers['Authorization'] = 'Bearer $token';
      request.fields
          .addAll(data.map((key, value) => MapEntry(key, value.toString())));

      if (files != null) {
        for (var file in files) {
          var stream = http.ByteStream(file.openRead());
          var length = await file.length();
          var multipartFile = http.MultipartFile('pictures', stream, length,
              filename: basename(file.path));
          request.files.add(multipartFile);
        }
      }

      // Send request using IOClient
      var streamedResponse = await ioClient.send(request);
      final response = await http.Response.fromStream(streamedResponse);

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
}
