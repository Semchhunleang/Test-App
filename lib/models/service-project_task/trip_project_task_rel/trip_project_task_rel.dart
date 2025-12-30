class TripProjectTaskRel {
  int? taskId;
  int? tripId;
  String? tripOffId;

  TripProjectTaskRel({this.taskId, this.tripId, this.tripOffId});

  static TripProjectTaskRel fromJson(Map<String, dynamic> json) {
    return TripProjectTaskRel(
      taskId: json['task_id'],
      tripId: json['trip_id'],
      tripOffId: json['trip_off_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'task_id': taskId,
      'trip_id': tripId,
      'trip_off_id': tripOffId,
    };
  }
}
