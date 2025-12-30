import 'package:umgkh_mobile/utils/utlis.dart';

class Country {
  int? id;
  String? name;
  String? code;
  int? currencyId;
  int? phoneCode;
  bool? stateRequired;
  bool? zipRequired;
  DateTime? createDate;

  Country(
      {this.id,
      this.name,
      this.code,
      this.currencyId,
      this.phoneCode,
      this.stateRequired,
      this.zipRequired,
      this.createDate});

  Country.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    name = json['name'];
    code = json['code'];
    currencyId = json['currency_id'] ?? 0;
    phoneCode = json['phone_code'] ?? 0;
    stateRequired = json['state_required'];
    zipRequired = json['zip_required'];
    createDate = parseDateTime(json['create_date']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'currency_id': currencyId,
      'phone_code': phoneCode,
      'state_required': stateRequired,
      'zip_required': zipRequired,
      'create_date': rollbackParseDateTime(createDate),
    };
  }
  Country.defaultValue()
      : id = 116,
        name = 'Cambodia',
        code = 'KH';
}
