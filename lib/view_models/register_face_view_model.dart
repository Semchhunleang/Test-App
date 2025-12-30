import 'package:flutter/material.dart';
import 'package:umgkh_mobile/models/base/custom_ui/api_response.dart';
import 'package:umgkh_mobile/services/api/base/user/user_service.dart';
import 'package:umgkh_mobile/utils/show_dialog.dart';

class RegisterFaceViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool _isChecking = false;

  bool get isLoading => _isLoading;

  void setIsLoading(bool load) {
    notifyListeners();
    _isLoading = load;
    notifyListeners();
  }

  Future<void> registerFace(BuildContext context, String? landmarks) async {
    if (_isChecking) return;
    _isChecking = true;
    _isLoading = true;
    notifyListeners();

    ApiResponse response = await UserAPIService().registerFace(landmarks);
    

    if (context.mounted) {
      await showResultDialog(context, response.error ?? response.message!,
          isDone: true, isBackToList: false);
    }
    _isChecking = false;
    _isLoading = false;
    notifyListeners();
  }
}