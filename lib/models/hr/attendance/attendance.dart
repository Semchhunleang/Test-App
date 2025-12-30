class Attendance {
  final int id;
  final int employeeId;
  final DateTime checkIn;
  final DateTime? checkOut;
  final double workedHours;
  final DateTime createDate;
  final DateTime writeDate;
  final String? reasonCheckIn;
  final String? reasonCheckOut;
  final DateTime? checkOutMorning;
  final DateTime? checkInAfternoon;
  final String? reasonCheckInAfternoon;
  final String? reasonCheckOutMorning;
  final int? lateId;
  final String employeeName;
  final String? creatorUsername;
  final String? updaterUsername;
  final String? lateType;
  final int? imageCheckIn;
  final int? imageCheckOutMorning;
  final int? imageCheckInAfternoon;
  final int? imageCheckOut;

  Attendance({
    required this.id,
    required this.employeeId,
    required this.checkIn,
    this.checkOut,
    required this.workedHours,
    required this.createDate,
    required this.writeDate,
    required this.reasonCheckIn,
    this.reasonCheckOut,
    this.checkOutMorning,
    this.checkInAfternoon,
    this.reasonCheckInAfternoon,
    this.reasonCheckOutMorning,
    this.lateId,
    required this.employeeName,
    this.creatorUsername,
    this.updaterUsername,
    this.lateType,
    this.imageCheckIn,
    this.imageCheckOutMorning,
    this.imageCheckInAfternoon,
    this.imageCheckOut,
  });

  // Factory method to parse JSON
  factory Attendance.fromJson(Map<String, dynamic> json) {
    DateTime? parseDateTime(String? dateStr) {
      if (dateStr == null) return null;
      return DateTime.parse(dateStr).toLocal();
    }

    return Attendance(
      id: json['id'],
      employeeId: json['employee_id'],
      checkIn: parseDateTime(json['check_in'])!,
      checkOut: parseDateTime(json['check_out']),
      workedHours: json['worked_hours'].toDouble(),
      createDate: parseDateTime(json['create_date'])!,
      writeDate: parseDateTime(json['write_date'])!,
      reasonCheckIn: json['reason_check_in'],
      reasonCheckOut: json['reason_check_out'],
      checkOutMorning: parseDateTime(json['check_out_morning']),
      checkInAfternoon: parseDateTime(json['check_in_afternoon']),
      reasonCheckInAfternoon: json['reason_check_in_afternoon'],
      reasonCheckOutMorning: json['reason_check_out_morning'],
      lateId: json['late_id'],
      employeeName: json['employee_name'],
      creatorUsername: json['creator_username'],
      updaterUsername: json['updater_username'],
      lateType: json['late_type'],
      imageCheckIn: json['image_check_in'],
      imageCheckOutMorning: json['image_check_out_morning'],
      imageCheckInAfternoon: json['image_check_in_afternoon'],
      imageCheckOut: json['image_check_out'],
    );
  }
}
