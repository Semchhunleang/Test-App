import 'package:umgkh_mobile/models/plm/plm_supporting/plm_target/activity.dart';
import 'package:umgkh_mobile/models/plm/plm_supporting/plm_target/model.dart';

class Targets {
  int id;
  int target;
  String type;
  bool isVisualBoard;
  Activity? activity;
  Model? model;

  Targets({
    required this.id,
    required this.target,
    required this.type,
    required this.isVisualBoard,
    this.activity,
    this.model,
  });

  factory Targets.fromJson(Map<String, dynamic> json) {
    return Targets(
      id: json['id'] ?? 0,
      target: json['target'] ?? 0,
      type: json['type'] ?? '',
      isVisualBoard: json['is_visual_board'] ?? false,
      activity:
          json['activity'] != null ? Activity.fromJson(json['activity']) : null,
      model: json['model'] != null ? Model.fromJson(json['model']) : null,
    );
  }
}
