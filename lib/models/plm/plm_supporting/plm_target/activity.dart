class Activity {
  int id;
  String name;
  String action;
  String? remark;

  Activity({
    required this.id,
    required this.name,
    required this.action,
    this.remark,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      action: json['action'] ?? '',
      remark: json['remark'] ?? '',
    );
  }
}
