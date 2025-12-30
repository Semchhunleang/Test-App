import 'dart:io';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:umgkh_mobile/models/base/data/nenam_version.dart';
import 'package:umgkh_mobile/models/umg/nenam_store_link.dart';
import 'package:umgkh_mobile/services/api/nenam_utils/nenam_utils_service.dart';
import 'package:umgkh_mobile/widgets/dialog.dart';

class NenamVersionViewModel extends ChangeNotifier {
  List<NenamVersion> _nenamVersion = [];
  List<NenamStoreLink> _nenamStoreLink = [];

  List<NenamVersion> get nenamVersion => _nenamVersion;
  List<NenamStoreLink> get nenamStoreLink => _nenamStoreLink;

  Future<void> fetchNenamVersion(BuildContext context) async {
    final response = await NenamUtilsAPIService().fetchNenamVersion();

    if (response.error != null) {
      debugPrint("_errorMessage nenam version: ${response.error}");
    } else if (response.data != null) {
      _nenamVersion = response.data ?? [];
    }

    await fetchNenamStoreLink();

    if (!context.mounted) return;
    await checkAppVersion(context);

    notifyListeners();
  }

  Future<void> fetchNenamStoreLink() async {
    final response = await NenamUtilsAPIService().fetchNenamStoreLink();
    if (response.error != null) {
      debugPrint("_errorMessage nenam store link: ${response.error}");
    } else if (response.data != null) {
      _nenamStoreLink = response.data ?? [];
    }
    notifyListeners();
  }

  Future checkAppVersion(BuildContext context) async {
    String localVersion = await getAppVersion();
    DateTime now = DateTime.now();
    DateTime localDt = DateTime(now.year, now.month, now.day);
    debugPrint('=======localDt: $localDt =======localVersion: $localVersion');
    String link = nenamStoreLink
        .firstWhere((e) => e.code == (Platform.isAndroid ? 'android' : 'ios'))
        .link;
    if (nenamVersion.isNotEmpty) {
      for (var e in nenamVersion) {
        DateTime apiDt = e.activeDate;
        String apiVersion = e.version;
        debugPrint('=======apiDt: $apiDt =======apiVersion: $apiVersion');

        // check if this version is active (today or before)
        if (localDt.isAfter(apiDt) || localDt.isAtSameMomentAs(apiDt)) {
          // check if app version matches this required version
          if (isCurrentVersionSmaller(localVersion, apiVersion)) {
            if (!context.mounted) return;
            showWarningUpdateNenamDialog(
                context, localVersion, apiVersion, link);
          } else {
            debugPrint('✅ App version is up to date.');
          }
          break; // only check the first valid (latest active) version
        }
      }
    }
  }

  bool isCurrentVersionSmaller(String current, String required) {
    List<int> currentParts = current.split('.').map(int.parse).toList();
    List<int> requiredParts = required.split('.').map(int.parse).toList();
    for (int i = 0; i < currentParts.length; i++) {
      if (currentParts[i] < requiredParts[i]) return true;
      if (currentParts[i] > requiredParts[i]) return false;
    }
    return false; // versions are equal
  }

  Future<String> getAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    return info.version;
  }
}
