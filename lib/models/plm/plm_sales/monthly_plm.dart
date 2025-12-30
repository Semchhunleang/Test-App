import 'package:umgkh_mobile/utils/utlis.dart';

class MonthlyPLM {
  String activity;
  String state;
  double target;
  double result;
  double achievement;
  DateTime? date;

  MonthlyPLM({
    required this.activity,
    required this.state,
    required this.target,
    required this.result,
    required this.achievement,
    this.date,
  });

  factory MonthlyPLM.fromJson(Map<String, dynamic> json) {
    return MonthlyPLM(
      activity: json['activity'] ?? "",
      state: json['state'] ?? "",
      target: (json['target'] ?? 0).toDouble(),
      result: (json['result'] ?? 0).toDouble(),
      achievement: (json['achievement'] ?? 0).toDouble(),
      date: parseDateTime(json['date']),
    );
  }
}
