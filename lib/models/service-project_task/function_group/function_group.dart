class FunctionGroup {
  final int id;
  final String name;

  FunctionGroup({
    required this.id,
    required this.name,
  });

  factory FunctionGroup.fromJson(Map<String, dynamic> json) {
    return FunctionGroup(
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
