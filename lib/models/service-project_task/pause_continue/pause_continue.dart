import 'package:umgkh_mobile/models/base/user/user.dart';
import 'package:umgkh_mobile/utils/utlis.dart';

class PauseContinue {
  int? id;
  int? timesheetId;
  int? timesheetWorkshopId;
  DateTime? pauseDt;
  DateTime? continueDt;
  User? userPause;
  User? userContinue;
  String? offId;

  PauseContinue({
    this.id,
    this.timesheetId,
    this.timesheetWorkshopId,
    this.pauseDt,
    this.continueDt,
    this.userPause,
    this.userContinue,
    this.offId,
  });

  static PauseContinue fromJson(Map<String, dynamic> json) {
    return PauseContinue(
      id: json['id'],
      timesheetId: json['timesheet_task_project_id'],
      timesheetWorkshopId: json['timesheet_task_project_workshop_id'],
      pauseDt:
          json['pause_dt'] != null ? DateTime.tryParse(json['pause_dt']) : null,
      continueDt: json['continue_dt'] != null
          ? DateTime.tryParse(json['continue_dt'])
          : null,
      userPause: json['user_pause'] != null && json['user_pause']['id'] != null
          ? User.fromJson(json['user_pause'])
          : null,
      userContinue:
          json['user_continue'] != null && json['user_continue']['id'] != null
              ? User.fromJson(json['user_continue'])
              : null,
      offId: json['off_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timesheet_task_project_id': timesheetId,
      'timesheet_task_project_workshop_id': timesheetWorkshopId,
      'pause_dt': rollbackParseDateTime(pauseDt),
      'continue_dt': rollbackParseDateTime(continueDt),
      'user_pause': userPause!.toJson(),
      'user_continue': userContinue!.toJson(),
    };
  }
}
