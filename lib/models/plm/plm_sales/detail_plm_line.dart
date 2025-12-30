import 'package:umgkh_mobile/utils/utlis.dart';

class DetailPLMLine {
  int id;
  DateTime? date;
  DateTime? dateStart;
  DateTime? dateEnd;
  double target;
  double achievement;
  String state;

  DetailPLMLine({
    required this.id,
    required this.date,
    required this.dateStart,
    required this.dateEnd,
    required this.target,
    required this.achievement,
    required this.state,
  });

  factory DetailPLMLine.fromJson(Map<String, dynamic> json) {
    return DetailPLMLine(
      id: json['id'] ?? 0,
      date: parseDateTime(json['date']),
      dateStart: parseDateTime(json['date_start']),
      dateEnd: parseDateTime(json['date_end']),
      target: (json['target'] ?? 0).toDouble(),
      achievement: (json['achievement'] ?? 0).toDouble(),
      state: json['state'] ?? "",
    );
  }
}
