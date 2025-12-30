import 'package:sqflite/sqflite.dart';
import 'package:umgkh_mobile/models/base/user/department.dart';
import 'package:umgkh_mobile/services/local_storage/local_storage_service.dart';

class DepartmentLocalStorageService {
  final Database _db;
  bool _onLoading = false;

  DepartmentLocalStorageService() : _db = LocalStorageService().db;

  /// Fetches or creates a department in the local storage.
  /// Returns the department's ID.
  Future<int> getOrCreateDepartmentId(Department departmentData) async {
    if (_onLoading) return departmentData.id;

    _onLoading = true;
    try {
      final result = await _db.query(
        'departments',
        where: 'id = ?',
        whereArgs: [departmentData.id],
        limit: 1,
      );

      if (result.isEmpty) {
        // If department doesn't exist, insert it and return its ID.
        return await _db.insert('departments', {
          'id': departmentData.id,
          'code': departmentData.code,
          'name': departmentData.name,
        });
      }

      // If department already exists, return the existing ID.
      return departmentData.id;
    } catch (e) {
      // Log the error (this can be adjusted to your app's logging mechanism).
      return -1; // Returning -1 to indicate failure.
    } finally {
      _onLoading = false;
    }
  }

  /// Fetches a department by its ID.
  /// Returns the department if found, otherwise returns null.
  Future<Department?> getDepartmentById(int id) async {
    try {
      final result = await _db.query(
        'departments',
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );

      if (result.isNotEmpty) {
        return Department.fromJson(result.first);
      }

      return null;
    } catch (e) {
      // Log the error.
      return null;
    }
  }
}
