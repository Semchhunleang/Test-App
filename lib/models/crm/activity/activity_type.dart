import 'package:umgkh_mobile/utils/utlis.dart';

class ActivityType {
  int? id;
  String? name;
  String? summary;
  int? sequence;
  bool? active;
  int? delayCount;
  String? delayUnit;
  String? delayFrom;
  String? icon;
  String? decorationType;
  String? resModel;
  int? triggeredNextTypeId;
  String? chainingType;
  String? category;
  int? defaultUserId;
  String? defaultNote;
  int? folderId;
  bool? attachmentRequired;
  DateTime? createDate;

  ActivityType(
      {this.id,
      this.name,
      this.summary,
      this.sequence,
      this.active,
      this.delayCount,
      this.delayUnit,
      this.delayFrom,
      this.icon,
      this.decorationType,
      this.resModel,
      this.triggeredNextTypeId,
      this.chainingType,
      this.category,
      this.defaultUserId,
      this.defaultNote,
      this.folderId,
      this.attachmentRequired,
      this.createDate});

  ActivityType.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    name = json['name'];
    summary = json['summary'];
    sequence = json['sequence'] ?? 0;
    active = json['active'];
    delayCount = json['delay_count'] ?? 0;
    delayUnit = json['delay_unit'];
    delayFrom = json['delay_from'];
    icon = json['icon'];
    decorationType = json['decoration_type'];
    resModel = json['res_model'];
    triggeredNextTypeId = json['triggered_next_type_id'];
    chainingType = json['chaining_type'];
    category = json['category'];
    defaultUserId = json['default_user_id'] ?? 0;
    defaultNote = json['default_note'];
    folderId = json['folder_id'];
    attachmentRequired = json['attachment_required'] ?? false;
    createDate = parseDateTime(json['create_date']);
  }
}
