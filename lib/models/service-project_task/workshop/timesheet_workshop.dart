import 'package:umgkh_mobile/models/service-project_task/pause_continue/pause_continue.dart';
import 'package:umgkh_mobile/utils/utlis.dart';

class TimesheetWorkshop {
  int? id;
  DateTime? jobStartDt;
  DateTime? jobCompleteDt;
  String? remark;
  num? totalTimeStore;
  //--- leang add
  num? totalTimeHour;
  num? totalTimeMinute;
  //--- end
  String? offId;
  List<PauseContinue>? pauseContinue;

  TimesheetWorkshop(
      {this.id,
      this.jobStartDt,
      this.jobCompleteDt,
      this.totalTimeStore,
      this.totalTimeHour,
      this.totalTimeMinute,
      this.remark,
      this.offId,
      this.pauseContinue});

  static TimesheetWorkshop fromJson(Map<String, dynamic> json) {
    return TimesheetWorkshop(
      id: json['id'],
      jobStartDt: json['job_start_dt'] != null
          ? DateTime.tryParse(json['job_start_dt'])
          : null,
      jobCompleteDt: json['job_complete_dt'] != null
          ? DateTime.tryParse(json['job_complete_dt'])
          : null,
      totalTimeStore: json['total_time_store'] ?? 0,
      //--- leang add
      totalTimeHour: json['total_time_hour'] ?? 0,
      totalTimeMinute: json['total_time_minute'] ?? 0,
      //--- end
      remark: json['remark'] ?? "",
      offId: json['off_id'] ?? "",
      pauseContinue: json['pause_continue'] != null
          ? (json['pause_continue'] as List)
              .map((item) => PauseContinue.fromJson(item),)
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'job_start_dt': rollbackParseDateTime(jobStartDt),
      'job_complete_dt': rollbackParseDateTime(jobCompleteDt),
      'total_time_store': totalTimeStore,
      'remark': remark,
      'off_id': offId,
    };
  }
}
