class ProjectTaskRel {
  int? taskId;
  int? relatedTaskId;

  ProjectTaskRel({this.taskId, this.relatedTaskId});

  static ProjectTaskRel fromJson(Map<String, dynamic> json) {
    return ProjectTaskRel(
      taskId: json['task_id'],
      relatedTaskId: json['related_task_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'task_id': taskId,
      'related_task_id': relatedTaskId,
    };
  }
}
