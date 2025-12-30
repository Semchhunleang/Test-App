class PLMDaily {
  int id;
  String name;

  PLMDaily({
    required this.id,
    required this.name,
  });

  factory PLMDaily.fromJson(Map<String, dynamic> json) => PLMDaily(
        id: json['id'] ?? 0,
        name: json['name'] ?? "",
      );
}
