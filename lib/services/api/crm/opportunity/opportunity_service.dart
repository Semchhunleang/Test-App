import 'dart:async';
import 'dart:convert';
import 'package:umgkh_mobile/models/base/custom_ui/api_response.dart';
import 'package:umgkh_mobile/services/api/base/auth/token_service.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import '../../../../models/crm/opportunity/opportunity.dart';
import '../../../../utils/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:http/io_client.dart';

class OpportunityService {
  final AuthAPIService _tokenManager = AuthAPIService();
  final ioClient = IOClient(HttpClient()..findProxy = (_) => "DIRECT");

  Future<ApiResponse<List<Opportunity>>> fetchOpportunity(
      String serviceType) async {
    final token = await _tokenManager.getValidToken();
    try {
      final response = await ioClient.get(
        Uri.parse(Constants.getOpportunity(serviceType),),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<Opportunity> data = (json.decode(response.body) as List)
            .map((json) => Opportunity.fromJson(json),)
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
      return ApiResponse(error: getCatchExceptionMessage(e), statusCode: 503);
    }
  }

  Future<ApiResponse<String>> insertOpportunity(data) async {
    try {
      final token = await _tokenManager.getValidToken();
      final response = await ioClient.post(
        Uri.parse(Constants.createOpportunity),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );
      if (response.statusCode == 201) {
        return ApiResponse(
            statusCode: response.statusCode,
            message: getResponseMessage(response),);
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

  Future<ApiResponse<String>> updateOpportunity(data) async {
    try {
      final token = await _tokenManager.getValidToken();
      final response = await ioClient.put(
        Uri.parse(Constants.updateOpportunity),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );
      if (response.statusCode == 201) {
        return ApiResponse(
            statusCode: response.statusCode,
            message: getResponseMessage(response),);
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
