class Detail {
  final int id;
  final String? date;
  final bool isVisualBoard;
  final int target;
  final int achievement;
  final String state;
  bool isLocked;

  Detail({
    required this.id,
    this.date,
    required this.isVisualBoard,
    required this.target,
    required this.achievement,
    required this.state,
    this.isLocked = false,
  });

  factory Detail.fromJson(Map<String, dynamic> json) {
    return Detail(
      id: json['id'] ?? 0,
      date: json['date'] as String?,
      isVisualBoard: json['is_visual_board'] ?? false,
      target: json['target'] ?? 0,
      achievement: json['achievement'] ?? 0,
      state: json['state'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'is_visual_board': isVisualBoard,
      'target': target,
      'achievement': achievement,
      'state': state
    };
  }
}
