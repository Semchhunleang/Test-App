import 'package:umgkh_mobile/models/plm/plm_supporting/plm_achievement/activity.dart';

class MonthlyLines {
  int id;
  Activity? activity;
  bool isVisualBoard;
  int? target;
  int achievement;
  String state;
  bool isLocked;

  MonthlyLines(
      {required this.id,
      this.activity,
      required this.isVisualBoard,
      this.target,
      this.achievement = 0,
      required this.state,
      this.isLocked = false});

  double get score {
    final s = state.toLowerCase();

    if (s == 'achieved') {
      return 100.0;
    } else if (s == 'not') {
      return 0.0;
    }

    return 0.0;
  }

  factory MonthlyLines.fromJson(Map<String, dynamic> json) {
    return MonthlyLines(
      id: json['id'],
      activity:
          json['activity'] != null ? Activity.fromJson(json['activity']) : null,
      isVisualBoard: json['is_visual_board'] ?? false,
      target: json['target'] ?? 0,
      achievement: json['achievement'] ?? 0,
      state: json['state'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'activity': activity?.toJson(),
      'is_visual_board': isVisualBoard,
      'target': target,
      'achievement': achievement,
      'state': state,
    };
  }
}
