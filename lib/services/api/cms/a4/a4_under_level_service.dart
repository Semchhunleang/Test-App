import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:umgkh_mobile/utils/utlis.dart';
import '../../../../models/cms/a4/a4.dart';
import '../../../../models/base/custom_ui/api_response.dart';
import '../../../../utils/constants.dart';
import '../../base/auth/token_service.dart';
import 'dart:io';
import 'package:http/io_client.dart';

class A4UnderLevelAPIService {
  final AuthAPIService _tokenManager = AuthAPIService();
  final ioClient = IOClient(HttpClient()..findProxy = (_) => "DIRECT");

  // Helper function to validate and fetch the token

  Future<ApiResponse<String>> createA4UnderLevel(List<File> pictures) async {
    try {
      final token = await _tokenManager.getValidToken();

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(Constants.createA4UnderLevel),
      );
      request.headers['Authorization'] = 'Bearer $token';

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
            statusCode: response.statusCode);
      }
    } on TimeoutException catch (_) {
      return ApiResponse(error: 'Request timed out', statusCode: 408);
    } catch (e) {
      return ApiResponse(error: getCatchExceptionMessage(e), statusCode: 503);
    }
  }

  Future<ApiResponse<List<A4Data>>> fetchA4Data() async {
    try {
      final token = await _tokenManager.getValidToken();

      final response = await ioClient.get(
        Uri.parse(Constants.getA4Data),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final a4List = (data['a4'] as List<dynamic>?)
                ?.map(
                  (item) => A4Data.fromJson(item as Map<String, dynamic>),
                )
                .toList() ??
            [];

        return ApiResponse(data: a4List, statusCode: response.statusCode);
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

  Future<ApiResponse<Uint8List>> getImageA4(
      int transactionId, String resField) async {
    try {
      final token = await _tokenManager.getValidToken();

      final response = await ioClient.get(
        Uri.parse(
          Constants.getImageA4(transactionId, resField),
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return ApiResponse(
            data: response.bodyBytes, statusCode: response.statusCode);
      } else {
        return ApiResponse(
            error: 'Request failed with status: ${response.statusCode}',
            statusCode: response.statusCode);
      }
    } on TimeoutException catch (_) {
      return ApiResponse(error: 'Request timed out', statusCode: 408);
    } catch (e) {
      return ApiResponse(error: 'Error fetching image: $e', statusCode: 503);
    }
  }
}
