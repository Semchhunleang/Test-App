import 'package:umgkh_mobile/utils/utlis.dart';

class NenamVersion {
  int id;
  String version;
  DateTime activeDate;

  NenamVersion({
    required this.id,
    required this.version,
    required this.activeDate,
  });

  factory NenamVersion.fromJson(Map<String, dynamic> json) {
    return NenamVersion(
      id: json['id'],
      version: json['version'] ?? '-',
      activeDate: parseDateTime(json['active_date']),
    );
  }
}
