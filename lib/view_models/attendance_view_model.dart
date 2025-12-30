import 'dart:io';
import 'package:flutter/material.dart';
import 'package:umgkh_mobile/models/base/custom_ui/api_response.dart';
import 'package:umgkh_mobile/models/hr/attendance/attendance.dart';
import 'package:umgkh_mobile/models/base/user/user.dart';
import 'package:umgkh_mobile/models/base/user/work_location_coordinate.dart';
import 'package:umgkh_mobile/services/api/hr/attendance/attendance_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as maps;
import 'package:umgkh_mobile/services/local_storage/models/user_local_storage_service.dart';
import 'package:umgkh_mobile/utils/location_service.dart';
import 'package:umgkh_mobile/utils/show_dialog.dart';

class AttendanceViewModel extends ChangeNotifier {
  final UserLocalStorageService _userLocalStorageService =
      UserLocalStorageService();
  List<Attendance> _attendances = [];
  String _latestState = 'ci';
  bool _isLoading = false;
  bool _isChecking = false;
  bool _isLocationCorrect = false;
  String _reason = '';
  DateTime _endDate = DateTime.now();
  DateTime _startDate = DateTime(DateTime.now().year - 1, 12, 26);
  String _errorMessage = '';
  int _apiStatusCode = 200;
  String _distanceText = "";
  String _reasonInsert = "";

  List<Attendance> get attendances => _attendances;
  String get latestState => _latestState;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get isLocationCorrect => _isLocationCorrect;
  String get reason => _reason;
  DateTime get endDate => _endDate;
  DateTime get startDate => _startDate;
  int get apiStatusCode => _apiStatusCode;
  String get distanceText => _distanceText;
  String get reasonInsert => _reasonInsert;

  void setIsLoading(bool load) {
    notifyListeners();
    _isLoading = load;
    notifyListeners();
  }

  Future<void> setDate(DateTime date, bool isStart) async {
    notifyListeners();
    if (isStart) {
      _startDate = date;
    } else {
      _endDate = date;
    }
    fetchAttendances();
    notifyListeners();
  }

  Future<void> setReason(String reason) async {
    notifyListeners();
    _reason = reason;
    _reasonInsert = '$_distanceText \nReason: $_reason';
    notifyListeners();
  }

  Future<void> fetchAttendances() async {
    _isLoading = true;
    _errorMessage = "";
    notifyListeners();

    final response =
        await AttendanceAPIService().fetchAttendance(startDate, endDate);
    if (response.error == null) {
      List<Attendance> attendances = response.data!;

      if (attendances[0].checkOut != null) {
        _latestState = 'ci';
      } else if (attendances[0].checkInAfternoon != null) {
        _latestState = 'co';
      } else if (attendances[0].checkOutMorning != null) {
        _latestState = 'cia';
      } else {
        _latestState = 'com';
      }
      _attendances = attendances;
    } else {
      _latestState = 'ci';
      _attendances = [];
      _errorMessage = response.error!;
    }
    _apiStatusCode = response.statusCode;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> checkIn(BuildContext context, File? picture) async {
    if (_isChecking) return;
    _isChecking = true;
    _isLoading = true;
    notifyListeners();
    ApiResponse response;
    if (picture != null) {
      response = await AttendanceAPIService().checkIn(reasonInsert, picture);
    } else {
      response = await AttendanceAPIService().checkIn(reasonInsert, null);
    }
    if (context.mounted) {
      await showResultDialog(context, response.error ?? response.message!,
          isDone: true, isBackToList: false);
    }
    _isChecking = false;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> checkOutMorning(BuildContext context, File? picture) async {
    if (_isChecking) return;
    _isChecking = true;
    _isLoading = true;
    notifyListeners();

    ApiResponse response;
    if (picture != null) {
      response =
          await AttendanceAPIService().checkOutMorning(reasonInsert, picture);
    } else {
      response =
          await AttendanceAPIService().checkOutMorning(reasonInsert, null);
    }

    if (context.mounted) {
      await showResultDialog(context, response.error ?? response.message!,
          isDone: true, isBackToList: false);
    }
    _isChecking = false;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> checkInAfternoon(BuildContext context, File? picture) async {
    if (_isChecking) return;
    _isChecking = true;
    _isLoading = true;
    notifyListeners();

    ApiResponse response;
    if (picture != null) {
      response =
          await AttendanceAPIService().checkInAfternoon(reasonInsert, picture);
    } else {
      response =
          await AttendanceAPIService().checkInAfternoon(reasonInsert, null);
    }

    if (context.mounted) {
      await showResultDialog(context, response.error ?? response.message!,
          isDone: true, isBackToList: false);
    }
    _isChecking = false;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> checkOut(BuildContext context, File? picture) async {
    if (_isChecking) return;
    _isChecking = true;
    _isLoading = true;
    notifyListeners();

    ApiResponse response;
    if (picture != null) {
      response = await AttendanceAPIService().checkOut(reasonInsert, picture);
    } else {
      response = await AttendanceAPIService().checkOut(reasonInsert, null);
    }

    if (context.mounted) {
      await showResultDialog(context, response.error ?? response.message!,
          isDone: true, isBackToList: false);
    }
    _isChecking = false;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> checkLocationInPolygon(double latitude, double longitude) async {
    final LocationService locationService = LocationService();
    _isLoading = true;

    notifyListeners();
    maps.LatLng point = maps.LatLng(latitude, longitude);
    List<maps.LatLng> polygon = [];

    User? user = await _userLocalStorageService.getUser();
    if (user != null &&
        user.workLocation != null &&
        user.workLocation!.coordinate != null &&
        user.workLocation!.coordinate!.isNotEmpty) {
      for (WorkLocationCoordinate coordinate
          in user.workLocation!.coordinate!) {
        polygon.add(
          maps.LatLng(coordinate.latitude!, coordinate.longitude!),
        );
      }
      _distanceText =
          'Location: $point \nDistancte: ${locationService.distanceToPolygon(point, polygon)}';
      _reasonInsert = '$_distanceText \nReason: $_reason';
      _isLocationCorrect = locationService.isPointInPolygon(point, polygon);
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> checkOutSaturday(BuildContext context, File? picture) async {
    if (_isChecking) return;
    _isChecking = true;
    _isLoading = true;
    notifyListeners();
    ApiResponse response;

    if (picture != null) {
      await AttendanceAPIService().checkOutMorning(reasonInsert, picture);
      await AttendanceAPIService().checkInAfternoon(reasonInsert, picture);
      response = await AttendanceAPIService().checkOut(reasonInsert, picture);
    } else {
      await AttendanceAPIService().checkOutMorning(reasonInsert, null);
      await AttendanceAPIService().checkInAfternoon(reasonInsert, null);
      response = await AttendanceAPIService().checkOut(reasonInsert, null);
    }

    if (context.mounted) {
      await showResultDialog(context, response.error ?? response.message!,
          isDone: true, isBackToList: false);
    }
  }
}
