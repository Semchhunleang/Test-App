import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:umgkh_mobile/services/api/base/auth/token_service.dart';
import 'package:umgkh_mobile/utils/constants.dart';
import 'dart:io';
import 'package:http/io_client.dart';

class UtilAPIService {
  final AuthAPIService _tokenManager = AuthAPIService();
  final ioClient = IOClient(HttpClient()..findProxy = (_) => "DIRECT");

  Future<List<String>?> getCarousel() async {
    final response = await ioClient.get(Uri.parse(Constants.carouselUrl),);
    if (response.statusCode == 200) {
      // Successful carousel
      return (jsonDecode(response.body) as List)
          .map((item) => item as String)
          .toList();
    } else {
      // Failed to carousel
      return null;
    }
  }

  Future<bool> insertFCMToken(String fcmToken) async {
    
    final token = await _tokenManager.getValidToken();

    final response = await ioClient.post(
      Uri.parse(Constants.insertFCMToken),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'token': fcmToken,
      }),
    );
    return response.statusCode == 201;
  }
}
