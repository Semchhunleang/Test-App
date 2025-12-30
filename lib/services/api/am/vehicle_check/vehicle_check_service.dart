import 'dart:async';
import 'dart:convert';
import 'dart:io';
import '../../../../models/am/vehicle_check/row_data.dart';
import '../../../../models/am/vehicle_check/vehicle_check.dart';
import '../../../../models/base/custom_ui/api_response.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/utlis.dart';
import '../../base/auth/token_service.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class VehicleCheckService {
  final AuthAPIService _tokenManager = AuthAPIService();
  final ioClient = IOClient(HttpClient()..findProxy = (_) => "DIRECT");

  Future<ApiResponse<List<VehicleCheck>>> fetchAllVehicleCheck() async {
    try {
      final token = await _tokenManager.getValidToken();
      final response = await ioClient.get(
        Uri.parse(Constants.getAllVehicleCheck),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final vehicleCheckList = (data as List<dynamic>?)
                ?.map((item) =>
                    VehicleCheck.fromJson(item as Map<String, dynamic>),)
                .toList() ??
            [];

        return ApiResponse(
            data: vehicleCheckList, statusCode: response.statusCode);
      } else {
        return ApiResponse(
            error: getResponseErrorMessage(response),
            statusCode: response.statusCode);
      }
    } on TimeoutException catch (_) {
      return ApiResponse(error: 'Request timed out', statusCode: 408);
    } catch (e) {
      return ApiResponse(
          error: 'Error fetching all vehicle check data: $e', statusCode: 504);
    }
  }

  Future<ApiResponse<VehicleCheck>> fetchVehicleCheckById(int id) async {
    try {
      final token = await _tokenManager.getValidToken();
      final response = await ioClient.get(
        Uri.parse(Constants.getVehicleCheckById(id),),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final vehicleCheck =
            VehicleCheck.fromJson(data as Map<String, dynamic>);

        return ApiResponse(
          data: vehicleCheck,
          statusCode: response.statusCode,
        );
      } else {
        return ApiResponse(
          error: getResponseErrorMessage(response),
          statusCode: response.statusCode,
        );
      }
    } on TimeoutException catch (_) {
      return ApiResponse(error: 'Request timed out', statusCode: 408);
    } catch (e) {
      return ApiResponse(
        error: 'Error fetching vehicle check data: $e',
        statusCode: 504,
      );
    }
  }

  Future<ApiResponse<String>> insertVehicleCheck(data) async {
    try {
      final token = await _tokenManager.getValidToken();
      final response = await ioClient.post(Uri.parse(Constants.createVehicleCheck),
          headers: <String, String>{
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json'
          },
          body: jsonEncode(data),);
      if (response.statusCode == 201) {
        return ApiResponse(
            statusCode: response.statusCode,
            message: getResponseMessage(response),);
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

  Future<ApiResponse<String>> updateVehicleCheck(data) async {
    final token = await _tokenManager.getValidToken();
    try {
      final response = await ioClient.put(Uri.parse(Constants.updateVehicleCheck),
          headers: <String, String>{
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json'
          },
          body: jsonEncode(data),);
      if (response.statusCode == 201) {
        return ApiResponse(
            statusCode: response.statusCode,
            message: getResponseMessage(response),);
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

  Future<ApiResponse<RowData>> updateRowById(data, int id) async {
    final token = await _tokenManager.getValidToken();
    try {
      final response = await ioClient.put(
        Uri.parse(Constants.updateRowsById(id),),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        final rowData = RowData.fromJson(jsonDecode(response.body),);
        return ApiResponse(
          data: rowData,
          statusCode: response.statusCode,
          message: getResponseMessage(response),
        );
      } else {
        return ApiResponse(
          message: getResponseMessage(response),
          error: getResponseErrorMessage(response),
          statusCode: response.statusCode,
        );
      }
    } on TimeoutException catch (_) {
      return ApiResponse(error: 'Request timed out', statusCode: 408);
    } catch (e) {
      return ApiResponse(error: getCatchExceptionMessage(e), statusCode: 503);
    }
  }

  Future<ApiResponse<String>> updateRowInoutById(data, int id) async {
    final token = await _tokenManager.getValidToken();
    try {
      final response = await ioClient.put(
        Uri.parse(Constants.updateRowInoutById(id),),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return ApiResponse(
          statusCode: response.statusCode,
          message: getResponseMessage(response),
        );
      } else {
        return ApiResponse(
          message: getResponseMessage(response),
          error: getResponseErrorMessage(response),
          statusCode: response.statusCode,
        );
      }
    } on TimeoutException catch (_) {
      return ApiResponse(error: 'Request timed out', statusCode: 408);
    } catch (e) {
      return ApiResponse(error: getCatchExceptionMessage(e), statusCode: 503);
    }
  }

}
