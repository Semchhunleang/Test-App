class Stage {
  final int id;
  final int? sequence;
  final String name;

  Stage({
    required this.id,
    this.sequence,
    required this.name,
  });

  factory Stage.fromJson(Map<String, dynamic> json) {
    return Stage(
      id: json['id'],
      sequence: json['sequence'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'sequence':sequence
    };
  }
}
