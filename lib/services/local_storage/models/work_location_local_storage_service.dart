import 'package:sqflite/sqflite.dart';
import 'package:umgkh_mobile/models/base/user/work_location.dart';
import 'package:umgkh_mobile/models/base/user/work_location_coordinate.dart';
import 'package:umgkh_mobile/services/local_storage/local_storage_service.dart';

class WorkLocationLocalStorageService {
  final Database _db;

  WorkLocationLocalStorageService() : _db = LocalStorageService().db;

  Future<int> getOrCreateWorkLocationId(WorkLocation workLocationData) async {
    List<Map<String, dynamic>> result = await _db.query('work_locations',
        where: 'id = ?', whereArgs: [workLocationData.id], limit: 1);

    if (result.isEmpty) {
      await _db.insert('work_locations', {
        'id': workLocationData.id,
        'name': workLocationData.name,
      });
      if (workLocationData.coordinate!.isNotEmpty) {
        List<WorkLocationCoordinate> coordinates = workLocationData.coordinate!;
        for (WorkLocationCoordinate coordinate in coordinates) {
          List<Map<String, dynamic>> resultWLC = await _db.query(
              'work_location_coordinates',
              where: 'id = ?',
              whereArgs: [coordinate.id],
              limit: 1);
          if (resultWLC.isEmpty) {
            await _db.insert('work_location_coordinates', {
              'id': coordinate.id,
              'partner_id': coordinate.partnerId,
              'latitude': coordinate.latitude,
              'longitude': coordinate.longitude,
              'work_location_id': workLocationData.id,
            });
          }
        }
      }
      return workLocationData.id;
    } else {
      return workLocationData.id;
    }
  }

  Future<WorkLocation?> getWorkLocationById(int id) async {
    List<Map<String, dynamic>> result = await _db.query('work_locations',
        where: 'id = ?', whereArgs: [id], limit: 1);

    if (result.isNotEmpty) {
      WorkLocation workLocation = WorkLocation.fromJson(result.first);
      List<WorkLocationCoordinate> coordinates = await getCoordinatesForWorkLocation(id);
      workLocation.coordinate = coordinates;
      return workLocation;
    }
    return null;
  }

  Future<List<WorkLocationCoordinate>> getCoordinatesForWorkLocation(int workLocationId) async {
    List<Map<String, dynamic>> result = await _db.query('work_location_coordinates',
        where: 'work_location_id = ?', whereArgs: [workLocationId]);

    return result.map((json) => WorkLocationCoordinate.fromJson(json),).toList();
  }
}
