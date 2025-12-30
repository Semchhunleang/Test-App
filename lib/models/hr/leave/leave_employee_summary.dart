import 'package:umgkh_mobile/models/hr/leave/leave_summary.dart';

class LeaveEmployeeSummary {
  int userId;
  String name;
  List<LeaveSummary> summaries;
  double numberOfDays;

  LeaveEmployeeSummary({
    required this.userId,
    required this.name,
    required this.summaries,
    required this.numberOfDays,
  });

  factory LeaveEmployeeSummary.fromJson(Map<String, dynamic> json) {
    var summariesJson = json['summaries'] as List;
    List<LeaveSummary> summariesList = summariesJson.map((summaryJson) {
      return LeaveSummary.fromJson(summaryJson);
    }).toList();

    return LeaveEmployeeSummary(
      userId: json['user_id'],
      name: json['name'],
      summaries: summariesList,
      numberOfDays: json['number_of_days'],
    );
  }
}
