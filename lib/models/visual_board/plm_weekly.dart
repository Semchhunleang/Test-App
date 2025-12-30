class PLMWeekly {
  int id;
  String name;

  PLMWeekly({
    required this.id,
    required this.name,
  });

  factory PLMWeekly.fromJson(Map<String, dynamic> json) => PLMWeekly(
        id: json['id'] ?? 0,
        name: json['name'] ?? "",
      );
}
