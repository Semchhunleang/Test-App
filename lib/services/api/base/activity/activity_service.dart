import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:umgkh_mobile/models/base/custom_ui/api_response.dart';
import 'package:umgkh_mobile/models/crm/activity/activity.dart';
import 'package:umgkh_mobile/services/api/base/auth/token_service.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import '../../../../utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class ActivityAPIService {
  final AuthAPIService _tokenManager = AuthAPIService();
  final ioClient = IOClient(HttpClient()..findProxy = (_) => "DIRECT");

  Future<ApiResponse<List<Activity>>> fetchActivity(int id) async {
    final token = await _tokenManager.getValidToken();
    try {
      final response = await ioClient
          .get(Uri.parse('${Constants.getActivity}/$id'), headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      });

      if (response.statusCode == 200) {
        final List<Activity> data = (json.decode(response.body) as List)
            .map(
              (json) => Activity.fromJson(json),
            )
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

  Future<ApiResponse<List<Activity>>> fetchSchedule(int id) async {
    final token = await _tokenManager.getValidToken();
    try {
      final response = await ioClient
          .get(Uri.parse('${Constants.getSchedule}/$id'), headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      });

      if (response.statusCode == 200) {
        final List<Activity> data = (json.decode(response.body) as List)
            .map(
              (json) => Activity.fromJson(json),
            )
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

  Future<ApiResponse<List<Activity>>> fetchActivityOrSchedule(
      bool isSchedule) async {
    final token = await _tokenManager.getValidToken();

    try {
      final response = await ioClient.get(
          Uri.parse(
              isSchedule ? Constants.scheduleByUser : Constants.activityByUser),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json'
          });

      if (response.statusCode == 200) {
        final List<Activity> data = (json.decode(response.body) as List)
            .map(
              (json) => Activity.fromJson(json),
            )
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

  Future<ApiResponse<String>> insertData(
      File? picture, Map<String, dynamic> data) async {
    try {
      final token = await _tokenManager.getValidToken();
      var request =
          http.MultipartRequest('POST', Uri.parse(Constants.createActivity));
      request.headers['Authorization'] = 'Bearer $token';
      request.fields
          .addAll(data.map((key, value) => MapEntry(key, value.toString())));

      if (picture != null) {
        request.files
            .add(await http.MultipartFile.fromPath('picture', picture.path));
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

  Future<ApiResponse<String>> insertSchedule(
      File? picture, Map<String, dynamic> data) async {
    try {
      final token = await _tokenManager.getValidToken();
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(Constants.createSchedule),
      );
      request.headers['Authorization'] = 'Bearer $token';
      request.fields.addAll(
        data.map(
          (key, value) => MapEntry(
            key,
            value.toString(),
          ),
        ),
      );

      if (picture != null) {
        request.files.add(
          await http.MultipartFile.fromPath('picture', picture.path),
        );
      }
      var streamedResponse = await ioClient.send(request);
      final response = await http.Response.fromStream(streamedResponse);

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
    } on TimeoutException catch (_) {
      return ApiResponse(error: 'Request timed out', statusCode: 408);
    } catch (e) {
      return ApiResponse(error: getCatchExceptionMessage(e), statusCode: 503);
    }
  }

  Future<ApiResponse<String>> updateData(
      File? picture, Map<String, dynamic> data) async {
    try {
      final token = await _tokenManager.getValidToken();
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse(Constants.createActivity),
      );
      request.headers['Authorization'] = 'Bearer $token';
      request.fields.addAll(
        data.map(
          (key, value) => MapEntry(
            key,
            value.toString(),
          ),
        ),
      );

      if (picture != null) {
        request.files.add(
          await http.MultipartFile.fromPath('picture', picture.path),
        );
      }
      var streamedResponse = await ioClient.send(request);
      final response = await http.Response.fromStream(streamedResponse);

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
    } on TimeoutException catch (_) {
      return ApiResponse(error: 'Request timed out', statusCode: 408);
    } catch (e) {
      return ApiResponse(error: getCatchExceptionMessage(e), statusCode: 503);
    }
  }

  Future<ApiResponse<Uint8List>> fetchImage(
      {required int leadId, required int attId}) async {
    final token = await _tokenManager.getValidToken();
    ApiResponse<String>? responseToken =
        await _tokenManager.refreshAndGetToken();
    if (responseToken == null ||
        responseToken.error != null ||
        responseToken.data == null) {
      throw Exception('Failed to refresh token or token is null');
    }
    try {
      var response = await ioClient.get(
          Uri.parse("${Constants.leadActivityPicture}/$leadId/$attId"),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json'
          });

      if (response.statusCode == 200) {
        return ApiResponse(
            data: response.bodyBytes, statusCode: response.statusCode);
      } else {
        return ApiResponse(
            error: getResponseErrorMessage(response),
            statusCode: response.statusCode);
      }
    } catch (e) {
      return ApiResponse(error: getCatchExceptionMessage(e), statusCode: 503);
    }
  }
}
