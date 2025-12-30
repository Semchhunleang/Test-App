import 'package:umgkh_mobile/models/base/user/user.dart';
import 'package:umgkh_mobile/models/supporthub/ict/ict_device_brand.dart';
import 'package:umgkh_mobile/models/supporthub/ict/ict_device_model.dart';
import 'package:umgkh_mobile/models/supporthub/ict/ict_device_type.dart';
import 'package:umgkh_mobile/utils/utlis.dart';

class ICTDevices {
  int id;
  String name;
  String serialNumber;
  DateTime purchaseDate;
  ICTDeviceType? type;
  ICTDeviceBrand? brand;
  ICTDeviceModel? model;
  User? pic;

  ICTDevices({
    required this.id,
    required this.name,
    required this.serialNumber,
    required this.purchaseDate,
    this.type,
    this.brand,
    this.model,
    this.pic,
  });

  factory ICTDevices.fromJson(Map<String, dynamic> json) {
    return ICTDevices(
      id: json['id'],
      name: json['name'] ?? '',
      serialNumber:
          json.containsKey('serial_number') && json['serial_number'] != null
              ? json['serial_number']
              : '',
      purchaseDate:
          json.containsKey('purchase_date') && json['purchase_date'] != null
              ? parseDateTime(json['purchase_date'])
              : nullDt,
      type: json.containsKey('type') &&
              json['type'] is Map &&
              json['type']['id'] != null
          ? ICTDeviceType.fromJson(json['type'])
          : null,
      brand: json.containsKey('brand') &&
              json['brand'] is Map &&
              json['brand']['id'] != null
          ? ICTDeviceBrand.fromJson(json['brand'])
          : null,
      model: json.containsKey('model') &&
              json['model'] is Map &&
              json['model']['id'] != null
          ? ICTDeviceModel.fromJson(json['model'])
          : null,
      pic: json.containsKey('pic') &&
              json['pic'] is Map &&
              json['pic']['id'] != null
          ? User.fromJson(json['pic'])
          : null,
    );
  }

  factory ICTDevices.defaultData({required int id, required String name}) {
    return ICTDevices(
      id: id,
      name: name,
      serialNumber: '',
      purchaseDate: DateTime.now(),
    );
  }
}
