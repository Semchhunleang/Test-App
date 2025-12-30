// import 'dart:ffi';

// import 'package:umgkh_mobile/models/am/small_paper/small_paper.dart';
import 'package:umgkh_mobile/models/am/vehicle_check/fleet_vehicle.dart';
import 'package:umgkh_mobile/models/service-project_task/timesheet_project_task/timesheet_project_task.dart';
import 'package:umgkh_mobile/utils/utlis.dart';

class TripProjectTask {
  int? id;
  String? name;
  int? totalMileage;
  int? odometerStart;
  int? odometerEnd;
  DateTime? dispatchDt;
  // DateTime? arrivalAtSiteDt;
  // DateTime? leaveFromSiteDt;
  DateTime? arriveAtOfficeDt;
  num? totalTimeStore;
  num? totalTimeHour;
  num? totalTimeMinute;
  FleetVehicle? fleetVehicle;
  List<TimesheetProjectTask>? timesheetProjectTasks;
  int? smallPaperId;
  String? offId;

  TripProjectTask(
      {this.id,
      this.name,
      this.totalMileage,
      this.odometerStart,
      this.odometerEnd,
      this.dispatchDt,
      // this.arrivalAtSiteDt,
      this.timesheetProjectTasks,
      // this.leaveFromSiteDt,
      this.arriveAtOfficeDt,
      this.totalTimeStore,
      this.totalTimeHour,
      this.totalTimeMinute,
      this.smallPaperId,
      this.fleetVehicle,
      this.offId});

  static TripProjectTask fromJson(Map<String, dynamic> json) {
    FleetVehicle? fleetVehicle =
        json['fleet'] != null && json['fleet']['id'] != null
            ? FleetVehicle.fromJson(json['fleet'])
            : null;
    return TripProjectTask(
      id: json['id'],
      name: json['name'],
      totalMileage: json['total_mileage'],
      odometerStart: json['odometer_start'],
      odometerEnd: json['odometer_end'],
      dispatchDt: parseDateTimeNoUtc(json['dispatch_dt']),
      // arrivalAtSiteDt: parseDateTimeNoUtc(json['arrival_at_site_dt']),
      // leaveFromSiteDt: parseDateTimeNoUtc(json['leave_from_site_dt']),
      arriveAtOfficeDt: parseDateTimeNoUtc(json['arrive_at_office_dt']),
      totalTimeStore: json['total_time_store'] ?? 0,
      totalTimeHour: json['total_time_hour'] ?? 0,
      totalTimeMinute: json['total_time_minute'] ?? 0,
      fleetVehicle: fleetVehicle,
      smallPaperId: json['small_paper_id'] ?? 0,
      timesheetProjectTasks: json['timesheet_project_task'] != null
          ? (json['timesheet_project_task'] as List)
              .map(
                (item) => TimesheetProjectTask.fromJson(item),
              )
              .toList()
          : null,
      offId: json['off_id'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'total_mileage': totalMileage,
      'odometer_start': odometerStart,
      'odometer_end': odometerEnd,
      'dispatch_dt': rollbackParseDateTime(dispatchDt),
      // 'arrival_at_site_dt': rollbackParseDateTime(arrivalAtSiteDt),
      // 'leave_from_site_dt': rollbackParseDateTime(leaveFromSiteDt),
      'arrive_at_office_dt': rollbackParseDateTime(arriveAtOfficeDt),
      'total_time_store': totalTimeStore,
      'fleet': fleetVehicle?.toJson(),
      'off_id': offId,
    };
  }
}
