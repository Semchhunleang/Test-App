import 'package:umgkh_mobile/utils/utlis.dart';

class Selection {
  int? id;
  String? name;
  String? productName;
  DateTime? createDate;

  Selection({this.id, this.name, this.productName, this.createDate});

  Selection.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    name = json['name'];
    productName = json['product_name'];
    createDate = parseDateTime(json['create_date']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'product_name': productName,
      'create_date': rollbackParseDateTime(createDate),
    };
  }
}
