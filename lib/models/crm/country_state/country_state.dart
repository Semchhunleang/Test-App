import 'package:umgkh_mobile/utils/utlis.dart';

class CountryState {
  int? id;
  int? countryId;
  String? name;
  String? code;
  DateTime? createDate;

  CountryState(
      {this.id, this.countryId, this.name, this.code, this.createDate});

  CountryState.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    countryId = json['country_id'] ?? 0;
    name = json['name'];
    code = json['code'];
    createDate = parseDateTime(json['create_date']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'country_id': countryId,
      'createDate': rollbackParseDateTime(createDate),
    };
  }
  CountryState.defaultValue()
      : id = 1559,
        name = 'Phnom Penh',
        code = 'PP';
}
