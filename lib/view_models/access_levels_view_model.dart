import 'package:flutter/material.dart';
import 'package:umgkh_mobile/models/base/auth/access_level.dart';
import 'package:umgkh_mobile/services/api/base/auth/access_levels_service.dart';
import 'package:umgkh_mobile/services/local_storage/models/access_level_local_storage_service.dart';

class AccessLevelViewModel extends ChangeNotifier {
  final AccessLevelLocalStorageService _accessLevelLocalStorageService =
      AccessLevelLocalStorageService();
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  AccessLevel _accessLevel = const AccessLevel(
    isDh: 0,
    isHc: 0,
    isHrd: 0,
    isHrc: 0,
    isUnderLevel: 0,
    a4: 0,
    tsb: 0,
    isAmDh: 0,
    isCrmUnit: 0,
    isCrmSparepart: 0,
    smallPaper: 0,
    scanSmallPaper: 0,
    vehicleCheck: 0,
    scanVehicleCheck: 0,
    fieldService: 0,
    workshop: 0,
    isAfterSalesGeneralManager: 0,
    isFieldServiceGeneralManager: 0,
    isAdminHead: 0,
    isReadRequestOT: 0,
    isReadOT: 0,
    isSubmitRequestOT: 0,
    isSubmitOT: 0,
    isApproveOT: 0,
  );
  AccessLevel get accessLevel => _accessLevel;
  // getAccessLevel

  /// ********* Get data of Check is DH ****************************
  Future<void> fetchAccessLevel() async {
    _isLoading = true;
    notifyListeners();

    final response = await AccessLevelAPIService().fetchAccessLevel();
    if (response.data != null) {
      _accessLevel = response.data!;
      _accessLevelLocalStorageService.saveAccessLevel(
        _accessLevel.isDh,
        _accessLevel.isHc,
        _accessLevel.isHrd,
        _accessLevel.isHrc,
        _accessLevel.isUnderLevel,
        _accessLevel.a4,
        _accessLevel.tsb,
        _accessLevel.isAmDh,
        _accessLevel.isCrmUnit,
        _accessLevel.isCrmSparepart,
        _accessLevel.smallPaper,
        _accessLevel.scanSmallPaper,
        _accessLevel.vehicleCheck,
        _accessLevel.scanVehicleCheck,
        _accessLevel.fieldService,
        _accessLevel.workshop,
        _accessLevel.isAfterSalesGeneralManager,
        _accessLevel.isFieldServiceGeneralManager,
        _accessLevel.isAdminHead,
        _accessLevel.isReadRequestOT,
        _accessLevel.isReadOT,
        _accessLevel.isSubmitRequestOT,
        _accessLevel.isSubmitOT,
        _accessLevel.isApproveOT,
      );

    }

    _isLoading = false;
    notifyListeners();
  }

  void fetchLocal() async {
    AccessLevel? accessLevels =
        await _accessLevelLocalStorageService.getAccessLevel();
    if (accessLevels != null) {
      _accessLevel = accessLevels;
    } else {
      _accessLevel = const AccessLevel(
        isDh: 0,
        isHc: 0,
        isHrd: 0,
        isHrc: 0,
        isUnderLevel: 0,
        a4: 0,
        tsb: 0,
        isAmDh: 0,
        isCrmUnit: 0,
        isCrmSparepart: 0,
        smallPaper: 0,
        scanSmallPaper: 0,
        vehicleCheck: 0,
        scanVehicleCheck: 0,
        fieldService: 0,
        workshop: 0,
        isAfterSalesGeneralManager: 0,
        isFieldServiceGeneralManager: 0,
        isAdminHead: 0,
        isReadRequestOT: 0,
        isReadOT: 0,
        isSubmitRequestOT: 0,
        isSubmitOT: 0,
        isApproveOT: 0,
      );
    }
  }

  bool hasCRMAccess() =>
      [accessLevel.isCrmUnit, accessLevel.isCrmSparepart].contains(1);
  bool hasFSAccess() =>
      [accessLevel.fieldService, accessLevel.workshop].contains(1);
  bool hasAMAccess() => [
        accessLevel.smallPaper,
        accessLevel.vehicleCheck,
        accessLevel.scanSmallPaper,
        accessLevel.scanVehicleCheck
      ].contains(1);
  bool hasCMSAccess() =>
      [accessLevel.isUnderLevel, accessLevel.a4, accessLevel.tsb].contains(1);
  bool hasSamllPaper() => accessLevel.smallPaper == 1;
  bool hasScanSamllPaper() => accessLevel.scanSmallPaper == 1;
  bool hasAmDh() => accessLevel.isAmDh == 1;
  bool hasASGM() => accessLevel.isAfterSalesGeneralManager == 1;
  bool hasAH() => accessLevel.isAdminHead == 1;
  bool hasReadReqOT() => accessLevel.isReadRequestOT == 1;
  bool hasReadOT() => accessLevel.isReadOT == 1;
  bool hasSubmitReqOT() => accessLevel.isSubmitRequestOT == 1;
  bool hasSubmitOT() => accessLevel.isSubmitOT == 1;
  bool hasApproveOT() => accessLevel.isApproveOT == 1;
  //bool hasReqOTAccess() => [accessLevel.isReadRequestOT, accessLevel.isSubmitRequestOT].contains(1);
}
