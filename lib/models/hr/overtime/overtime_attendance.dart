import 'package:umgkh_mobile/utils/utlis.dart';

class OvertimeAttendance {
  bool? isFirst30Min;
  DateTime? checkIn;
  DateTime? checkOut;
  int? workedDurationHour;
  int? workedDurationMinute;
  int? durationHour;
  int? durationMinute;
  int? multiplier;
  double? amount;

  OvertimeAttendance(
      {this.isFirst30Min,
      this.checkIn,
      this.checkOut,
      this.workedDurationHour,
      this.workedDurationMinute,
      this.durationHour,
      this.durationMinute,
      this.multiplier,
      this.amount});

  OvertimeAttendance.fromJson(Map<String, dynamic> json) {
    isFirst30Min = json['is_first_30_min'];
    checkIn = parseDateTime(json['check_in']);
    checkOut = parseDateTime(json['check_out']);
    workedDurationHour = json['worked_duration_hour'];
    workedDurationMinute = json['worked_duration_minute'];
    durationHour = json['duration_hour'];
    durationMinute = json['duration_minute'];
    multiplier = json['multiplier'];
    amount = json['amount'];
  }
}
