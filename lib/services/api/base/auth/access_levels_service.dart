import 'dart:convert';
import 'dart:io';
import 'package:umgkh_mobile/models/base/auth/access_level.dart';
import 'package:umgkh_mobile/models/base/custom_ui/api_response.dart';
import 'package:umgkh_mobile/services/local_storage/models/access_level_local_storage_service.dart';
// import 'package:umgkh_mobile/services/local_storage/models/project_task/project_task_local_storage_service.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import '../../../../utils/constants.dart';
import 'token_service.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class AccessLevelAPIService {
  final AuthAPIService _tokenManager = AuthAPIService();
  final AccessLevelLocalStorageService _accessLevelLocalStorageService =
      AccessLevelLocalStorageService();
  final ioClient = IOClient(HttpClient()..findProxy = (_) => "DIRECT");

  Future<ApiResponse<AccessLevel>> fetchAccessLevel() async {
    final token = await _tokenManager.getValidToken();
    // getAccessLevel
    try {
      if (token != 'server_unreachable') {
        final response = await ioClient.get(
          Uri.parse(Constants.getAccessLevel),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json'
          },
        );

        if (response.statusCode == 200) {
          final data = AccessLevel.fromJson(jsonDecode(response.body),);
          return ApiResponse(data: data, statusCode: response.statusCode);
        } else {
          return ApiResponse(
              error: getResponseErrorMessage(response),
              statusCode: response.statusCode);
        }
      } else {
        AccessLevel? dataLocal =
            await _accessLevelLocalStorageService.getAccessLevel();
        if (dataLocal != null) {
          return ApiResponse(data: dataLocal, statusCode: 200);
        } else {
          return ApiResponse(
              error: 'Local data is not available && Server is Unreachable',
              statusCode: 404);
        }
      }
    } catch (e) {
      AccessLevel? dataLocal =
          await _accessLevelLocalStorageService.getAccessLevel();
      if (dataLocal != null) {
        return ApiResponse(data: dataLocal, statusCode: 200);
      } else {
        return ApiResponse(error: getCatchExceptionMessage(e), statusCode: 503);
      }
    }
  }
}
