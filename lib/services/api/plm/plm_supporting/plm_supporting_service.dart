import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:umgkh_mobile/models/base/custom_ui/api_response.dart';
import 'package:umgkh_mobile/models/plm/plm_supporting/plm_achievement/plm_achievement.dart';
import 'package:umgkh_mobile/models/plm/plm_supporting/plm_target/plm_supporting.dart';
import 'package:umgkh_mobile/services/api/base/auth/token_service.dart';
import 'package:http/http.dart' as http;
import 'package:umgkh_mobile/utils/constants.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'dart:io';
import 'package:http/io_client.dart';

class PLMSupportingAPIService {
  final AuthAPIService _tokenManager = AuthAPIService();
  final ioClient = IOClient(HttpClient()..findProxy = (_) => "DIRECT");
  Future<ApiResponse<List<PLMTarget>>> fetchMonthlyPLMTarget(
      String month, String year) async {
    final token = await _tokenManager.getValidToken();
    try {
      final response = await ioClient.get(
          Uri.parse("${Constants.getMonthlyPLMTargetSupporting}/$year/$month"),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json'
          });

      if (response.statusCode == 200) {
        final List<PLMTarget> data = (jsonDecode(response.body) as List)
            .map((json) => PLMTarget.fromJson(json))
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
      debugPrint('=========> ${e.toString()}');
      return ApiResponse(error: getCatchExceptionMessage(e), statusCode: 503);
    }
  }

  Future<ApiResponse<List<PLMAchievement>>> fetchMonthlyPLMAchievement(
      String month, String year) async {
    final token = await _tokenManager.getValidToken();
    try {
      final response = await ioClient.get(
          Uri.parse(
              "${Constants.getMonthlyPLMAchievementSupporting}/$year/$month"),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json'
          });

      if (response.statusCode == 200) {
        final List<PLMAchievement> data = (jsonDecode(response.body) as List)
            .map((json) => PLMAchievement.fromJson(json))
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
      debugPrint('=========> ${e.toString()}');
      return ApiResponse(error: getCatchExceptionMessage(e), statusCode: 503);
    }
  }

  Future<ApiResponse<String>> updateDailyPLMEmployee(data) async {
    final token = await _tokenManager.getValidToken();
    try {
      final response = await ioClient.put(
        Uri.parse(Constants.updateDailyPLMEmployee),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
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

  Future<ApiResponse<String>> updateWeeklyPLMEmployee(data) async {
    final token = await _tokenManager.getValidToken();
    try {
      final response = await ioClient.put(
        Uri.parse(Constants.updateWeeklyPLMEmployee),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
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

  Future<ApiResponse<String>> updateMonthlyPLMEmployee(data) async {
    final token = await _tokenManager.getValidToken();
    try {
      final response = await ioClient.put(
        Uri.parse(Constants.updateMonthlyPLMEmployee),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
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
