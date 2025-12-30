import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:umgkh_mobile/models/base/custom_ui/api_response.dart';
import 'package:umgkh_mobile/models/supporthub/file_attachment.dart';
import 'package:umgkh_mobile/models/supporthub/marketing/marketing_ticket.dart';
import 'package:umgkh_mobile/services/api/base/auth/token_service.dart';
import 'package:http/http.dart' as http;
import 'package:umgkh_mobile/utils/constants.dart';
import 'package:umgkh_mobile/utils/utlis.dart';

class MarketingTeamAPIService {
  final AuthAPIService _tokenManager = AuthAPIService();

  Future<ApiResponse<List<MarketingTicket>>> fetchData() async {
    try {
      final token = await _tokenManager.getValidToken();
      final response = await http
          .get(Uri.parse(Constants.getMarketingTicketByRequestor), headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      });
      if (response.statusCode == 200) {
        final List<MarketingTicket> data = (json.decode(response.body) as List)
            .map((json) => MarketingTicket.fromJson(json))
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

  Future<List<FileAttachment>> fetchDownloadFilePath(
      List<FileAttachment> files) async {
    List<FileAttachment> listPath = [];
    try {
      for (var item in files) {
        String fileUrl = Constants.attachmentFileById(item.id);
        final response = await http.get(Uri.parse(fileUrl));
        if (response.statusCode == 200) {
          final bytes = response.bodyBytes;
          final dir = await getApplicationDocumentsDirectory();
          final file = File('${dir.path}/${item.name}');
          await file.writeAsBytes(bytes);

          FileAttachment fileAttach = FileAttachment(
            id: item.id,
            name: item.name,
            extension: item.extension,
            megabytes: item.megabytes,
            downloadedFile: file.path,
          );

          listPath.add(fileAttach);
        } else {
          debugPrint("Failed to download ${item.extension}");
        }
      }
    } catch (e) {
      debugPrint("Error downloading or File: $e");
    }
    return listPath;
  }

  Future<ApiResponse<String>> insert(
      {required List<File> fileImages,
      required List<File> files,
      required Map<String, dynamic> data}) async {
    try {
      final token = await _tokenManager.getValidToken();
      var request = http.MultipartRequest(
          'POST', Uri.parse(Constants.createRequestMarketingTicket));
      request.headers['Authorization'] = 'Bearer $token';
      request.fields
          .addAll(data.map((key, value) => MapEntry(key, value.toString())));
      if (fileImages.isNotEmpty || files.isNotEmpty) {
        if (files.isNotEmpty) fileImages.addAll(files); // add file to image
        for (var file in fileImages) {
          var stream = http.ByteStream(file.openRead());
          var length = await file.length();
          var multipartFile = http.MultipartFile('pictures', stream, length,
              filename: basename(file.path));
          request.files.add(multipartFile);
        }
      }
      var streamedResponse = await request.send();
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

  Future<ApiResponse<String>> update(
      {required List<File> fileImages,
      required List<File> files,
      required Map<String, dynamic> data}) async {
    try {
      final token = await _tokenManager.getValidToken();
      var request = http.MultipartRequest(
          'PUT', Uri.parse(Constants.updateRequestMarketingTicket));
      request.headers['Authorization'] = 'Bearer $token';
      request.fields
          .addAll(data.map((key, value) => MapEntry(key, value.toString())));
      if (fileImages.isNotEmpty || files.isNotEmpty) {
        if (files.isNotEmpty) fileImages.addAll(files); // add file to image
        for (var file in fileImages) {
          var stream = http.ByteStream(file.openRead());
          var length = await file.length();
          var multipartFile = http.MultipartFile('pictures', stream, length,
              filename: basename(file.path));
          request.files.add(multipartFile);
        }
      }
      var streamedResponse = await request.send();
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
