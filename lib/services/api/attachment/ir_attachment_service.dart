import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:umgkh_mobile/models/base/custom_ui/api_response.dart';
import 'package:umgkh_mobile/utils/constants.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'package:http/io_client.dart';

class IrAttachmentAPIService {
  final ioClient = IOClient(HttpClient()..findProxy = (_) => "DIRECT");
  Future<ApiResponse> deleteAttachment(int id) async {
    try {
      var response =
          await ioClient.delete(Uri.parse("${Constants.deleteAttachment}/$id"));
      if (response.statusCode == 200) {
        return ApiResponse(
            statusCode: response.statusCode,
            message: getResponseMessage(response));
      } else {
        return ApiResponse(
            message: getResponseMessage(response),
            statusCode: response.statusCode);
      }
    } catch (e) {
      return ApiResponse(error: getCatchExceptionMessage(e), statusCode: 503);
    }
  }
}
