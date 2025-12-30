import 'dart:io';
import 'package:camera/camera.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:umgkh_mobile/services/api/nenam_utils/nenam_utils_service.dart';

class AppInfoiewModel extends ChangeNotifier {
  bool isCameraEnable = false, isLocationEnable = false, isNotifEnable = false;
  String version = "1.0.0";
  DateTime? releaseDT;

  // =========================== VERSION ===========================

  Future<void> getAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    version = info.version;
    notifyListeners();
  }

  Future<void> fetchNenamVersion() async {
    final response = await NenamUtilsAPIService().fetchNenamVersion();
    if (response.error != null) {
      debugPrint("_errorMessage nenam version: ${response.error}");
    } else if (response.data != null && response.data!.isNotEmpty) {
      // sort to get the latest date
      response.data!.sort((a, b) => b.activeDate.compareTo(a.activeDate));
      // set latest release date directly
      releaseDT = response.data!.first.activeDate;
      debugPrint("Latest release date: $releaseDT");
    }
    notifyListeners();
  }
  // --------------------------- END ---------------------------

  // =========================== CAMERA ===========================
  Future<void> checkCameraStatus() async {
    // Android only
    if (Platform.isAndroid) {
      isCameraEnable = await Permission.camera.status.isGranted;
      notifyListeners();
      return;
    }
    // work on both IOS & Android
    int cameraIndex = -1;
    try {
      final cameras = await availableCameras();
      for (var i = 0; i < cameras.length; i++) {
        if (cameras[i].lensDirection == CameraLensDirection.front) {
          cameraIndex = i;
          break;
        }
      }

      if (cameraIndex == -1) {
        isCameraEnable = false;
        notifyListeners();
        return;
      }

      final cameraCtrl = CameraController(
          cameras[cameraIndex], ResolutionPreset.low,
          enableAudio: false);
      await cameraCtrl.initialize();
      isCameraEnable = true;
      await cameraCtrl.dispose();
    } catch (e) {
      debugPrint('Camera error: $e');
      isCameraEnable = false;
    }
    notifyListeners();
  }

  Future<void> onSwitchCamera(bool value) async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      if (!value) await openAppSettings(); // OFF camera
    } else if (status.isPermanentlyDenied || status.isDenied) {
      await openAppSettings(); // ON camera
    }
  }
  // --------------------------- END ---------------------------

  // =========================== LOCATION ===========================
  Future<void> checkLocationStatus() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    LocationPermission permission = await Geolocator.checkPermission();
    bool isPermEnable = permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
    debugPrint('location service =========== $serviceEnabled');
    debugPrint('location permission =========== $permission: $isPermEnable');

    isLocationEnable = serviceEnabled && isPermEnable;
    notifyListeners();
  }

  Future<void> onSwitchLocation(bool value) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (value) {
      if (!serviceEnabled && Platform.isAndroid) {
        await Geolocator.openLocationSettings();
      } else {
        final permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.deniedForever ||
            permission == LocationPermission.denied) {
          await openAppSettings();
        }
      }
    } else {
      await openAppSettings();
    }
  }
  // --------------------------- END ---------------------------

  // =========================== NOTIFICATION ===========================
  Future<void> checkNotificationStatus() async {
    final status = await FirebaseMessaging.instance.getNotificationSettings();
    isNotifEnable =
        status.authorizationStatus == AuthorizationStatus.authorized;
    notifyListeners();
  }

  Future<void> onSwitchNotification(bool value) async {
    await openAppSettings();
  }
  // --------------------------- END ---------------------------
}
