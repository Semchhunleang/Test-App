import 'package:umgkh_mobile/models/base/user/user.dart';
import 'package:umgkh_mobile/models/supporthub/file_attachment.dart';
import 'package:umgkh_mobile/utils/utlis.dart';

class ERPTicket {
  int id;
  String name;
  String description;
  String contact;
  String state;
  String erpRequestType;
  String? contactType;
  String? rejectReason;
  DateTime createDate;
  User requestor;
  User? assignee;
  User? salesperson;
  List<int> images;
  List<FileAttachment> files;

  ERPTicket(
      {required this.id,
      required this.name,
      required this.description,
      required this.contact,
      required this.state,
      required this.erpRequestType,
      this.contactType,
      this.rejectReason,
      required this.createDate,
      required this.requestor,
      this.assignee,
      this.salesperson,
      required this.images,
      required this.files});

  factory ERPTicket.fromJson(Map<String, dynamic> json) {
    User? assignee =
        json['assignee']['id'] != null ? User.fromJson(json['assignee']) : null;

    User? salesperson = json['salesperson']['id'] != null
        ? User.fromJson(json['salesperson'])
        : null;

    var fileJson = json['files'] as List? ?? [];
    List<FileAttachment> fileList = fileJson.map((json) {
      return FileAttachment.fromJson(json);
    }).toList();

    return ERPTicket(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      contact: json['contact'] ?? '',
      state: json['state'],
      erpRequestType: json['erp_request_type'],
      contactType: json['contact_type'],
      rejectReason: json['reject_reason'],
      createDate: parseDateTime(json['create_date']),
      requestor: User.fromJson(json['requestor']),
      assignee: assignee,
      salesperson: salesperson,
      images: json['images'] != null ? List<int>.from(json['images']) : [],
      files: fileList,
    );
  }
}
