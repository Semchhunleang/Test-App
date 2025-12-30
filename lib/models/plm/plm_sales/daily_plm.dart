import 'package:umgkh_mobile/models/plm/plm_sales/detail_plm_line.dart';

class DailyPLM {
  String activity;
  int record;
  double result;
  List<DetailPLMLine> details;

  DailyPLM({
    required this.activity,
    required this.record,
    required this.result,
    required this.details,
  });

  factory DailyPLM.fromJson(Map<String, dynamic> json) {
    var detailJson = json['details'] as List? ?? [];
    List<DetailPLMLine> detailList =
        detailJson.map((json) => DetailPLMLine.fromJson(json)).toList();

    return DailyPLM(
      activity: json['activity'] ?? "",
      record: json['record'] ?? 0,
      result: (json['result'] ?? 0).toDouble(),
      details: detailList,
    );
  }
}
