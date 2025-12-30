class SupportHubTeam {
  int id;
  String name;

  SupportHubTeam({
    required this.id,
    required this.name,
  });

  factory SupportHubTeam.fromJson(Map<String, dynamic> json) {
    return SupportHubTeam(
      id: json['id'],
      name: json['name'],
    );
  }
}
