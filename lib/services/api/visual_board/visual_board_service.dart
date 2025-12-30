import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:umgkh_mobile/models/base/custom_ui/api_response.dart';
import 'package:umgkh_mobile/models/visual_board/stage.dart';
import 'package:umgkh_mobile/models/visual_board/visual_board.dart';
import 'package:umgkh_mobile/services/api/base/auth/token_service.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import '../../../../utils/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:http/io_client.dart';

class VisualBoardAPIService {
  final AuthAPIService _tokenManager = AuthAPIService();
  final ioClient = IOClient(HttpClient()..findProxy = (_) => "DIRECT");

  Future<ApiResponse<List<VisualBoard>>> fetchVisualBoardByDept() async {
    final token = await _tokenManager.getValidToken();
    try {
      final response = await ioClient.get(Uri.parse(Constants.getVisualBoardByDept),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json'
          });

      if (response.statusCode == 200) {
        final List<VisualBoard> data = (jsonDecode(response.body) as List)
            .map((json) => VisualBoard.fromJson(json))
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

  Future<ApiResponse<List<VisualBoardStage>>> fetchVisualBoardStage() async {
    final token = await _tokenManager.getValidToken();
    try {
      final response = await ioClient.get(Uri.parse(Constants.getVisualBoardStage),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json'
          });

      if (response.statusCode == 200) {
        final List<VisualBoardStage> data = (jsonDecode(response.body) as List)
            .map((json) => VisualBoardStage.fromJson(json))
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

  Future<ApiResponse<String>> updateVB(VisualBoard data) async {
    final token = await _tokenManager.getValidToken();
    try {
      final response = await ioClient.put(
        Uri.parse(Constants.vb),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "id": data.id,
          "name": data.name,
          "description": data.description,
          "due_date": data.dueDate?.toIso8601String(),
          "stage_id": data.stage.id,
          "assigned_ids":
              data.assignees.map((assignee) => assignee.id).toList(),
          "requestor_ids":
              data.requestors.map((requestor) => requestor.id).toList(),
          "department_ids":
              data.departments?.map((department) => department.id).toList(),
          "plm_daily_ids": data.plmDaily?.map((plm) => plm.id).toList(),
          "plm_weekly_ids": data.plmWeekly?.map((plm) => plm.id).toList(),
          "plm_monthly_ids": data.plmMonthly?.map((plm) => plm.id).toList(),
        }),
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

  Future<ApiResponse<String>> updateSequenceVB(
      List<Map<String, dynamic>> data) async {
    final token = await _tokenManager.getValidToken();
    try {
      final response = await http.put(
        Uri.parse(Constants.updateSequenceVB),
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
}
