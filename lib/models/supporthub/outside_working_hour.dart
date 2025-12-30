class OutsideWorkingHours {
  final bool isOutsideWorkHours;
  final bool isHoliday;

  OutsideWorkingHours(
      {this.isOutsideWorkHours = false, this.isHoliday = false});

  factory OutsideWorkingHours.fromJson(Map<String, dynamic> json) {
    return OutsideWorkingHours(
        isOutsideWorkHours: json['is_outside_work_hours'],
        isHoliday: json['is_holiday']);
  }
}
