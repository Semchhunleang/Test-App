import 'package:umgkh_mobile/models/hr/leave/leave_type.dart';

class LeaveSummary {
  final LeaveType leaveType;
  double numberOfDays;
  List<int>? leaveIds;
  

  LeaveSummary({
    required this.leaveType,
    required this.numberOfDays,
    required this.leaveIds,
  });

  factory LeaveSummary.fromJson(Map<String, dynamic> json) {
    LeaveType leave = LeaveType.fromJson(json['leave_type']);

    return LeaveSummary(
      leaveType: leave,
      numberOfDays: json['number_of_days'].toDouble(),
      leaveIds: json['leave_ids'],
    );
  }
}
