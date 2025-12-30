import 'package:umgkh_mobile/models/base/user/user.dart';
import 'package:umgkh_mobile/models/service-project_task/fs_action/fs_action.dart';
import 'package:umgkh_mobile/models/service-project_task/phenomenon/phenomenon.dart';
import 'package:umgkh_mobile/models/service-project_task/system_component/system_component.dart';
import 'package:umgkh_mobile/utils/utlis.dart';

class JobAnalytic {
  int id;
  String? serviceJobPoint;
  DateTime? actionDate;
  String? note;
  SystemComponent? system;
  Phenomenon? phenomenon;
  FsAction? action;
  User? actionBy;
  List<User>? actionsBy;
  int? projectTaskId;

  JobAnalytic({
    required this.id,
    this.serviceJobPoint,
    this.actionDate,
    this.note,
    this.system,
    this.phenomenon,
    this.action,
    this.actionBy,
    this.actionsBy,
    this.projectTaskId,
  });

  static JobAnalytic fromJson(Map<String, dynamic> json) {
    SystemComponent? system =
        json['system'] != null && json['system']['id'] != null
            ? SystemComponent.fromJson(json['system'])
            : null;
    Phenomenon? phenomenon =
        json['phenomenon'] != null && json['phenomenon']['id'] != null
            ? Phenomenon.fromJson(json['phenomenon'])
            : null;

    FsAction? action = json['action'] != null && json['action']['id'] != null
        ? FsAction.fromJson(json['action'])
        : null;

    User? actionBy =
        json['action_by'] != null && json['action_by']['id'] != null
            ? User.fromJson(json['action_by'])
            : null;

    List<User>? actionsBy = json['actions_by'] != null
        ? (json['actions_by'] as List)
            .map(
              (i) => User.fromJson(
                Map<String, dynamic>.from(i),
              ),
            )
            .toList()
        : null;

    return JobAnalytic(
      id: json['id'],
      serviceJobPoint: json['service_job_point'] ?? '',
      actionDate: parseDateTime(json['action_date']),
      note: json['note'] ?? '',
      system: system,
      phenomenon: phenomenon,
      actionBy: actionBy,
      action: action,
      actionsBy: actionsBy,
      projectTaskId: json['project_task_id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'service_job_point': serviceJobPoint,
      'action_date': rollbackParseDateTime(actionDate),
      'note': note,
      'system': system?.toJson(),
      'phenomenon': phenomenon?.toJson(),
      'action_by': actionBy?.toJson(),
      'action': action?.toJson(),
      'actions_by': actionsBy?.map((user) => user.toJson()).toList(),
    };
  }
}
