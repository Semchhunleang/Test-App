class MachineApplication {
  final int id;
  final String name;

  MachineApplication({
    required this.id,
    required this.name,
  });

  factory MachineApplication.fromJson(Map<String, dynamic> json) {
    return MachineApplication(
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
