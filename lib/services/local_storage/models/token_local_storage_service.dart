import 'package:sqflite/sqflite.dart';
import 'package:umgkh_mobile/services/local_storage/local_storage_service.dart';

class TokenLocalStorageService {
  final Database _db;

  // 1. Flag to track if a save operation is currently running
  bool _isSaving = false;
  // 2. A Future to hold the currently running save operation
  Future<void>? _saveOperation;

  TokenLocalStorageService() : _db = LocalStorageService().db;

  // Future<void> saveToken(String token) async {
  //   await LocalStorageService().init();

  //   await _db.transaction((txn) async {
  //     await txn.delete('tokens');
  //     await txn.insert(
  //       'tokens',
  //       {'token': token},
  //       conflictAlgorithm: ConflictAlgorithm.replace,
  //     );
  //   });
  // }

  Future<void> saveToken(String token) async {
    // If a save operation is already running, wait for it to complete
    if (_isSaving) {
      return _saveOperation;
    }

    // Set the flag and start the operation
    _isSaving = true;
    _saveOperation = _performSave(token);
    
    // Wait for the operation to finish
    await _saveOperation;

    // Reset the flag and the future
    _isSaving = false;
    _saveOperation = null;
  }

  // Private method containing the actual save logic
  Future<void> _performSave(String token) async {
    // Original save logic
    await LocalStorageService().init();

    await _db.transaction((txn) async {
      await txn.delete('tokens');
      await txn.insert(
        'tokens',
        {'token': token},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
  }
  

  Future<String?> getToken() async {
    await LocalStorageService().init(); // Ensure database is initialized
    final List<Map<String, dynamic>> maps = await _db.query('tokens');
    if (maps.isNotEmpty) {
      return maps.first['token'] as String?;
    }
    return null;
  }

  Future<bool> hasToken() async {
    await LocalStorageService().init(); // Ensure database is initialized
    final token = await getToken();
    return token != null;
  }

  Future<void> deleteToken() async {
    await LocalStorageService().init(); // Ensure database is initialized
    await _db.delete('tokens');
    await _db.delete('departments');
    await _db.delete('work_locations');
    await _db.delete('work_location_coordinates');
    await _db.delete('users');
    await _db.delete('access_levels');
    await _db.delete('pause_continues');
    await _db.delete('fleet_vehicle_model_brands');
    await _db.delete('fleet_vehicle_models');
    await _db.delete('fleet_vehicles');
    await _db.delete('fs_actions');
    await _db.delete('phenomenons');
    await _db.delete('system_components');
    await _db.delete('job_analytics');
    await _db.delete('job_finishes');
    await _db.delete('service_reports');
    await _db.delete('overall_checkings');
    await _db.delete('timesheet_project_tasks');
    await _db.delete('product_categories');
    await _db.delete('website_categories');
    await _db.delete('products');
    await _db.delete('stock_production_lots');
    await _db.delete('machine_applications');
    await _db.delete('countries');
    await _db.delete('country_states');
    await _db.delete('cities');
    await _db.delete('customers');
    await _db.delete('helpdesk_ticket_types');
    await _db.delete('job_groups');
    await _db.delete('function_groups');
    await _db.delete('job_classifications');
    await _db.delete('stages');
    await _db.delete('project_tasks');
    await _db.delete('offline_actions');
  }
}
