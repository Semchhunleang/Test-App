import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:umgkh_mobile/models/am/small_paper/small_paper.dart';
import 'package:umgkh_mobile/models/base/custom_ui/api_response.dart';
import 'package:umgkh_mobile/services/api/base/auth/token_service.dart';
import 'package:umgkh_mobile/utils/constants.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'package:http/io_client.dart';

class SmallPaperAPIService {
  final AuthAPIService _tokenManager = AuthAPIService();
  final ioClient = IOClient(HttpClient()..findProxy = (_) => "DIRECT");

  Future<ApiResponse<List<SmallPaper>>> fetchData(bool isAm) async {
    try {
      final token = await _tokenManager.getValidToken();
      final response = await ioClient.get(
          Uri.parse(
              isAm ? Constants.allSmallPaper : Constants.smallPaperByUser),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json'
          });

      if (response.statusCode == 200) {
        final List<SmallPaper> data = (json.decode(response.body) as List)
            .map((json) => SmallPaper.fromJson(json))
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

  Future<ApiResponse<SmallPaper>> fetchInfo(int id) async {
    try {
      final token = await _tokenManager.getValidToken();
      final response = await ioClient
          .get(Uri.parse('${Constants.smallPaperById}/$id'), headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      });

      if (response.statusCode == 200) {
        return ApiResponse(
            data: SmallPaper.fromJson(
              jsonDecode(response.body),
            ),
            statusCode: response.statusCode);
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

  Future<ApiResponse<String>> insert(
      List<File>? files, Map<String, dynamic> data) async {
    try {
      final token = await _tokenManager.getValidToken();
      var request =
          http.MultipartRequest('POST', Uri.parse(Constants.createSmallPaper));
      request.headers['Authorization'] = 'Bearer $token';
      request.fields
          .addAll(data.map((key, value) => MapEntry(key, value.toString())));
      if (files != null) {
        for (var file in files) {
          var stream = http.ByteStream(file.openRead());
          var length = await file.length();
          var multipartFile = http.MultipartFile('pictures', stream, length,
              filename: basename(file.path));
          request.files.add(multipartFile);
        }
      }

      var streamedResponse = await ioClient.send(request);
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        return ApiResponse(
            statusCode: response.statusCode,
            message: getResponseMessage(response));
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
  // Future<ApiResponse<String>> insert(data) async {
  //   try {
  //     final token = await _tokenManager.getValidToken();
  //     final response = await ioClient.post(Uri.parse(Constants.createSmallPaper),
  //         headers: <String, String>{
  //           'Authorization': 'Bearer $token',
  //           'Content-Type': 'application/json'
  //         },
  //         body: jsonEncode(data),);
  //     if (response.statusCode == 201) {
  //       return ApiResponse(
  //           statusCode: response.statusCode,
  //           message: getResponseMessage(response),);
  //     } else {
  //       return ApiResponse(
  //           message: getResponseMessage(response),
  //           error: getResponseErrorMessage(response),
  //           statusCode: response.statusCode);
  //     }
  //   } on TimeoutException catch (_) {
  //     return ApiResponse(error: 'Request timed out', statusCode: 408);
  //   } catch (e) {
  //     return ApiResponse(error: getCatchExceptionMessage(e), statusCode: 503);
  //   }
  // }

  // Future<ApiResponse<String>> update(data) async {
  //   final token = await _tokenManager.getValidToken();
  //   try {
  //     final response = await ioClient.put(Uri.parse(Constants.updateSmallPaper),
  //         headers: <String, String>{
  //           'Authorization': 'Bearer $token',
  //           'Content-Type': 'application/json'
  //         },
  //         body: jsonEncode(data));
  //     if (response.statusCode == 201) {
  //       return ApiResponse(
  //           statusCode: response.statusCode,
  //           message: getResponseMessage(response));
  //     } else {
  //       return ApiResponse(
  //           message: getResponseMessage(response),
  //           error: getResponseErrorMessage(response),
  //           statusCode: response.statusCode);
  //     }
  //   } on TimeoutException catch (_) {
  //     return ApiResponse(error: 'Request timed out', statusCode: 408);
  //   } catch (e) {
  //     return ApiResponse(error: getCatchExceptionMessage(e), statusCode: 503);
  //   }
  // }

  Future<ApiResponse<String>> update(
      List<File>? files, Map<String, dynamic> data) async {
    try {
      final token = await _tokenManager.getValidToken();
      var request =
          http.MultipartRequest('PUT', Uri.parse(Constants.updateSmallPaper));
      request.headers['Authorization'] = 'Bearer $token';
      request.fields
          .addAll(data.map((key, value) => MapEntry(key, value.toString())));
      if (files != null) {
        for (var file in files) {
          var stream = http.ByteStream(file.openRead());
          var length = await file.length();
          var multipartFile = http.MultipartFile('pictures', stream, length,
              filename: basename(file.path));
          request.files.add(multipartFile);
        }
      }

      var streamedResponse = await ioClient.send(request);
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        return ApiResponse(
            statusCode: response.statusCode,
            message: getResponseMessage(response));
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

  Future<ApiResponse<Uint8List>> fetchImage(
      {required int spId, required int attId}) async {
    final token = await _tokenManager.getValidToken();
    ApiResponse<String>? responseToken =
        await _tokenManager.refreshAndGetToken();
    if (responseToken == null ||
        responseToken.error != null ||
        responseToken.data == null) {
      throw Exception('Failed to refresh token or token is null');
    }
    try {
      var response = await ioClient.get(
          Uri.parse("${Constants.smallPaperpicture}/$spId/$attId"),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json'
          });
      if (response.statusCode == 200) {
        return ApiResponse(
            data: response.bodyBytes, statusCode: response.statusCode);
      } else {
        return ApiResponse(
            error: getResponseErrorMessage(response),
            statusCode: response.statusCode);
      }
    } catch (e) {
      return ApiResponse(error: getCatchExceptionMessage(e), statusCode: 503);
    }
  }

  Future<ApiResponse<String>> updateDone(
      List<File>? files, Map<String, dynamic> data) async {
    try {
      final token = await _tokenManager.getValidToken();
      var request = http.MultipartRequest(
          'PUT', Uri.parse(Constants.updateDoneSmallPaper));
      request.headers['Authorization'] = 'Bearer $token';
      request.fields
          .addAll(data.map((key, value) => MapEntry(key, value.toString())));
      if (files != null) {
        for (var file in files) {
          var stream = http.ByteStream(file.openRead());
          var length = await file.length();
          var multipartFile = http.MultipartFile('pictures', stream, length,
              filename: basename(file.path));
          request.files.add(multipartFile);
        }
      }

      var streamedResponse = await ioClient.send(request);
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        return ApiResponse(
            statusCode: response.statusCode,
            message: getResponseMessage(response));
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
