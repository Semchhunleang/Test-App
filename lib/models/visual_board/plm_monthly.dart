class PLMMonthly {
  int id;
  String name;

  PLMMonthly({
    required this.id,
    required this.name,
  });

  factory PLMMonthly.fromJson(Map<String, dynamic> json) => PLMMonthly(
        id: json['id'] ?? 0,
        name: json['name'] ?? "",
      );
}
