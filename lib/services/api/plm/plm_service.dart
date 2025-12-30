import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:umgkh_mobile/models/base/custom_ui/api_response.dart';
import 'package:umgkh_mobile/models/plm/plm_sales/monthly_dept_plm_sales.dart';
import 'package:umgkh_mobile/models/plm/plm_sales/plm_sales.dart';
import 'package:umgkh_mobile/services/api/base/auth/token_service.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import '../../../../utils/constants.dart';
import 'dart:io';
import 'package:http/io_client.dart';

class PLMAPIService {
  final AuthAPIService _tokenManager = AuthAPIService();
  final ioClient = IOClient(HttpClient()..findProxy = (_) => "DIRECT");

  Future<ApiResponse<List<PLMSales>>> fetchPLMSales() async {
    final token = await _tokenManager.getValidToken();
    try {
      final response = await ioClient
          .get(Uri.parse(Constants.getPLMSalesAchievement), headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      });

      if (response.statusCode == 200) {
        final List<PLMSales> data = (jsonDecode(response.body) as List)
            .map((json) => PLMSales.fromJson(json))
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

  Future<ApiResponse<List<MonthlyDepartmentPLMSales>>>
      fetcMonthlyDepartmenthPLMSales() async {
    final token = await _tokenManager.getValidToken();
    try {
      final response = await ioClient
          .get(Uri.parse(Constants.getMonthlyDeptPLMSalse), headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      });

      if (response.statusCode == 200) {
        final List<MonthlyDepartmentPLMSales> data =
            (jsonDecode(response.body) as List)
                .map((json) => MonthlyDepartmentPLMSales.fromJson(json))
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
}
