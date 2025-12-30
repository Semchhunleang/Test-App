import 'package:umgkh_mobile/models/plm/plm_supporting/plm_achievement/activity.dart';
import 'package:umgkh_mobile/models/plm/plm_supporting/plm_achievement/detail.dart';

class DailyWeeklyLines {
  final int id;
  final Activity? activity;
  final List<Detail>? detail;

  DailyWeeklyLines({
    required this.id,
    this.activity,
    this.detail,
  });
  double get score {
    if (detail == null || detail!.isEmpty) return 0.0;

    int achievedCount =
        detail!.where((d) => d.state.toLowerCase() == 'achieved').length;
    int notCount = detail!.where((d) => d.state.toLowerCase() == 'not').length;

    int total = achievedCount + notCount;
    if (total == 0) return 0.0;

    double percent = (achievedCount / total) * 100;
    return double.parse(percent.toStringAsFixed(2));
  }

  factory DailyWeeklyLines.fromJson(Map<String, dynamic> json) {
    return DailyWeeklyLines(
      id: json['id'] ?? 0,
      activity:
          json['activity'] != null ? Activity.fromJson(json['activity']) : null,
      detail: (json['detail_id'] as List<dynamic>?)
          ?.map((v) => Detail.fromJson(v))
          .toList(),
    );
  }
}
