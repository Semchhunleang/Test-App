import 'package:umgkh_mobile/models/base/user/user.dart';
import 'package:umgkh_mobile/models/plm/plm_sales/daily_plm.dart';
import 'package:umgkh_mobile/models/plm/plm_sales/monthly_plm.dart';
import 'package:umgkh_mobile/models/plm/plm_sales/weekly_plm.dart';

class PLMSales {
  int id;
  String year;
  String month;
  double score;
  User sales;
  List<DailyPLM> daily;
  List<WeeklyPLM> weekly;
  List<MonthlyPLM> monthly;

  PLMSales({
    required this.id,
    required this.year,
    required this.month,
    required this.score,
    required this.sales,
    required this.daily,
    required this.weekly,
    required this.monthly,
  });

  factory PLMSales.fromJson(Map<String, dynamic> json) {
    var dailyJson = json['daily'] as List? ?? [];
    List<DailyPLM> dailyList =
        dailyJson.map((json) => DailyPLM.fromJson(json)).toList();
    var weeklyJson = json['weekly'] as List? ?? [];
    List<WeeklyPLM> weeklyList =
        weeklyJson.map((json) => WeeklyPLM.fromJson(json)).toList();
    var monthlyJson = json['monthly'] as List? ?? [];
    List<MonthlyPLM> monthlyList =
        monthlyJson.map((json) => MonthlyPLM.fromJson(json)).toList();

    return PLMSales(
      id: json['id'] ?? 0,
      year: json['year'] ?? '',
      month: json['month'] ?? '',
      score: (json['score'] ?? 0).toDouble(),
      sales: User.fromJson(json['sales']),
      daily: dailyList,
      weekly: weeklyList,
      monthly: monthlyList,
    );
  }
}
