import 'fleet_vehicle_brand.dart';

class FleetVehicleModel {
  final int? id;
  final String? name;
  final FleetVehicleBrand? brand;

  FleetVehicleModel({this.id, this.name, this.brand});

  FleetVehicleModel.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? int,
        name = json['name'] ?? "",
        brand = json['brand'] != null
            ? FleetVehicleBrand.fromJson(json['brand'])
            : null;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'brand': brand?.toJson(),
    };
  }
}
