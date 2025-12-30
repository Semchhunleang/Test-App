import 'package:umgkh_mobile/models/base/user/user.dart';
import 'package:umgkh_mobile/utils/utlis.dart';

class JobAssignLine {
  int? id;
  User mechanic;
  DateTime? assignedDt;
  DateTime? acceptedDt;
  DateTime? rejectedDt;
  String? reason;
  String? state;

  JobAssignLine({
    this.id,
    required this.mechanic,
    this.assignedDt,
    this.acceptedDt,
    this.rejectedDt,
    this.reason,
    this.state,
  });

  static JobAssignLine fromJson(Map<String, dynamic> json) {
    User mechanic = User.fromJson(json['mechanic']);

    return JobAssignLine(
      id: json['id'],
      mechanic: mechanic,
      assignedDt: json['assigned_dt'] != null
          ? parseDateTime(json['assigned_dt'])
          : null,
      acceptedDt: json['accepted_dt'] != null
          ? parseDateTime(json['accepted_dt'])
          : null,
      rejectedDt: json['rejected_dt'] != null
          ? parseDateTime(json['rejected_dt'])
          : null,
      reason: json['reason'] ?? '',
      state: json['state'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mechanic': mechanic.toJson(),
      'assigned_dt': rollbackParseDateTime(assignedDt),
      'accepted_dt': rollbackParseDateTime(acceptedDt),
      'rejected_dt': rollbackParseDateTime(rejectedDt),
      'reason': reason,
      'state': state,
    };
  }
}
