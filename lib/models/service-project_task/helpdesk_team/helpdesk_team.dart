class HelpdeskTeam {
  final int id;
  final String name;

  HelpdeskTeam({
    required this.id,
    required this.name,
  });

  factory HelpdeskTeam.fromJson(Map<String, dynamic> json) {
    return HelpdeskTeam(
      id: json['id'],
      name: json['name'],
    );
  }
}
