import 'package:umgkh_mobile/models/base/user/user.dart';
import 'package:umgkh_mobile/utils/utlis.dart';

class Overtime {
  int? id;
  String? name;
  DateTime date;
  DateTime overtimeDate;
  DateTime checkIn;
  DateTime checkOut;
  DateTime approveDHDT;
  DateTime approveHRDT;
  DateTime submitDT;
  DateTime rejectDT;
  int createUid;
  String createBy;
  int? distance;
  int? overtimeHours;
  int? overtimeMinutes;
  double? amountOvertime;
  int? resourceCalendarId;
  bool? isFirst30Min;
  String? state;
  int? approvedOvertimeHours;
  int? approvedOvertimeMinutes;
  String? dayname;
  int? requestId;
  String? requestName;
  String? reason;
  String? dhApprovedReason;
  double? standardResolutionHour;
  User? employee;

  Overtime(
      {this.id,
      this.name,
      required this.date,
      required this.overtimeDate,
      required this.checkIn,
      required this.checkOut,
      required this.approveDHDT,
      required this.approveHRDT,
      required this.submitDT,
      required this.rejectDT,
      required this.createUid,
      required this.createBy,
      this.distance,
      this.overtimeHours,
      this.overtimeMinutes,
      this.amountOvertime,
      this.resourceCalendarId,
      this.isFirst30Min,
      this.state,
      this.approvedOvertimeHours,
      this.approvedOvertimeMinutes,
      this.dayname,
      this.requestId,
      this.requestName,
      this.reason,
      this.dhApprovedReason,
      this.standardResolutionHour,
      this.employee});

  factory Overtime.fromJson(Map<String, dynamic> json) {
    return Overtime(
      id: json['id'] ?? 0,
      name: json['name'],
      date: parseDateTime(json['date']),
      overtimeDate: parseDateTime(json['overtime_date']),
      checkIn: parseDateTime(json['check_in']),
      checkOut: parseDateTime(json['check_out']),
      approveDHDT: parseDateTime(json['approve_dh_datetime']),
      approveHRDT: parseDateTime(json['approve_hr_datetime']),
      submitDT: parseDateTime(json['submit_datetime']),
      rejectDT: parseDateTime(json['reject_datetime']),
      createUid: json['create_uid'] ?? 0,
      createBy: json['create_by'] ?? '',
      distance: json['distance'] ?? 0,
      overtimeHours: json['overtime_hours'] ?? 0,
      overtimeMinutes: json['overtime_minutes'] ?? 0,
      amountOvertime: (json['amount_overtime'] as num?)?.toDouble(),
      resourceCalendarId: json['resource_calendar_id'],
      isFirst30Min: json['is_first_30_min'],
      state: json['state'],
      approvedOvertimeHours: json['approved_overtime_hours'] ?? 0,
      approvedOvertimeMinutes: json['approved_overtime_minutes'] ?? 0,
      dayname: json['dayname'],
      requestId: json['request_id'],
      requestName: json['request_name'] ?? '',
      reason: json['reason'],
      dhApprovedReason: json['dh_approved_reason'],
      standardResolutionHour:
          (json['standard_resolution_hour'] as num?)?.toDouble(),
      employee: json['employee'] != null
          ? User.fromJson(json['employee'] as Map<String, dynamic>)
          : null,
    );
  }
}
