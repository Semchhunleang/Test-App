class SaleLine {
  final int id;
  final String name;

  SaleLine({
    required this.id,
    required this.name,
  });

  factory SaleLine.fromJson(Map<String, dynamic> json) {
    return SaleLine(
      id: json['id'],
      name: json['name'],
    );
  }
}
