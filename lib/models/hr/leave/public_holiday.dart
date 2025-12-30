import 'package:umgkh_mobile/utils/utlis.dart';

class PublicHoliday {
  int id;
  String name;
  DateTime dateFrom;
  DateTime dateTo;
  String timeType;

  PublicHoliday({
    required this.id,
    required this.name,
    required this.dateFrom,
    required this.dateTo,
    required this.timeType,
  });

  factory PublicHoliday.fromJson(Map<String, dynamic> json) {
    return PublicHoliday(
      id: json['id'],
      name: json['name'],
      dateFrom: parseDateTime(json['date_from']),
      dateTo: parseDateTime(json['date_to']),
      timeType: json['time_type'],
    );
  }
}
