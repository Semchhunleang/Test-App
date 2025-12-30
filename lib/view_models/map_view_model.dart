import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:umgkh_mobile/models/base/user/user.dart';
import 'package:umgkh_mobile/models/base/user/work_location_coordinate.dart';
import 'package:umgkh_mobile/services/local_storage/models/user_local_storage_service.dart';

class AttendanceAreaViewModel extends ChangeNotifier {
  final UserLocalStorageService _userLocalStorageService =
      UserLocalStorageService();
  List<WorkLocationCoordinate> _points = [];
  bool _isLoading = false;

  List<LatLng> get latLngPoints => _points
      .map(
        (point) => LatLng(point.latitude!, point.longitude!),
      )
      .toList();
  bool get isLoading => _isLoading;

  Future<void> setPoints() async {
    _isLoading = true;
    notifyListeners();
    User? user = await _userLocalStorageService.getUser();
    _points = user!.workLocation!.coordinate!;
    _isLoading = false;
    notifyListeners();
  }

  LatLng getPolygonCentroid() {
    double latitude = 0;
    double longitude = 0;
    final int count = _points.length;

    for (var point in _points) {
      latitude += point.latitude!;
      longitude += point.longitude!;
    }

    return count == 0
        ? const LatLng(0, 0)
        : LatLng(latitude / count, longitude / count);
  }
}
