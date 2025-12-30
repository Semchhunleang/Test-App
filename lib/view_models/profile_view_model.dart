import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:umgkh_mobile/models/base/custom_ui/api_response.dart';
import 'package:umgkh_mobile/models/base/user/department.dart';
import 'package:umgkh_mobile/models/base/user/user.dart'; // Adjust import path based on your project structure
import 'package:umgkh_mobile/models/base/user/work_location.dart';
import 'package:umgkh_mobile/services/api/base/user/user_service.dart';
import 'package:umgkh_mobile/services/local_storage/models/token_local_storage_service.dart';
import 'package:umgkh_mobile/services/local_storage/models/user_local_storage_service.dart';

class ProfileViewModel extends ChangeNotifier {
  final UserAPIService _userService = UserAPIService();
  final TokenLocalStorageService _tokenLocalStorageService =
      TokenLocalStorageService();
  final UserLocalStorageService _userLocalStorageService =
      UserLocalStorageService();
  User _user = User(
    id: 0,
    userId: 0,
    name: '',
    username: '',
    registrationNumber: '',
    jobTitle: '',
    workLocation: WorkLocation(id: 0, name: '', coordinate: null),
    department: Department(id: 0, name: '', code: ''),
  );
  Uint8List _profilePicture = Uint8List(0); // Initialize with empty Uint8List
  bool _isLoading = false;

  User get user => _user;
  Uint8List get profilePicture => _profilePicture;
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
      workLocation: WorkLocation(id: 0, name: '', coordinate: null),
      department: Department(id: 0, name: '', code: ''),
    );
    notifyListeners();

    String? token = await _tokenLocalStorageService.getToken();
    final ApiResponse<User> response = await _userService.fetchUserData(token);
    if (response.error == null) {
      await _userLocalStorageService.deleteUser();
      await _userLocalStorageService.saveUser(response.data!);
      _user = response.data!;
    } else {
      final parts = token!.split('.');

      if (parts.length != 3) {
        throw Exception("Invalid JWT token");
      }

      final payload = parts[1];
      final normalizedPayload = base64Url.normalize(payload);
      final decodedPayload = utf8.decode(
        base64Url.decode(normalizedPayload),
      );
      final payloadMap = json.decode(decodedPayload);
      User? localData =
          await _userLocalStorageService.getUserById(payloadMap['employee_id']);
      if (localData != null) {
        _user = localData;
      } else {
        _user = User(
          id: 0,
          userId: 0,
          name: '',
          username: '',
          registrationNumber: '',
          jobTitle: '',
          workLocation: WorkLocation(id: 0, name: '', coordinate: null),
          department: Department(id: 0, name: '', code: ''),
        );
      }
    }
    _isLoading = false;
    notifyListeners(); // Notify listeners when loading is complete
  }

  Future<void> getProfilePicture() async {
    _isLoading = true;
    notifyListeners(); // Notify listeners when loading state changes

    String? token = await _tokenLocalStorageService.getToken();
    final ApiResponse<Uint8List> response =
        await _userService.getProfilePicture(token);
    if (response.error == null) {
      _profilePicture = response.data!;
    } else {
      _profilePicture = Uint8List(0);
    }
    _isLoading = false;
    notifyListeners();
  }

  bool isErp() => (user.department?.code ?? '') == 'ERP';
  bool isICT() => (user.department?.code ?? '') == 'ICT';
}
