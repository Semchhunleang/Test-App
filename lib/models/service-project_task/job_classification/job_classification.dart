class JobClassification {
  final int id;
  final String name;

  JobClassification({
    required this.id,
    required this.name,
  });

  factory JobClassification.fromJson(Map<String, dynamic> json) {
    return JobClassification(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name
    };
  }
}
