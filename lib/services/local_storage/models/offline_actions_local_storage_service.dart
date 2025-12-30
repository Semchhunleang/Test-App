import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:umgkh_mobile/models/base/custom_ui/api_response.dart';
import 'package:umgkh_mobile/models/service-project_task/offline_action.dart/offline_action.dart';
import 'package:umgkh_mobile/services/api/offline_sync/offline_sync.dart';
import 'package:umgkh_mobile/services/local_storage/local_storage_service.dart';
import 'package:umgkh_mobile/utils/utlis.dart';

class OfflineActionStorageService {
  final Database _db;

  OfflineActionStorageService() : _db = LocalStorageService().db;

  Future<void> saveOfflineAction(
      String resModel, int resId, String action, String dataChange) async {
    try {
      await _db.insert(
        'offline_actions',
        {
          'res_model': resModel,
          'res_id': resId,
          'action': action,
          'data_change': dataChange,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
        debugPrint(e.toString());
    }
    // await LocalStorageService().init();
    // await _db.insert(
    //   'offline_actions',
    //   {
    //     // 'id': id,
    //     'res_model': resModel,
    //     'res_id': resId,
    //     'action': action,
    //     'data_change': dataChange,
    //   },
    //   conflictAlgorithm: ConflictAlgorithm.replace,
    // );
  }

  Future<List<OfflineAction>?> getOfflineAction() async {
    await LocalStorageService().init();
    final List<Map<String, dynamic>> result =
        await _db.query('offline_actions');
    if (result.isNotEmpty) {
      List<OfflineAction>? datas;
      datas = (result)
          .map(
            (i) => OfflineAction.fromJson(
              Map<String, dynamic>.from(i),
            ),
          )
          .toList();

      for (var element in datas) {
        var dataChange = jsonDecode(element.dataChange ?? '');
        Duration localOffset = DateTime.now().timeZoneOffset;
        if (element.resModel == 'job.assign.line' &&
            element.action == 'update') {
          DateTime dateTime = DateTime.parse(dataChange['datetime']);
          DateTime adjustedDateTime = dateTime.subtract(localOffset);
          ApiResponse response =
              await OfflineSyncAPIService().updateStateJobAssignLineOffline(
            jobAssignId: element.resId ?? 0,
            state: dataChange['state'],
            reason: '',
            datetime: adjustedDateTime.toIso8601String(),
          );
          if (response.statusCode == 200) {
            await OfflineActionStorageService().deleteOfflineAction(element.id);
          }
        } else if (element.resModel == 'trip.project.tasks' &&
            element.action == 'create') {
          DateTime dateTime = DateTime.parse(dataChange['trip']['dispatch_dt']);
          DateTime adjustedDateTime = dateTime.subtract(localOffset);
          ApiResponse response = await OfflineSyncAPIService()
              .insertTriAndRellOffline(
                  dispatchDt: adjustedDateTime.toIso8601String(),
                  fleetId: dataChange['trip']['fleet']['id'],
                  odometerStart: dataChange['trip']['odometer_start'],
                  offId: dataChange['trip_task_rel']['trip_off_id'],
                  taskId: dataChange['trip_task_rel']['task_id']);
          if (response.statusCode == 201 || response.statusCode == 200) {
            await OfflineActionStorageService().deleteOfflineAction(element.id);
          }
        } else if (element.resModel == 'trip.project.tasks' &&
            element.action == 'update') {
          // DateTime dateTime = DateTime.parse(dataChange['arrival_at_site_dt']);
          // DateTime adjustedArrivalAtSiteDt = dateTime.subtract(localOffset);
          ApiResponse response = await OfflineSyncAPIService().updateTriOffline(
              id: dataChange['id'],
              // arrivalAtSiteDt: adjustedArrivalAtSiteDt.toIso8601String(),
              // leaveFromSiteDt: dataChange['leave_from_site_dt']!=null?(DateTime.parse(dataChange['leave_from_site_dt']).subtract(localOffset)).toIso8601String():null,
              arriveAtOfficeDt: dataChange['arrive_at_office_dt'] != null
                  ? (DateTime.parse(dataChange['arrive_at_office_dt'])
                          .subtract(localOffset))
                      .toIso8601String()
                  : null,
              odometerEnd: dataChange['odometer_end'],
              offId: dataChange['off_id']);
          if (response.statusCode == 201 || response.statusCode == 200) {
            await OfflineActionStorageService().deleteOfflineAction(element.id);
          }
        } else if (element.resModel == 'timesheet.project.task' &&
            element.action == 'create') {
          DateTime dateTime = DateTime.parse(dataChange['dispatch_dt']);
          DateTime adjustedDateTime = dateTime.subtract(localOffset);
          ApiResponse response = await OfflineSyncAPIService()
              .insertTimesheetOffline(
                  dispatchDt: adjustedDateTime.toIso8601String(),
                  fleetId: dataChange['fleet']['id'],
                  odometerStart: dataChange['odometer_start'],
                  offId: dataChange['off_id'],
                  trip: dataChange['trip'],
                  projectTaskId: dataChange['project_task_id'],
                  dispatchFrom: dataChange['dispatch_from']);
          if (response.statusCode == 201) {
            await OfflineActionStorageService().deleteOfflineAction(element.id);
          }
        } else if (element.resModel == 'timesheet.project.task' &&
            element.action == 'update') {
          ApiResponse response = await OfflineSyncAPIService()
              .updateTimesheetOffline(
                  offId: dataChange['off_id'],
                  odometerEnd: dataChange['odometer_end'],
                  arrivalAtSiteDt: dataChange['arrival_at_site_dt'] != null
                      ? DateTime.parse(dataChange['arrival_at_site_dt'])
                          .subtract(localOffset)
                          .toIso8601String()
                      : null,
                  arriveAtOfficeDt: dataChange['arrive_at_office_dt'] != null
                      ? DateTime.parse(dataChange['arrive_at_office_dt'])
                          .subtract(localOffset)
                          .toIso8601String()
                      : null,
                  jobCompleteDt: dataChange['job_complete_dt'] != null
                      ? DateTime.parse(dataChange['job_complete_dt'])
                          .subtract(localOffset)
                          .toIso8601String()
                      : null,
                  jobStartDt: dataChange['job_start_dt'] != null
                      ? DateTime.parse(dataChange['job_start_dt'])
                          .subtract(localOffset)
                          .toIso8601String()
                      : null,
                  leaveFromSiteDt: dataChange['leave_from_site_dt'] != null
                      ? DateTime.parse(dataChange['leave_from_site_dt'])
                          .subtract(localOffset)
                          .toIso8601String()
                      : null,
                  arriveAt: dataChange['arrive_at']);
          if (response.statusCode == 200) {
            await OfflineActionStorageService().deleteOfflineAction(element.id);
          }
        } else if (element.resModel == 'tab.overall.checking' &&
            element.action == 'create') {
          List<File>? imagesInsert = (dataChange['image_paths'] != null)
              ? (jsonDecode(dataChange['image_paths']) as List<dynamic>)
                  .map(
                    (path) => convertPathsToFile(path),
                  )
                  .toList()
              : [];

          final data = {
            "tab_overall_checking_id": dataChange['tab_overall_checking_id'],
            "current_machine_hour": dataChange['current_machine_hour'],
            "current_machine_km": dataChange['current_machine_km'],
            "note": dataChange['note'],
            "check_datetime": dataChange['check_datetime'] != null
                ? DateTime.parse(dataChange['check_datetime'])
                    .subtract(localOffset)
                    .toIso8601String()
                : null,
            "off_id": dataChange['off_id'],
          };

          ApiResponse response = await OfflineSyncAPIService()
              .insertOverallCheckingOffline(imagesInsert, data);
          if (response.statusCode == 201) {
            await OfflineActionStorageService().deleteOfflineAction(element.id);
          }
        } else if (element.resModel == 'service.report.project' &&
            element.action == 'create') {
          List<File>? imagesInsert = (dataChange['image_paths'] != null)
              ? (jsonDecode(dataChange['image_paths']) as List<dynamic>)
                  .map(
                    (path) => convertPathsToFile(path),
                  )
                  .toList()
              : [];

          Map<String, dynamic> data = {
            "service_report_project_id":
                dataChange['service_report_project_id'],
            "problem": dataChange['problem'],
            "root_cause": dataChange['root_cause'],
            "action": dataChange['action'],
          };

          ApiResponse response = await OfflineSyncAPIService()
              .insertServiceReportOffline(imagesInsert, data);
          if (response.statusCode == 201) {
            await OfflineActionStorageService().deleteOfflineAction(element.id);
          }
        } else if (element.resModel == 'job.finish.project' &&
            element.action == 'create') {
          Map<String, String> fields = {
            "job_finish_project_id":
                dataChange['job_finish_project_id'].toString(),
            'customer_satisfied': dataChange['customer_satisfied'] ?? '',
            'customer_name': dataChange['customer_name'] ?? '',
            'phone': dataChange['phone'] ?? '',
            'customer_comment': dataChange['customer_comment'] ?? '',
            'service_recommendation':
                dataChange['service_recommendation'] ?? '',
            'finish_datetime': dataChange['finish_datetime'] != null
                ? DateTime.parse(dataChange['finish_datetime'])
                    .subtract(localOffset)
                    .toIso8601String()
                : '',
          };

          var signPath = dataChange['image_path'];
          var mechanicSignPath = dataChange['mechanic_signature_path'];

          File? signFile;
          File? mechanicSignFile;

          if (signPath != null && signPath.toString().isNotEmpty) {
            File file = File(signPath);
            if (file.existsSync()) signFile = file;
          }

          if (mechanicSignPath != null &&
              mechanicSignPath.toString().isNotEmpty) {
            File file = File(mechanicSignPath);
            if (file.existsSync()) mechanicSignFile = file;
          }

          ApiResponse response =
              await OfflineSyncAPIService().insertJobFinishOffline(
            fields: fields,
            signFile: signFile,
            mechanicSignFile: mechanicSignFile,
          );

          if (response.statusCode == 201) {
            await OfflineActionStorageService().deleteOfflineAction(element.id);
          } 
        } else if (element.resModel == 'project.task' &&
            element.action == 'update') {
          Map<String, dynamic> data = {
            "id": element.resId,
            'stage_name': dataChange,
          };
          ApiResponse response = await OfflineSyncAPIService()
              .updateUpdateStageFieldServiceOffline(data);
          if (response.statusCode == 201 || response.statusCode == 200) {
            await OfflineActionStorageService().deleteOfflineAction(element.id);
          }
        } 
      }

      return datas;
    }
    return null;
  }

  Future<void> deleteOfflineAction(int id) async {
    await LocalStorageService().init();
    await _db.delete('offline_actions', where: 'id = ?', whereArgs: [id]);
  }
}
