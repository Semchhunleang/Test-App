import 'package:flutter/foundation.dart';
import 'package:umgkh_mobile/models/base/custom_ui/api_response.dart';
import 'package:umgkh_mobile/models/base/user/department.dart';
import 'package:umgkh_mobile/models/base/user/user.dart'; // Adjust import path based on your project structure
import 'package:umgkh_mobile/models/base/user/work_location.dart';
import 'package:umgkh_mobile/services/api/base/user/user_service.dart';
import 'package:umgkh_mobile/services/local_storage/models/token_local_storage_service.dart';
// import 'package:umgkh_mobile/services/local_storage/models/user_local_storage_service.dart';

class SettingViewModel extends ChangeNotifier {
  final UserAPIService _userService = UserAPIService();
  final TokenLocalStorageService _tokenLocalStorageService =
      TokenLocalStorageService();
  // final UserLocalStorageService _userLocalStorageService =
  //     UserLocalStorageService();
  User _user = User(
    id: 0,
    userId: 0,
    name: '',
    username: '',
    registrationNumber: '',
    jobTitle: '',
    workLocation: WorkLocation(
        id: 0,
        name: '',
        coordinate: null), 
    department: Department(
        id: 0, name: '', code: ''), 
  );
  bool _isLoading = false;

  User get user => _user;
  bool get isLoading => _isLoading;

  Future<void> fetchUserData() async {
    _isLoading = true;
    _user = User(
    id: 0,
    userId: 0,
    name: '',
    username: '',
    registrationNumber: '',
    jobTitle: '',
    workLocation: WorkLocation(
        id: 0,
        name: '',
        coordinate: null), 
    department: Department(
        id: 0, name: '', code: ''), 
  );
    notifyListeners();

    String? token = await _tokenLocalStorageService.getToken();
    final ApiResponse<User> response = await _userService.fetchUserData(token);
    if (response.error == null) {
      // await _userLocalStorageService.deleteUser();
      // await _userLocalStorageService.saveUser(response.data!);
      // _user = response.data!;
    } else {
      _user = User(
        id: 0,
        userId: 0,
        name: '',
        username: '',
        registrationNumber: '',
        jobTitle: '',
        workLocation: WorkLocation(
            id: 0,
            name: '',
            coordinate: null), 
        department: Department(
            id: 0,
            name: '',
            code: ''), 
      );
    }
    _isLoading = false;
    notifyListeners(); // Notify listeners when loading is complete
  }
}
