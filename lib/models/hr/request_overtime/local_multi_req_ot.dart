import 'package:flutter/material.dart';
import 'package:umgkh_mobile/models/base/user/user.dart';

class LocalMultiReqOT {
  TextEditingController overtimeHours;
  TextEditingController overtimeMinutes;
  // final int dhOvertimeHours;
  // final int dhOvertimeMinutes;
  TextEditingController reason;
  User employee;
  TextEditingController overtimeDate;

  LocalMultiReqOT({
    required this.overtimeHours,
    required this.overtimeMinutes,
    // required this.dhOvertimeHours,
    // required this.dhOvertimeMinutes,
    required this.reason,
    required this.employee,
    required this.overtimeDate,
  });

  @override
  String toString() {
    return 'overtimeHours: ${overtimeHours.text}, '
        'overtimeMinutes: ${overtimeMinutes.text}, '
        'reason: ${reason.text}, '
        'employee: ${employee.name}, '
        'overtimeDate: ${overtimeDate.text})';
  }
  // Map<String, dynamic> toJson() {
  //   return {
  //     'id': id,
  //     'overtime_hours': overtimeHours,
  //     'overtime_minutes': overtimeMinutes,
  //     'dh_overtime_hours': dhOvertimeHours,
  //     'dh_overtime_minutes': dhOvertimeMinutes,
  //     'reason': reason,
  //     'submit_datetime': submitDatetime,
  //     'approve_dh_datetime': approveDhDatetime,
  //     'reject_datetime': rejectDatetime,
  //     'state': state,
  //     'name': name,
  //     'employee': employee,
  //     'overtime_date': overtimeDate,
  //     'resource_calendar_id': resourceCalendarId,
  //     'company_id': companyId,
  //     'currency_id': currencyId,
  //     'overtime_id': overtimeId,
  //   };
  // }
}
