import 'package:umgkh_mobile/models/base/user/department.dart';
import 'package:umgkh_mobile/models/base/user/user.dart';
import 'package:umgkh_mobile/models/visual_board/plm_daily.dart';
import 'package:umgkh_mobile/models/visual_board/plm_monthly.dart';
import 'package:umgkh_mobile/models/visual_board/plm_weekly.dart';
import 'package:umgkh_mobile/models/visual_board/stage.dart';
import 'package:umgkh_mobile/utils/utlis.dart';

class VisualBoard {
  int id;
  int sequence;
  String name;
  String description;
  double? leadDay;
  double? odDay;
  DateTime? assignedDT;
  DateTime? doneDT;
  DateTime? dueDate;
  VisualBoardStage stage;
  List<User> assignees;
  List<User> requestors;
  List<Department>? departments;
  List<PLMDaily>? plmDaily;
  List<PLMWeekly>? plmWeekly;
  List<PLMMonthly>? plmMonthly;

  VisualBoard({
    required this.id,
    required this.sequence,
    required this.name,
    required this.description,
    this.leadDay,
    this.odDay,
    this.assignedDT,
    this.doneDT,
    this.dueDate,
    required this.stage,
    required this.assignees,
    required this.requestors,
    this.departments,
    this.plmDaily,
    this.plmWeekly,
    this.plmMonthly,
  });

  factory VisualBoard.fromJson(Map<String, dynamic> json) => VisualBoard(
        id: json['id'] ?? 0,
        sequence: json['sequence'] ?? 0,
        name: json['name'] ?? '',
        description: json['description'] ?? '',
        leadDay: (json['lead_day'] ?? 0).toDouble(),
        odDay: (json['od_day'] ?? 0).toDouble(),
        assignedDT: json['assigned_dt'] != null
            ? parseDateTime(json['assigned_dt'])
            : null,
        doneDT: json['done_dt'] != null ? parseDateTime(json['done_dt']) : null,
        dueDate:
            json['due_date'] != null ? parseDateTime(json['due_date']) : null,
        stage: VisualBoardStage.fromJson(json['stage']),
        assignees: (json['assignees'] as List<dynamic>?)
                ?.map((child) => User.fromJson(child as Map<String, dynamic>))
                .toList() ??
            [],
        requestors: (json['requestors'] as List<dynamic>?)
                ?.map((child) => User.fromJson(child as Map<String, dynamic>))
                .toList() ??
            [],
        departments: (json['departments'] as List<dynamic>?)
                ?.map((child) =>
                    Department.fromJson(child as Map<String, dynamic>))
                .toList() ??
            [],
        plmDaily: (json['plm_daily'] as List<dynamic>?)
                ?.map(
                    (child) => PLMDaily.fromJson(child as Map<String, dynamic>))
                .toList() ??
            [],
        plmWeekly: (json['plm_weekly'] as List<dynamic>?)
                ?.map((child) =>
                    PLMWeekly.fromJson(child as Map<String, dynamic>))
                .toList() ??
            [],
        plmMonthly: (json['plm_monthly'] as List<dynamic>?)
                ?.map((child) =>
                    PLMMonthly.fromJson(child as Map<String, dynamic>))
                .toList() ??
            [],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'sequence': sequence,
        'name': name,
        'description': description,
        'lead_day': leadDay,
        'od_day': odDay,
        // Convert DateTime objects to formatted strings (e.g., ISO 8601)
        'assigned_dt': assignedDT != null ? formatDateTime(assignedDT!) : null,
        'done_dt': doneDT != null ? formatDateTime(doneDT!) : null,
        'due_date': dueDate != null ? formatDateTime(dueDate!) : null,
        // Convert nested objects/models to their JSON representation
        'stage': stage.toJson(),
        // Convert lists of models by mapping each element to its JSON representation
        'assignees': assignees.map((e) => e.toJson()).toList(),
        'requestors': requestors.map((e) => e.toJson()).toList(),
        'departments': departments?.map((e) => e.toJson()).toList(),
      };
}
