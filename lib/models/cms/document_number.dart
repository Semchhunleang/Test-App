import 'package:umgkh_mobile/utils/utlis.dart';

class DocumentNumber {
  int? id;
  int? revId;
  String? name;
  DateTime? revDate;
  DateTime? createDate;
  DocumentNumber(
      {this.id, this.revId, this.name, this.revDate, this.createDate});

  DocumentNumber.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    revId = json['rev_id'] ?? 0;
    name = json['name'];
    revDate = parseDateTime(json['rev_date']);
    createDate = parseDateTime(json['create_date']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rev_id': revId,
      'name': name,
      'rev_date': rollbackParseDateTime(revDate),
      'create_date': rollbackParseDateTime(createDate),
    };
  }
}
