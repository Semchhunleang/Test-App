import 'dart:async';
import 'dart:convert';
import 'package:umgkh_mobile/models/base/custom_ui/api_response.dart';
import 'package:umgkh_mobile/services/api/base/auth/token_service.dart';
import 'package:http/http.dart' as http;
import 'package:umgkh_mobile/utils/constants.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'dart:io';
import 'package:http/io_client.dart';

class A4APIService {
  final AuthAPIService _tokenManager = AuthAPIService();
  final ioClient = IOClient(HttpClient()..findProxy = (_) => "DIRECT");

  Future<ApiResponse<String>> updateStateA4(data) async {
    final token = await _tokenManager.getValidToken();
    try {
      final response = await ioClient.put(
        Uri.parse(Constants.updateStateA4),
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

  Future<ApiResponse<String>> insertA4(
      Map<String, dynamic> data, List<File> pictures) async {
    try {
      final token = await _tokenManager.getValidToken();

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(Constants.insertA4),
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

  Future<ApiResponse<String>> updateA4(
      Map<String, dynamic> data, File? beforeImprov, File? afterImprov) async {
    try {
      final token = await _tokenManager.getValidToken();

      var request = http.MultipartRequest(
        'PUT',
        Uri.parse(Constants.insertA4),
      );
      request.headers['Authorization'] = 'Bearer $token';
      data.forEach((key, value) {
        if (value is List) {
          request.fields[key] = value.map((e) => e.toString()).join(",");
        } else {
          request.fields[key] = value.toString();
        }
      });
      if (beforeImprov != null) {
        request.files.add(
          await http.MultipartFile.fromPath('before_improv', beforeImprov.path),
        );
      }
      if (afterImprov != null) {
        request.files.add(
          await http.MultipartFile.fromPath('after_improv', afterImprov.path),
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
}
