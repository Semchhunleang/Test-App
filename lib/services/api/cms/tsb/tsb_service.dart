import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:umgkh_mobile/models/base/custom_ui/api_response.dart';
import 'package:umgkh_mobile/models/cms/tsb/tsb.dart';
import 'package:umgkh_mobile/models/cms/tsb/tsb_line.dart';
import 'package:umgkh_mobile/services/api/base/auth/token_service.dart';
import 'package:http/http.dart' as http;
import 'package:umgkh_mobile/utils/constants.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'dart:io';
import 'package:http/io_client.dart';

class TSBAPIService {
  final AuthAPIService _tokenManager = AuthAPIService();
  final ioClient = IOClient(HttpClient()..findProxy = (_) => "DIRECT");
  Future<ApiResponse<List<TSBData>>> fetchTsbData() async {
    try {
      final token = await _tokenManager.getValidToken();

      final response = await ioClient.get(
        Uri.parse(Constants.getTSB),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final tsbList = (data['tsb'] as List<dynamic>?)
                ?.map(
                  (item) => TSBData.fromJson(item as Map<String, dynamic>),
                )
                .toList() ??
            [];

        return ApiResponse(data: tsbList, statusCode: response.statusCode);
      } else {
        return ApiResponse(
            error: getResponseErrorMessage(response),
            statusCode: response.statusCode);
      }
    } on TimeoutException catch (_) {
      return ApiResponse(error: 'Request timed out', statusCode: 408);
    } catch (e) {
      debugPrint("error : $e");
      return ApiResponse(error: 'Error fetching A4 data: $e', statusCode: 504);
    }
  }

  Future<ApiResponse<String>> updateStateTsb(data) async {
    final token = await _tokenManager.getValidToken();
    try {
      final response = await ioClient.put(
        Uri.parse(Constants.updateStateTsb),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );
      if (response.statusCode == 201) {
        return ApiResponse(
          statusCode: response.statusCode,
          message: getResponseMessage(response),
        );
      } else {
        return ApiResponse(
          error: getResponseErrorMessage(response),
          statusCode: response.statusCode,
          message: getResponseMessage(response),
        );
      }
    } on TimeoutException catch (_) {
      return ApiResponse(error: 'Request timed out', statusCode: 408);
    } catch (e) {
      return ApiResponse(error: getCatchExceptionMessage(e), statusCode: 503);
    }
  }

  Future<ApiResponse<String>> insertTsb(
      Map<String, dynamic> data, List<File> pictures) async {
    try {
      final token = await _tokenManager.getValidToken();

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(Constants.insertTSB),
      );
      request.headers['Authorization'] = 'Bearer $token';
      data.forEach((key, value) {
        if (value is List) {
          request.fields[key] = value.map((e) => e.toString()).join(",");
        } else {
          request.fields[key] = value.toString();
        }
      });
      for (var picture in pictures) {
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
          statusCode: response.statusCode,
          message: getResponseMessage(response),
        );
      }
    } on TimeoutException catch (_) {
      return ApiResponse(error: 'Request timed out', statusCode: 408);
    } catch (e) {
      return ApiResponse(error: getCatchExceptionMessage(e), statusCode: 503);
    }
  }

  Future<ApiResponse<String>> insertTsbLine(data) async {
    try {
      final token = await _tokenManager.getValidToken();
      final response = await ioClient.post(
        Uri.parse(Constants.insertTSBLine),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
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
    } on TimeoutException catch (_) {
      return ApiResponse(error: 'Request timed out', statusCode: 408);
    } catch (e) {
      return ApiResponse(error: getCatchExceptionMessage(e), statusCode: 503);
    }
  }

  Future<ApiResponse<List<TsbLine>>> fetchTsbLineData(int id) async {
    try {
      final token = await _tokenManager.getValidToken();

      final response = await ioClient.get(
        Uri.parse(Constants.getTsbLine(id)),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final tsbList = (data['parts'] as List<dynamic>?)
                ?.map(
                  (item) => TsbLine.fromJson(item as Map<String, dynamic>),
                )
                .toList() ??
            [];

        return ApiResponse(data: tsbList, statusCode: response.statusCode);
      } else {
        return ApiResponse(
            error: getResponseErrorMessage(response),
            statusCode: response.statusCode);
      }
    } on TimeoutException catch (_) {
      return ApiResponse(error: 'Request timed out', statusCode: 408);
    } catch (e) {
      debugPrint("error : $e");
      return ApiResponse(error: 'Error fetching A4 data: $e', statusCode: 504);
    }
  }

  Future<ApiResponse<String>> updateTsb(
      Map<String, dynamic> data, File? beforePict, File? afterPict) async {
    try {
      final token = await _tokenManager.getValidToken();

      var request = http.MultipartRequest(
        'PUT',
        Uri.parse(Constants.insertTSB),
      );
      request.headers['Authorization'] = 'Bearer $token';
      data.forEach((key, value) {
        if (value is List) {
          request.fields[key] = value.map((e) => e.toString()).join(",");
        } else {
          request.fields[key] = value.toString();
        }
      });
      if (beforePict != null) {
        request.files.add(
          await http.MultipartFile.fromPath('before_pict', beforePict.path),
        );
      }
      if (afterPict != null) {
        request.files.add(
          await http.MultipartFile.fromPath('after_pict', afterPict.path),
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
          statusCode: response.statusCode,
          message: getResponseMessage(response),
        );
      }
    } on TimeoutException catch (_) {
      return ApiResponse(error: 'Request timed out', statusCode: 408);
    } catch (e) {
      return ApiResponse(error: getCatchExceptionMessage(e), statusCode: 503);
    }
  }

  Future<ApiResponse<String>> updateTsbLine(data) async {
    try {
      final token = await _tokenManager.getValidToken();
      final response = await ioClient.put(
        Uri.parse(Constants.insertTSBLine),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
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
    } on TimeoutException catch (_) {
      return ApiResponse(error: 'Request timed out', statusCode: 408);
    } catch (e) {
      return ApiResponse(error: getCatchExceptionMessage(e), statusCode: 503);
    }
  }
}
