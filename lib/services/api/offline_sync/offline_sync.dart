import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:umgkh_mobile/models/base/custom_ui/api_response.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import '../../../utils/constants.dart';
import '../base/auth/token_service.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:http/io_client.dart';

class OfflineSyncAPIService {
  final AuthAPIService _tokenManager = AuthAPIService();
  final ioClient = IOClient(HttpClient()..findProxy = (_) => "DIRECT");

  Future<ApiResponse<dynamic>> updateStateJobAssignLineOffline(
      {required int jobAssignId,
      required String state,
      required String reason,
      required String datetime}) async {
    final token = await _tokenManager.getValidToken();
    try {
      final response = await ioClient.put(
        Uri.parse(Constants.offlineSyncJobAssignLine),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'id': jobAssignId,
          'state': state,
          'reason': reason,
          'datetime': datetime
        }),
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final responseMessage = responseData['message'];
        final resultData = responseData['result'];

        return ApiResponse(
            data: resultData,
            statusCode: response.statusCode,
            message: responseMessage);
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

  Future<ApiResponse<dynamic>> insertTimesheetOffline(
      {required int trip,
      required int fleetId,
      required int odometerStart,
      required int projectTaskId,
      required String dispatchDt,
      required String offId,
      required String dispatchFrom}) async {
    final token = await _tokenManager.getValidToken();
    try {
      final response = await ioClient.post(
        Uri.parse(Constants.offlineSyncInsertTimesheet),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'project_task_id': projectTaskId,
          'trip': trip,
          'dispatch_dt': dispatchDt,
          'fleet_id': fleetId,
          'odometer_start': odometerStart,
          'off_id': offId,
          'dispatch_from': dispatchFrom
        }),
      );
      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        final responseMessage = responseData['message'];
        final resultData = responseData['result'];

        return ApiResponse(
            data: resultData,
            statusCode: response.statusCode,
            message: responseMessage);
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

  Future<ApiResponse<dynamic>> insertTriAndRellOffline({
    required int fleetId,
    required int odometerStart,
    required int taskId,
    required String dispatchDt,
    required String offId,
  }) async {
    final token = await _tokenManager.getValidToken();
    try {
      final response = await ioClient.post(
        Uri.parse(Constants.offlineSyncInsertTripAndRel),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'task_id': taskId,
          'dispatch_dt': dispatchDt,
          'fleet_id': fleetId,
          'odometer_start': odometerStart,
          'off_id': offId
        }),
      );
      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        final responseMessage = responseData['message'];
        final resultData = responseData['result'];

        return ApiResponse(
            data: resultData,
            statusCode: response.statusCode,
            message: responseMessage);
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

  Future<ApiResponse<dynamic>> updateTriOffline(
      {int? id,
      //  String? arrivalAtSiteDt,
      //  String? leaveFromSiteDt,
      String? arriveAtOfficeDt,
      int? odometerEnd,
      String? offId}) async {
    final token = await _tokenManager.getValidToken();
    try {
      final response = await ioClient.put(
        Uri.parse(Constants.offlineSyncUpdateTrip),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'id': id,
          // 'arrival_at_site_dt': arrivalAtSiteDt,
          // 'leave_from_site_dt': leaveFromSiteDt,
          'arrive_at_office_dt': arriveAtOfficeDt,
          'odometer_end': odometerEnd,
          'off_id': offId
        }),
      );
      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        final responseMessage = responseData['message'];
        final resultData = responseData['result'];

        return ApiResponse(
            data: resultData,
            statusCode: response.statusCode,
            message: responseMessage);
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

  Future<ApiResponse<dynamic>> updateTimesheetOffline(
      {required String offId,
      String? arrivalAtSiteDt,
      String? jobStartDt,
      String? jobCompleteDt,
      String? leaveFromSiteDt,
      String? arriveAtOfficeDt,
      int? odometerEnd,
      String? arriveAt}) async {
    final token = await _tokenManager.getValidToken();
    try {
      final response = await ioClient.put(
        Uri.parse(Constants.offlineSyncUpdateTimesheet),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'off_id': offId,
          'arrival_at_site_dt': arrivalAtSiteDt,
          'job_start_dt': jobStartDt,
          'job_complete_dt': jobCompleteDt,
          'leave_from_site_dt': leaveFromSiteDt,
          'arrive_at_office_dt': arriveAtOfficeDt,
          'odometer_end': odometerEnd,
          'arrive_at': arriveAt
        }),
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final responseMessage = responseData['message'];
        final resultData = responseData['result'];

        return ApiResponse(
            data: resultData,
            statusCode: response.statusCode,
            message: responseMessage);
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

  Future<ApiResponse<dynamic>> insertOverallCheckingOffline(
      List<File>? files, Map<String, dynamic> data) async {
    final token = await _tokenManager.getValidToken();
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(Constants.offlineSyncInsertOverallChecking),
      );
      request.headers['Authorization'] = 'Bearer $token';
      request.fields.addAll(
        data.map(
          (key, value) => MapEntry(
            key,
            value.toString(),
          ),
        ),
      );
      if (files != null) {
        for (var file in files) {
          var stream = http.ByteStream(
            file.openRead(),
          );
          var length = await file.length();
          var multipartFile = http.MultipartFile(
            'pictures',
            stream,
            length,
            filename: basename(file.path),
          );
          request.files.add(multipartFile);
        }
      }

      var streamedResponse = await ioClient.send(request);
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 201) {
        return ApiResponse(
          statusCode: response.statusCode,
          message: getResponseMessage(response),
        );
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

  Future<ApiResponse<dynamic>> insertServiceReportOffline(
      List<File>? files, Map<String, dynamic> data) async {
    final token = await _tokenManager.getValidToken();
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(Constants.offlineSyncServiceReportChecking),
      );
      request.headers['Authorization'] = 'Bearer $token';
      request.fields.addAll(
        data.map(
          (key, value) => MapEntry(
            key,
            value.toString(),
          ),
        ),
      );
      if (files != null) {
        for (var file in files) {
          var stream = http.ByteStream(
            file.openRead(),
          );
          var length = await file.length();
          var multipartFile = http.MultipartFile(
            'pictures',
            stream,
            length,
            filename: basename(file.path),
          );
          request.files.add(multipartFile);
        }
      }

      var streamedResponse = await ioClient.send(request);
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 201) {
        return ApiResponse(
          statusCode: response.statusCode,
          message: getResponseMessage(response),
        );
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

  Future<ApiResponse<String>> insertJobFinishOffline({
    required Map<String, String> fields,
    File? signFile,
    File? mechanicSignFile,
  }) async {
    final token = await _tokenManager.getValidToken();

    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse(Constants.offlineSyncJobFinish),
      );
      request.headers['Authorization'] = 'Bearer $token';

      // Add form fields
      request.fields.addAll(fields);

      // Add sign file
      if (signFile != null) {
        final sanitizedPath = signFile.path.replaceAll('"', '').trim();
        final file = File(sanitizedPath);
        if (file.existsSync()) {
          request.files
              .add(await http.MultipartFile.fromPath('sign', sanitizedPath));
        } else {
          debugPrint('❌ Sign image file does not exist at path:');
        }
      } else {
        debugPrint('❌ Sign image file is null');
      }

      // Add mechanic sign file
      if (mechanicSignFile != null) {
        final sanitizedPath = mechanicSignFile.path.replaceAll('"', '').trim();
        final file = File(sanitizedPath);
        if (file.existsSync()) {
          request.files.add(await http.MultipartFile.fromPath(
              'mechanic_sign', sanitizedPath));
        } else {
          debugPrint('❌ Mechanic signature image file does not exist at path:');
        }
      } else {
        debugPrint('❌ Mechanic signature image file is null');
      }

      var streamedResponse = await ioClient.send(request);
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        return ApiResponse(statusCode: 201, message: "Synced successfully");
      } else {
        return ApiResponse(
          error: getResponseErrorMessage(response),
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      return ApiResponse(error: getCatchExceptionMessage(e), statusCode: 503);
    }
  }

  Future<ApiResponse<dynamic>> updateUpdateStageFieldServiceOffline(
      Map<String, dynamic> data) async {
    final token = await _tokenManager.getValidToken();

    try {
      final response = await ioClient.put(
        Uri.parse(Constants.stageFieldService),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(data),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        final res = json.decode(response.body);
        return ApiResponse(
            data: res['result'],
            statusCode: response.statusCode,
            message: res['message']);
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
