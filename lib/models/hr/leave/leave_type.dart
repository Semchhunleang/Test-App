class LeaveType {
  int id;
  String name;
  String? requestUnit;
  double? numberOfDays;

  LeaveType({
    required this.id,
    required this.name,
    this.requestUnit,
    this.numberOfDays,
  });

  factory LeaveType.fromJson(Map<String, dynamic> json) {
    return LeaveType(
      id: json['id'],
      name: json['name'],
      requestUnit: json['request_unit'],
      numberOfDays: double.parse(json['number_of_days']),
    );
  }
}
