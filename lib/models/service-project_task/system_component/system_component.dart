class SystemComponent {
  final int id;
  final String? name;

  SystemComponent({
    required this.id,
    this.name,
  });

  static SystemComponent fromJson(Map<String, dynamic>  json) {
    return SystemComponent(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}