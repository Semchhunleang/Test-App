import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:umgkh_mobile/models/base/custom_ui/api_response.dart';
import 'package:umgkh_mobile/models/base/user/department.dart';
import 'package:umgkh_mobile/models/base/user/user.dart';
import 'package:umgkh_mobile/models/base/user/work_location.dart';
import 'package:umgkh_mobile/services/api/base/auth/token_service.dart';
import 'package:umgkh_mobile/services/local_storage/models/department_local_storage_service.dart';
import 'package:umgkh_mobile/services/local_storage/models/work_location_local_storage_service.dart';
import 'package:umgkh_mobile/utils/token_decoder.dart';
import 'package:umgkh_mobile/services/local_storage/local_storage_service.dart';

class UserLocalStorageService {
  final Database _db;
  final AuthAPIService _tokenManager = AuthAPIService();
  final DepartmentLocalStorageService _departmentService =
      DepartmentLocalStorageService();
  final WorkLocationLocalStorageService _workLocationService =
      WorkLocationLocalStorageService();

  UserLocalStorageService() : _db = LocalStorageService().db;

  Future<void> saveUser(User userData) async { 
    await LocalStorageService().init(); // Ensure database is initialized

    int? departmentId;
    if (userData.department != null) {
      departmentId = await _departmentService
          .getOrCreateDepartmentId(userData.department!);
    }

    int? workLocationId;
    if (userData.workLocation != null) {
      workLocationId = await _workLocationService
          .getOrCreateWorkLocationId(userData.workLocation!);
    }

    int? managerId;
    if (userData.manager != null) {
      managerId = await _getOrCreateManagerId(userData.manager!);
    }

    await _db.insert(
      'users',
      {
        'id': userData.id,
        'user_id': userData.userId,
        'name': userData.name,
        'username': userData.username,
        'registration_number': userData.registrationNumber,
        'job_title': userData.jobTitle,
        'rank': userData.rank,
        'user_level': userData.userLevel,
        'sub_rank': userData.subRank,
        'mobile_phone': userData.mobilePhone,
        'work_phone': userData.workPhone,
        'work_email': userData.workEmail,
        'face_landmarks': jsonEncode(userData.faceLandmarks),
        'work_location_id': workLocationId,
        'department_id': departmentId,
        'manager_id': managerId,
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<int?> _getOrCreateManagerId(User managerData) async {
    List<Map<String, dynamic>> result = await _db.query('users',
        where: 'id = ?', whereArgs: [managerData.id], limit: 1);

    if (result.isEmpty) {
      await saveUser(managerData); // Recursively insert manager if not found
      return managerData.id;
    } else {
      return managerData.id;
    }
  }

  Future<User?> getUserById(int id) async {
    await LocalStorageService().init();
    final List<Map<String, dynamic>> maps = await _db.query('users',
        where: 'id = ?', whereArgs: [id], limit: 1);
    if (maps.isEmpty) {
      return null;
    }

    final userMap = maps.first;
    final departmentId = userMap['department_id'];
    final workLocationId = userMap['work_location_id'];
    final managerId = userMap['manager_id'];

    Department? department;
    WorkLocation? workLocation;
    User? manager;

    if (departmentId != null) {
      department = await _departmentService.getDepartmentById(departmentId);
    }

    if (workLocationId != null) {
      workLocation =
          await _workLocationService.getWorkLocationById(workLocationId);
    }

    if (managerId != null) {
      final managerMap =
          await _db.query('users', where: 'id = ?', whereArgs: [managerId]);
      if (managerMap.isNotEmpty) {
        Department? managerDepartment;
        WorkLocation? managerWorkLocation;
        final managerDepartmentId = managerMap.first['department_id'];
        final managerWorkLocationId = managerMap.first['work_location_id'];
        var managerData = Map<String, dynamic>.from(managerMap.first);
        if (managerDepartmentId != null) {
          managerDepartment = await _departmentService
              .getDepartmentById(int.parse(managerDepartmentId.toString(),),);
          managerData['department'] = managerDepartment!.toJson();
        } else {
          managerData['department'] =
              Department(id: 0, code: '-', name: '-').toJson();
        }
        if (managerWorkLocationId != null) {
          managerWorkLocation = await _workLocationService
              .getWorkLocationById(int.parse(managerWorkLocationId.toString(),),);
          managerData['work_location'] = managerWorkLocation!.toJson();
        } else {
          managerData['work_location'] =
              WorkLocation(id: 0, name: '-').toJson();
        }
        manager = User.managerFromJson(managerData);
        //   manager = User.managerFromJson(
        //       managerMap.first, managerWorkLocation, managerDepartment);
      }
    }
    return User(
      id: userMap['id'],
      userId: userMap['user_id'],
      name: userMap['name'],
      username: userMap['username'],
      registrationNumber: userMap['registration_number'],
      jobTitle: userMap['job_title'],
      rank: userMap['rank'],
      userLevel: userMap['user_level'],
      subRank: userMap['sub_rank'],
      mobilePhone: userMap['mobile_phone'],
      workPhone: userMap['work_phone'],
      workEmail: userMap['work_email'],
      faceLandmarks: jsonDecode(userMap['face_landmarks']),
      workLocation:
          workLocation ?? WorkLocation(id: 0, name: '', coordinate: null),
      department: department ?? Department(id: 0, code: '', name: ''),
      manager: manager,
    );
  }
  Future<User?> getUser() async {
    ApiResponse<String>? responseToken =
        await _tokenManager.refreshAndGetToken();
    var tokenDecode = decodeToken(responseToken!.data);
    await LocalStorageService().init();
    final List<Map<String, dynamic>> maps = await _db.query('users',
        where: 'id = ?', whereArgs: [tokenDecode['employee_id']], limit: 1);
    if (maps.isEmpty) {
      return null;
    }

    final userMap = maps.first;
    final departmentId = userMap['department_id'];
    final workLocationId = userMap['work_location_id'];
    final managerId = userMap['manager_id'];

    Department? department;
    WorkLocation? workLocation;
    User? manager;

    if (departmentId != null) {
      department = await _departmentService.getDepartmentById(departmentId);
    }

    if (workLocationId != null) {
      workLocation =
          await _workLocationService.getWorkLocationById(workLocationId);
    }

    if (managerId != null) {
      final managerMap =
          await _db.query('users', where: 'id = ?', whereArgs: [managerId]);
      if (managerMap.isNotEmpty) {
        Department? managerDepartment;
        WorkLocation? managerWorkLocation;
        final managerDepartmentId = managerMap.first['department_id'];
        final managerWorkLocationId = managerMap.first['work_location_id'];
        var managerData = Map<String, dynamic>.from(managerMap.first);
        if (managerDepartmentId != null) {
          managerDepartment = await _departmentService
              .getDepartmentById(int.parse(managerDepartmentId.toString(),),);
          managerData['department'] = managerDepartment!.toJson();
        } else {
          managerData['department'] =
              Department(id: 0, code: '-', name: '-').toJson();
        }
        if (managerWorkLocationId != null) {
          managerWorkLocation = await _workLocationService
              .getWorkLocationById(int.parse(managerWorkLocationId.toString(),),);
          managerData['work_location'] = managerWorkLocation!.toJson();
        } else {
          managerData['work_location'] =
              WorkLocation(id: 0, name: '-').toJson();
        }
        manager = User.managerFromJson(managerData);
        //   manager = User.managerFromJson(
        //       managerMap.first, managerWorkLocation, managerDepartment);
      }
    }
    return User(
      id: userMap['id'],
      userId: userMap['user_id'],
      name: userMap['name'],
      username: userMap['username'],
      registrationNumber: userMap['registration_number'],
      jobTitle: userMap['job_title'],
      rank: userMap['rank'],
      userLevel: userMap['user_level'],
      subRank: userMap['sub_rank'],
      mobilePhone: userMap['mobile_phone'],
      workPhone: userMap['work_phone'],
      workEmail: userMap['work_email'],
      faceLandmarks: jsonDecode(userMap['face_landmarks']),
      workLocation:
          workLocation ?? WorkLocation(id: 0, name: '', coordinate: null),
      department: department ?? Department(id: 0, code: '', name: ''),
      manager: manager,
    );
  }

  Future<void> deleteUser() async {
    await LocalStorageService().init(); // Ensure database is initialized
    await _db.delete('users');
    await _db.delete('departments');
  }
}
