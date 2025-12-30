import 'package:umgkh_mobile/models/hr/leave/leave_type.dart';

class LeaveDeptSummary {
  String employeeName;
  double employeeTotalLeave;
  List<LeaveType> leaveTypes;

  LeaveDeptSummary({
    required this.employeeTotalLeave,
    required this.employeeName,
    required this.leaveTypes,
  });

  factory LeaveDeptSummary.fromJson(Map<String, dynamic> json) {
    return LeaveDeptSummary(
      employeeName: json['employee_name'],
      employeeTotalLeave: json['employee_total_leave'],
      leaveTypes: json['leave_types'],
    );
  }
}
