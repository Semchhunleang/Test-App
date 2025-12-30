class StaticSelection {
  final int id;
  final String name;
  final String value;
  final int sequence;
  final String team;

  StaticSelection({
    this.id = 0,
    this.sequence = 0,
    this.name = '',
    this.value = '',
    this.team = '',
  });

  factory StaticSelection.fromJson(Map<String, dynamic> json) {
    return StaticSelection(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      value: json['value'] ?? '',
      sequence: json['sequence'] ?? 0,
      team: json['team'] ?? '',
    );
  }
}
