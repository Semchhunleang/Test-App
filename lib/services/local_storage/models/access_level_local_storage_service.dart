import 'package:sqflite/sqflite.dart';
import 'package:umgkh_mobile/models/base/auth/access_level.dart';
import 'package:umgkh_mobile/services/local_storage/local_storage_service.dart';

class AccessLevelLocalStorageService {
  final Database _db;

  AccessLevelLocalStorageService() : _db = LocalStorageService().db;

  Future<void> saveAccessLevel(
    int isDH,
    int isHc,
    int isHrd,
    int isHrc,
    int isUnderLevel,
    int a4,
    int tsb,
    int isAmDh,
    int isCrmUnit,
    int isCrmSparepart,
    int smallPaper,
    int scanSmallPaper,
    int vehicleCheck,
    int scanVehicleCheck,
    int fieldService,
    int workshop,
    int isAfterSalesGeneralManager,
    int isFieldServiceGeneralManager,
    int isAdminHead,
    int isReadRequestOT,
    int isReadOT,
    int isSubmitRequestOT,
    int isSubmitOT,
    int isApproveOT,
  ) async {
    await _db.delete('access_levels');
    await LocalStorageService().init(); // Ensure database is initialized
    await _db.insert(
      'access_levels',
      {
        'is_dh': isDH,
        'is_hc': isHc,
        'is_hrd': isHrd,
        'is_hrc': isHrc,
        'is_under_level': isUnderLevel,
        'a4': a4,
        'tsb': tsb,
        'is_am_dh': isAmDh,
        'is_crm_unit': isCrmUnit,
        'is_crm_sparepart': isCrmSparepart,
        'small_paper': smallPaper,
        'scan_small_paper': scanSmallPaper,
        'vehicle_check': vehicleCheck,
        'scan_vehicle_check': scanVehicleCheck,
        'field_service': fieldService,
        'workshop': workshop,
        'is_after_sales_general_manager': isAfterSalesGeneralManager,
        'is_field_service_general_manager': isFieldServiceGeneralManager,
        'is_service_admin_head': isAdminHead,
        'is_read_request_ot': isReadRequestOT,
        'is_read_ot': isReadOT,
        'is_submit_request_ot': isSubmitRequestOT,
        'is_submit_ot': isSubmitOT,
        'is_approve_ot': isApproveOT,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<AccessLevel?> getAccessLevel() async {
    await LocalStorageService().init(); // Ensure database is initialized
    final List<Map<String, dynamic>> result = await _db.query('access_levels');

    if (result.isNotEmpty) {
      return AccessLevel.fromJson(result.first);
    }
    return null;
  }

  Future<void> deleteAccessLevel() async {
    await LocalStorageService().init(); // Ensure database is initialized
    await _db.delete('access_levels');
  }
}
