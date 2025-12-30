import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:umgkh_mobile/models/base/custom_ui/api_response.dart';
import 'package:umgkh_mobile/models/hr/survey/survey_user_input.dart';
import 'package:umgkh_mobile/services/api/base/auth/token_service.dart';
import 'package:umgkh_mobile/utils/constants.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'dart:io';
import 'package:http/io_client.dart';

class SurveyAPIService {
  final AuthAPIService _tokenManager = AuthAPIService();
  // final UserLocalStorageService _userLocalStorageService =
  //     UserLocalStorageService();
  final ioClient = IOClient(HttpClient()..findProxy = (_) => "DIRECT");

  Future<ApiResponse<List<SurveyUserInput>>> fetchSurvey(DateTime startDate, DateTime endDate) async {
    final token = await _tokenManager.getValidToken();

    try {
      var response = await ioClient.get(
        Uri.parse('${Constants.survey}/${DateFormat('yyyy-MM-dd').format(startDate)}/${DateFormat('yyyy-MM-dd').format(endDate)}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // Adjust content type as needed
        },
      );
      if (response.statusCode == 200) {
        final List<SurveyUserInput> responseData = (json.decode(response.body) as List)
            .map(
              (json) => SurveyUserInput.fromJson(json),
            )
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
