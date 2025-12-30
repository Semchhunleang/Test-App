import 'package:umgkh_mobile/models/am/vehicle_check/fleet_vehicle.dart';
import 'package:umgkh_mobile/models/service-project_task/pause_continue/pause_continue.dart';
import 'package:umgkh_mobile/utils/utlis.dart';

class TimesheetProjectTask {
  int? id;
  int? trip;
  // int? tripId;
  int? totalMileage;
  int? odometerStart;
  int? odometerEnd;
  DateTime? dispatchDt;
  DateTime? arrivalAtSiteDt;
  DateTime? jobStartDt;
  DateTime? jobCompleteDt;
  DateTime? leaveFromSiteDt;
  DateTime? arriveAtOfficeDt;
  num? totalTimeStore;
  //--- leang add
  num? totalTimeHour;
  num? totalTimeMinute;
  //--- end
  String? offId;
  // String? tripOffId;
  FleetVehicle? fleetVehicle;
  List<PauseContinue>? pauseContinue;
  int? projectTaskId;
  final String? dispatchFrom;
  final String? arriveAt;

  TimesheetProjectTask(
      {this.id,
      this.trip,
      // this.tripId,
      this.totalMileage,
      this.odometerStart,
      this.odometerEnd,
      this.dispatchDt,
      this.arrivalAtSiteDt,
      this.jobStartDt,
      this.jobCompleteDt,
      this.leaveFromSiteDt,
      this.arriveAtOfficeDt,
      this.totalTimeStore,
      this.totalTimeHour,
      this.totalTimeMinute,
      this.offId,
      // this.tripOffId,
      this.fleetVehicle,
      this.pauseContinue,
      this.projectTaskId,
      this.dispatchFrom,
      this.arriveAt});

  static TimesheetProjectTask fromJson(Map<String, dynamic> json) {
    FleetVehicle? fleetVehicle =
        json['fleet'] != null && json['fleet']['id'] != null
            ? FleetVehicle.fromJson(json['fleet'])
            : null;
    return TimesheetProjectTask(
      id: json['id'],
      projectTaskId: json['project_task_id'],
      trip: int.tryParse(json['trip']?.toString() ?? "1"),
      totalMileage: json['total_mileage'],
      odometerStart: json['odometer_start'],
      odometerEnd: json['odometer_end'],
      dispatchDt: parseDateTimeNoUtc(json['dispatch_dt']),
      arrivalAtSiteDt: parseDateTimeNoUtc(json['arrival_at_site_dt']),
      jobStartDt: parseDateTimeNoUtc(json['job_start_dt']),
      jobCompleteDt: parseDateTimeNoUtc(json['job_complete_dt']),
      leaveFromSiteDt: parseDateTimeNoUtc(json['leave_from_site_dt']),
      arriveAtOfficeDt: parseDateTimeNoUtc(json['arrive_at_office_dt']),
      totalTimeStore: json['total_time_store'] ?? 0,
      //--- leang add
      totalTimeHour: json['total_time_hour'] ?? 0,
      totalTimeMinute: json['total_time_minute'] ?? 0,
      //--- end
      offId: json['off_id'] ?? "",
      // tripOffId: json['trip_off_id'] ?? "",
      fleetVehicle: fleetVehicle,
      // tripId: json['trip_id'],
      pauseContinue: json['pause_continue'] != null
          ? (json['pause_continue'] as List)
              .map(
                (item) => PauseContinue.fromJson(item),
              )
              .toList()
          : null,
      dispatchFrom: json['dispatch_from'] ?? "",
      arriveAt: json['arrive_at'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'trip': trip,
      'total_mileage': totalMileage,
      'odometer_start': odometerStart,
      'odometer_end': odometerEnd,
      'dispatch_dt': rollbackParseDateTime(dispatchDt),
      'arrival_at_site_dt': rollbackParseDateTime(arrivalAtSiteDt),
      'job_start_dt': rollbackParseDateTime(jobStartDt),
      'job_complete_dt': rollbackParseDateTime(jobCompleteDt),
      'leave_from_site_dt': rollbackParseDateTime(leaveFromSiteDt),
      'arrive_at_office_dt': rollbackParseDateTime(arriveAtOfficeDt),
      'total_time_store': totalTimeStore,
      'off_id': offId,
      'fleet': fleetVehicle?.toJson(),
      'project_task_id': projectTaskId,
      // 'trip_id': tripId,
      // 'trip_off_id': tripOffId,
      'dispatch_from': dispatchFrom,
      'arrive_at': arriveAt,
    };
  }
}
