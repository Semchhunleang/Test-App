import 'package:umgkh_mobile/models/base/user/user.dart';
import '../../../utils/utlis.dart';

class RequestOvertime {
  final int id;
  final int overtimeHours;
  final int? overtimeMinutes;
  final int dhOvertimeHours;
  final int dhOvertimeMinutes;
  final String? reason;
  final DateTime? submitDatetime;
  final DateTime? approveDhDatetime;
  final DateTime? rejectDatetime;
  final int? createUid;
  final String? createBy;
  final String? state;
  final String name;
  final User? employee;
  final DateTime? overtimeDate;
  final int? resourceCalendarId;
  final int? companyId;
  final int? currencyId;
  final int? overtimeId;

  RequestOvertime({
    required this.id,
    required this.overtimeHours,
    this.overtimeMinutes,
    required this.dhOvertimeHours,
    required this.dhOvertimeMinutes,
    this.reason,
    this.submitDatetime,
    this.approveDhDatetime,
    this.rejectDatetime,
    this.createUid,
    this.createBy,
    this.state,
    required this.name,
    this.employee,
    required this.overtimeDate,
    this.resourceCalendarId,
    this.companyId,
    this.currencyId,
    this.overtimeId,
  });

  factory RequestOvertime.fromJson(Map<String, dynamic> json) {
    return RequestOvertime(
      id: json['id'] as int? ?? 0,
      overtimeHours: json['overtime_hours'] as int? ?? 0,
      overtimeMinutes: json['overtime_minutes'] as int? ?? 0,
      dhOvertimeHours: json['dh_overtime_hours'] as int? ?? 0,
      dhOvertimeMinutes: json['dh_overtime_minutes'] as int? ?? 0,
      reason: json['reason'] as String? ?? "",
      submitDatetime: parseDateTime(json['submit_datetime']),
      approveDhDatetime: parseDateTime(json['approve_dh_datetime']),
      rejectDatetime: parseDateTime(json['reject_datetime']),
      createUid: json['create_uid'] ?? 0,
      createBy: json['create_by'],
      state: json['state'] as String? ?? "",
      name: json['name'] as String? ?? "",
      employee: json['employee'] != null
          ? User.fromJson(json['employee'] as Map<String, dynamic>)
          : null,
      overtimeDate: parseDateTime(json['overtime_date']),
      resourceCalendarId: json['resource_calendar_id'] as int? ?? 0,
      companyId: json['company_id'] as int? ?? 0,
      currencyId: json['currency_id'] as int? ?? 0,
      overtimeId: json['overtime_id'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'overtime_hours': overtimeHours,
      'overtime_minutes': overtimeMinutes,
      'dh_overtime_hours': dhOvertimeHours,
      'dh_overtime_minutes': dhOvertimeMinutes,
      'reason': reason,
      'submit_datetime': submitDatetime,
      'approve_dh_datetime': approveDhDatetime,
      'reject_datetime': rejectDatetime,
      'create_uid': createUid,
      'create_by': createBy,
      'state': state,
      'name': name,
      'employee': employee,
      'overtime_date': overtimeDate,
      'resource_calendar_id': resourceCalendarId,
      'company_id': companyId,
      'currency_id': currencyId,
      'overtime_id': overtimeId,
    };
  }
}
