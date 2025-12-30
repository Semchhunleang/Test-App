import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:umgkh_mobile/models/base/custom_ui/api_response.dart';
import 'package:umgkh_mobile/models/base/user/user.dart';
import 'package:umgkh_mobile/services/api/base/auth/token_service.dart';
import 'package:umgkh_mobile/utils/constants.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'dart:io';
import 'package:http/io_client.dart';

class UserAPIService {
  final AuthAPIService _tokenManager = AuthAPIService();
  final ioClient = IOClient(HttpClient()..findProxy = (_) => "DIRECT");

  Future<ApiResponse<User>> fetchUserData(String? tokenI) async {
    String? tokenUse;
    if (tokenI != null) {
      final token = await _tokenManager.getValidToken();
      tokenUse = token;
    } else {
      tokenUse = tokenI;
    }
    try {
      var response = await ioClient.get(
        Uri.parse(Constants.getUserByToken),
        headers: {
          'Authorization': 'Bearer $tokenUse',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        return ApiResponse(
            data: User.fromJson(
              jsonDecode(response.body),
            ),
            statusCode: response.statusCode);
      } else {
        return ApiResponse(
            error: getResponseErrorMessage(response),
            statusCode: response.statusCode);
      }
    } catch (e) {
      return ApiResponse(error: getCatchExceptionMessage(e), statusCode: 503);
    }
  }

  Future<ApiResponse<Uint8List>> getProfilePicture(String? token) async {
    ApiResponse<String>? responseToken =
        await _tokenManager.refreshAndGetToken();
    if (responseToken == null ||
        responseToken.error != null ||
        responseToken.data == null) {
      throw Exception('Failed to refresh token or token is null');
    }
    try {
      var response = await ioClient.get(
        Uri.parse(Constants.profilepictureUrl),
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
            error: getResponseErrorMessage(response),
            statusCode: response.statusCode);
      }
    } catch (e) {
      return ApiResponse(error: getCatchExceptionMessage(e), statusCode: 503);
    }
  }

  Future<ApiResponse> registerFace(
    String? landmarks,
  ) async {
    final token = await _tokenManager.getValidToken();

    try {
      // final encodeBody = json.encode({'face_landmarks': landmarks});
      final response = await ioClient.put(
        Uri.parse(Constants.registerFace),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{'face_landmarks': landmarks!}),
      );
      if (response.statusCode == 201) {
        return ApiResponse(
          statusCode: response.statusCode,
          message: getResponseMessage(response),
        );
      } else {
        return ApiResponse(
            message: getResponseMessage(response),
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
