import 'package:flutter/material.dart';
import 'package:umgkh_mobile/services/api/base/auth/token_service.dart';
import 'package:umgkh_mobile/services/local_storage/models/token_local_storage_service.dart';
import 'package:umgkh_mobile/views/pages/onboarding/login/index.dart';
import 'package:umgkh_mobile/widgets/screen_container.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthAPIService _authService = AuthAPIService();
  final TokenLocalStorageService _tokenLocalStorageService =
      TokenLocalStorageService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> login(
      BuildContext context, String username, String password) async {
    _isLoading = true;
    notifyListeners();

    final response = await _authService.login(username, password);
    if (response != null && response.error == null) {
      await _tokenLocalStorageService.saveToken(response.data!.token);
      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const ScreenContainer(
              pageIndex: 0,
            ),
          ),
        );
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login failed'),
          ),
        );
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> checkToken() async {
    String? token = await _tokenLocalStorageService.getToken();
    return token != null;
  }

  Future<void> logout(BuildContext context) async {
    await _tokenLocalStorageService.deleteToken();
    if (context.mounted) {
      // Navigator.of(context).pushReplacementNamed(LoginPage.routeName);
      Navigator.of(context).pushNamedAndRemoveUntil(LoginPage.routeName, (route) => false);
    }
  }
}
