import 'package:umgkh_mobile/models/base/user/department.dart';

class MonthlyDepartmentPLMSales {
  int id;
  String year;
  String month;
  double score;
  Department department;

  MonthlyDepartmentPLMSales({
    required this.id,
    required this.year,
    required this.month,
    required this.score,
    required this.department,
  });

  factory MonthlyDepartmentPLMSales.fromJson(Map<String, dynamic> json) {
 
    return MonthlyDepartmentPLMSales(
      id: json['id'] ?? 0,
      year: json['year'] ?? '',
      month: json['month'] ?? '',
      score: (json['score'] ?? 0).toDouble(),
      department: Department.fromJson(json['department']),
    );
  }
}
