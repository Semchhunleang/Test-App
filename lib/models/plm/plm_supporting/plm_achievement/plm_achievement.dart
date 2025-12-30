import 'package:umgkh_mobile/models/plm/plm_supporting/plm_achievement/daily_weekly_line.dart';
import 'package:umgkh_mobile/models/plm/plm_supporting/plm_achievement/monthly_line.dart';
import 'package:umgkh_mobile/models/plm/plm_supporting/plm_achievement/option_data.dart';

class PLMAchievement {
  OptionData employee;
  OptionData? department;
  OptionData? job;
  int id;
  String month;
  String year;
  List<DailyWeeklyLines>? dailyLines;
  List<DailyWeeklyLines>? weeklyLines;
  List<MonthlyLines>? monthlyLines;

  PLMAchievement({
    required this.employee,
    this.department,
    this.job,
    required this.id,
    required this.month,
    required this.year,
    this.dailyLines,
    this.weeklyLines,
    this.monthlyLines,
  });

  double get score {
    double totalScore = 0.0;
    int totalCount = 0;

    if (dailyLines != null && dailyLines!.isNotEmpty) {
      for (var daily in dailyLines!) {
        totalScore += daily.score;
      }
      totalCount += dailyLines!.length;
    }

    if (weeklyLines != null && weeklyLines!.isNotEmpty) {
      for (var weekly in weeklyLines!) {
        totalScore += weekly.score;
      }
      totalCount += weeklyLines!.length;
    }

    if (monthlyLines != null && monthlyLines!.isNotEmpty) {
      for (var monthly in monthlyLines!) {
        totalScore += monthly.score;
      }
      totalCount += monthlyLines!.length;
    }

    if (totalCount == 0) return 0.0;
    return double.parse((totalScore / totalCount).toStringAsFixed(2));
  }

  factory PLMAchievement.fromJson(Map<String, dynamic> json) {
    return PLMAchievement(
      employee: json['employee'] != null
          ? OptionData.fromJson(json['employee'])
          : OptionData(id: 0, name: ''),
      department: json['department'] != null
          ? OptionData.fromJson(json['department'])
          : null,
      job: json['job'] != null ? OptionData.fromJson(json['job']) : null,
      id: json['id'],
      month: json['month'] ?? "",
      year: json['year'] ?? "",
      dailyLines: json['daily_lines'] != null
          ? (json['daily_lines'] as List)
              .map((e) => DailyWeeklyLines.fromJson(e))
              .toList()
          : [],
      weeklyLines: json['weekly_lines'] != null
          ? (json['weekly_lines'] as List)
              .map((e) => DailyWeeklyLines.fromJson(e))
              .toList()
          : [],
      monthlyLines: json['monthly_lines'] != null
          ? (json['monthly_lines'] as List)
              .map((e) => MonthlyLines.fromJson(e))
              .toList()
          : [],
    );
  }
}
