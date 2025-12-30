class Activity {
  final int activityId;
  final String activityName;

  Activity({required this.activityId, required this.activityName});

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      activityId: json['activity_id'] ?? 0,
      activityName: json['activity_name'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'activity_id': activityId,
      'activity_name': activityName,
    };
  }
}
