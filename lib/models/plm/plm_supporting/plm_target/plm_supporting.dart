import 'package:umgkh_mobile/models/base/user/user.dart';
import 'package:umgkh_mobile/models/plm/plm_supporting/plm_target/target.dart';

class PLMTarget {
  int id;
  String year;
  String month;
  User employee;
  List<Targets> targets;

  PLMTarget({
    required this.id,
    required this.year,
    required this.month,
    required this.employee,
    required this.targets,
  });

  factory PLMTarget.fromJson(Map<String, dynamic> json) {
    return PLMTarget(
        id: json['id'] ?? 0,
        year: json['year'] ?? '',
        month: json['month'] ?? '',
        employee: json['employee'] != null
            ? User.fromJson(json['employee'])
            : User.defaultUser(id: 0, name: ''),
        targets: (json['targets'] as List<dynamic>?)
                ?.map((row) => Targets.fromJson(row as Map<String, dynamic>))
                .toList() ??
            []);
  }
}
