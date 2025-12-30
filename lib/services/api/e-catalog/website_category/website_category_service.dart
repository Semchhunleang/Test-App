import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:umgkh_mobile/models/base/custom_ui/api_response.dart';
import 'package:umgkh_mobile/models/e-catalog/website_category/website_category.dart';
import 'package:umgkh_mobile/services/api/base/auth/token_service.dart';
import 'package:umgkh_mobile/utils/constants.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'dart:io';
import 'package:http/io_client.dart';

class WebsiteCategoryAPIService {
  final AuthAPIService _tokenManager = AuthAPIService();
  final ioClient = IOClient(HttpClient()..findProxy = (_) => "DIRECT");

  Future<ApiResponse<List<WebsiteCategory>>> fetchWebsiteCategory() async {
    final token = await _tokenManager.getValidToken();

    try {
      var response = await ioClient.get(
        Uri.parse(Constants.getWebsiteCategory),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // Adjust content type as needed
        },
      );
      if (response.statusCode == 200) {
        final List<WebsiteCategory> responseData =
            (json.decode(response.body) as List)
                .map((json) => WebsiteCategory.fromJson(json),)
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
}
