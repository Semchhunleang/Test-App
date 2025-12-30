import 'package:jwt_decoder/jwt_decoder.dart';

Map<String, dynamic> decodeToken(String? token) {
  Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);

  var decoded = decodedToken;
  return decoded;
}
