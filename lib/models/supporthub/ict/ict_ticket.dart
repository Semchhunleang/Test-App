import 'package:umgkh_mobile/models/base/user/user.dart';
import 'package:umgkh_mobile/models/supporthub/file_attachment.dart';
import 'package:umgkh_mobile/models/supporthub/ict/ict_device.dart';
import 'package:umgkh_mobile/models/supporthub/ict/ict_request_category.dart';
import 'package:umgkh_mobile/models/supporthub/ict/supporthub_team.dart';
import 'package:umgkh_mobile/utils/utlis.dart';

class ICTTicket {
  int id;
  String name;
  String description;
  String priority;
  String state;
  DateTime? assignedDT;
  DateTime? closeTicketDT;
  DateTime createDate;
  SupportHubTeam team;
  ICTRequestCategory? category;
  User requestor;
  User? assignee;
  List<int> images;
  List<FileAttachment> files;
  List<ICTDevices> devices;

  ICTTicket({
    required this.id,
    required this.name,
    required this.description,
    required this.priority,
    required this.state,
    this.assignedDT,
    this.closeTicketDT,
    required this.createDate,
    required this.team,
    this.category,
    required this.requestor,
    this.assignee,
    required this.images,
    required this.files,
    required this.devices,
  });

  factory ICTTicket.fromJson(Map<String, dynamic> json) {
    User? assignee =
        json['assignee']['id'] != null ? User.fromJson(json['assignee']) : null;

    ICTRequestCategory? category = json['ict_request_category']['id'] != null
        ? ICTRequestCategory.fromJson(json['ict_request_category'])
        : null;

    var fileJson = json['files'] as List? ?? [];
    List<FileAttachment> fileList = fileJson.map((json) {
      return FileAttachment.fromJson(json);
    }).toList();

    var deviceJson = json['devices'];
    List<ICTDevices> devicesList = deviceJson != null
        ? (deviceJson as List).map((json) => ICTDevices.fromJson(json)).toList()
        : [];

    return ICTTicket(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      priority: json['priority'] ?? '',
      state: json['state'],
      assignedDT: json['assigned_dt'] != null
          ? parseDateTime(json['assigned_dt'])
          : null,
      closeTicketDT: json['close_ticket_dt'] != null
          ? parseDateTime(json['close_ticket_dt'])
          : null,
      createDate: parseDateTime(json['create_date']),
      team: SupportHubTeam.fromJson(json['team']),
      category: category,
      requestor: User.fromJson(json['requestor']),
      assignee: assignee,
      images: json['images'] != null ? List<int>.from(json['images']) : [],
      files: fileList,
      devices: devicesList,
    );
  }
}
