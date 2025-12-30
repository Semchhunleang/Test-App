import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:umgkh_mobile/models/base/auth/token.dart';
import 'package:umgkh_mobile/services/local_storage/models/token_local_storage_service.dart';
import 'package:umgkh_mobile/models/base/custom_ui/api_response.dart';
import 'package:umgkh_mobile/utils/constants.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'dart:io';
import 'package:http/io_client.dart';

class AuthAPIService {
  final TokenLocalStorageService _tokenLocalStorageService =
      TokenLocalStorageService();
  final ioClient = IOClient(HttpClient()..findProxy = (_) => "DIRECT");

  Future<ApiResponse<Token>?> login(String username, String password) async {
    return await _retryOnNetworkChange(() async {
      try {
        final response = await ioClient
            .post(
              Uri.parse(Constants.loginUrl),
              headers: <String, String>{
                'Content-Type': 'application/json',
              },
              body: jsonEncode(<String, String>{
                'username': username,
                'password': password,
              }),
            )
            .timeout(
              const Duration(seconds: 10),
            ); // Set timeout duration

        if (response.statusCode == 200) {
          return ApiResponse(
              data: Token.fromJson(
                jsonDecode(response.body),
              ),
              statusCode: response.statusCode);
        } else {
          return ApiResponse(
              error: getResponseErrorMessage(response),
              statusCode: response.statusCode);
        }
      } catch (e) {
        return ApiResponse(error: getCatchExceptionMessage(e), statusCode: 503);
      }
    });
  }

  Future<ApiResponse<String>?> getToken() async {
    final data = await _tokenLocalStorageService.getToken();
    if (data != null) {
      return ApiResponse(data: data, statusCode: 200);
    } else {
      return ApiResponse(error: 'Token is null!', statusCode: 404);
    }
  }

  Future<ApiResponse<String>?> refreshAndGetToken() async {
    final response = await getToken();
    if (response != null && response.error == null) {
      // Map<String, dynamic> decodedToken = JwtDecoder.decode(response.data!);

      // bool hasExpired = JwtDecoder.isExpired(response.data!);
      // if (hasExpired) {
      bool? success = await _retryOnNetworkChange(() async {
        bool refreshedToken = await _refreshToken(response.data!);
        return refreshedToken;
      });
      if (success == true) {
        ApiResponse<String>? tkn = await getToken();
        return tkn;
      }
      // } else {
      //   return await getToken();
      // }
    }
    return null;
  }

  Future<bool> _refreshToken(String token) async {
    try {
      final response = await ioClient.post(
        Uri.parse(Constants.refreshTokenUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(
        const Duration(seconds: 15),
      ); // Set timeout duration

      if (response.statusCode == 200) {
        // Token refreshed successfully, update local storage
        var jsonResponse = jsonDecode(response.body);
        await _tokenLocalStorageService.saveToken(jsonResponse['token']);
        return true;
      } else {
        // Token refresh failed
        return false;
      }
    } catch (e) {
      // Handle exception or timeout
      return false;
    }
  }

  Future<bool> _isServerReachable() async {
    try {
      final response = await ioClient
          .head(
            Uri.parse(
                'http://96.x.xx.xxx:7400'), // Replace with your server's base URL or health check endpoint
          )
          .timeout(
            const Duration(seconds: 30),
          ); // Set timeout duration
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<T?> _retryOnNetworkChange<T>(Future<T?> Function() action) async {
    // Check the current network status
    List<ConnectivityResult> result = await Connectivity().checkConnectivity();
    // If there's a connection, perform the action immediately
    if (result[0] != ConnectivityResult.none && await _isServerReachable()) {
      return await action();
    }

    // Otherwise, listen for network changes
    final completer = Completer<T?>();
    final subscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) async {
      if (result[0] != ConnectivityResult.none && await _isServerReachable()) {
        completer.complete(
          await action(),
        );
      }
    });

    // Wait for either a network change or a timeout
    final timeoutFuture =
        Future.delayed(const Duration(seconds: 20), () => null);
    final resultFuture = await Future.any([completer.future, timeoutFuture]);

    // Cancel the subscription if it's still active
    await subscription.cancel();

    return resultFuture;
  }

  Future<bool> isUrlReachable() async {
    try {
      final response = await ioClient.get(
        Uri.parse(Constants.ip),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<String?> getValidToken() async {
    bool? isReachAble = await isUrlReachable();
    if (isReachAble) {
      ApiResponse<String>? responseToken = await refreshAndGetToken();
      if (responseToken == null ||
          responseToken.error != null ||
          responseToken.data == null) {
        return null;
      }
      return responseToken.data;
    } else {
      return 'server_unreachable';
    }
  }

  Future<ApiResponse<String>> changePassword(data) async {
    final token = await AuthAPIService().getValidToken();
    try {
      final response = await ioClient.put(
        Uri.parse(Constants.updatePasswordUrl),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
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
}
