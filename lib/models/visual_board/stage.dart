class VisualBoardStage {
  int id;
  int sequence;
  String name;

  VisualBoardStage({
    required this.id,
    required this.sequence,
    required this.name,
  });

  factory VisualBoardStage.fromJson(Map<String, dynamic> json) =>
      VisualBoardStage(
        id: json['id'] ?? 0,
        sequence: json['sequence'] ?? 0,
        name: json['name'] ?? "",
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'sequence': sequence,
        'name': name,
      };
}
