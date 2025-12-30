import 'dart:async';
import 'dart:convert';
import 'dart:io';
// import 'package:flutter/foundation.dart';
import 'package:umgkh_mobile/models/base/custom_ui/api_response.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import '../../../models/announcement/announcement.dart';
import '../../../utils/constants.dart';
import '../base/auth/token_service.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class AnnouncementAPIService {
  final AuthAPIService _tokenManager = AuthAPIService();
  final ioClient = IOClient(HttpClient()..findProxy = (_) => "DIRECT");

  Future<ApiResponse<List<Announcement>>> fetchData() async {
    final token = await _tokenManager.getValidToken();
    try {
      final response = await ioClient.get(
        Uri.parse(Constants.getAnnouncement),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
      );

      if (response.statusCode == 200) {
        final List<Announcement> responseData = (json
            .decode(response.body) as List)
            .map((json) => Announcement.fromJson(json),)
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
}
