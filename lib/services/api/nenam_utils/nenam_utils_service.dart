import 'dart:async';
import 'dart:convert';
import 'package:umgkh_mobile/models/base/custom_ui/api_response.dart';
import 'package:umgkh_mobile/models/base/data/nenam_version.dart';
import 'package:umgkh_mobile/models/umg/nenam_store_link.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import '../../../../utils/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:http/io_client.dart';

class NenamUtilsAPIService {
  final ioClient = IOClient(HttpClient()..findProxy = (_) => "DIRECT");
  Future<ApiResponse<List<NenamVersion>>> fetchNenamVersion() async {
    try {
      final response = await ioClient.get(Uri.parse(Constants.getNenamVersion));
      if (response.statusCode == 200) {
        final List<NenamVersion> data = (json.decode(response.body) as List)
            .map((json) => NenamVersion.fromJson(json))
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

  Future<ApiResponse<List<NenamStoreLink>>> fetchNenamStoreLink() async {
    try {
      final response = await ioClient.get(Uri.parse(Constants.getNenamStoreLink));
      if (response.statusCode == 200) {
        final List<NenamStoreLink> data = (json.decode(response.body) as List)
            .map((json) => NenamStoreLink.fromJson(json))
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
}
