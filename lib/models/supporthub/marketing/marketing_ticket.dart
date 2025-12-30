import 'package:umgkh_mobile/models/base/user/user.dart';
import 'package:umgkh_mobile/models/cms/a4/selection/selection.dart';
import 'package:umgkh_mobile/models/supporthub/file_attachment.dart';
import 'package:umgkh_mobile/models/supporthub/ict/supporthub_team.dart';
import 'package:umgkh_mobile/models/supporthub/marketing/marketing_product_type.dart';
import 'package:umgkh_mobile/utils/utlis.dart';

class MarketingTicket {
  int id;
  String name;
  String description;
  String state;
  MarketingProductType type;
  SupportHubTeam team;
  Selection productModel;
  DateTime createDate;
  DateTime? assignedDT;
  DateTime? doneDt;
  User requestor;
  User? assignee;
  List<int> images;
  List<FileAttachment> files;
  String productModelStr;
  bool isNew;

  MarketingTicket({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.state,
    required this.productModel,
    this.assignedDT,
    this.doneDt,
    required this.createDate,
    required this.team,
    required this.requestor,
    this.assignee,
    required this.images,
    required this.files,
    this.productModelStr = "",
    this.isNew = false,
  });

  factory MarketingTicket.fromJson(Map<String, dynamic> json) {
    User? assignee =
        json['assignee']['id'] != null ? User.fromJson(json['assignee']) : null;

    // Selection? productModel = json['product_model']['id'] != null
    //     ? Selection.fromJson(json['product_model'])
    //     : null;

    var fileJson = json['files'] as List? ?? [];
    List<FileAttachment> fileList = fileJson.map((json) {
      return FileAttachment.fromJson(json);
    }).toList();

    return MarketingTicket(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      type: MarketingProductType.fromJson(json['type']),
      state: json['state'],
      assignedDT: json['assigned_dt'] != null
          ? parseDateTime(json['assigned_dt'])
          : null,
      doneDt: json['done_dt'] != null ? parseDateTime(json['done_dt']) : null,
      createDate: parseDateTime(json['create_date']),
      team: SupportHubTeam.fromJson(json['team']),
      requestor: User.fromJson(json['requestor']),
      assignee: assignee,
      images: json['images'] != null ? List<int>.from(json['images']) : [],
      files: fileList,
      productModel: Selection.fromJson(json['product_model']),
      productModelStr: json['product_model_str'] ?? '',
      isNew: json['is_new'] ?? false,
    );
  }
}
