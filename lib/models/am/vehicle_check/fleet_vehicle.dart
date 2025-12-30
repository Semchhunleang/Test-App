import 'fleet_vehicle_model.dart';

class FleetVehicle {
  final int? id;
  final String? name;
  final String? licensePlate;
  final num? odometer;
  final FleetVehicleModel? model;

  FleetVehicle({
    this.id,
    this.name,
    this.licensePlate,
    this.odometer,
    this.model,
  });

  FleetVehicle.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? int,
        name = json['name'] ?? "",
        licensePlate = json['license_plate'] ?? "",
        odometer = json['odometer'] ?? 0,
        model = json['model'] != null
            ? FleetVehicleModel.fromJson(json['model'])
            : null;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'license_plate': licensePlate,
      'odometer': odometer,
      'model': model?.toJson(),
    };
  }

  FleetVehicle copyWith({
    int? id,
    String? name,
    String? licensePlate,
    num? odometer,
    FleetVehicleModel? model,
  }) {
    return FleetVehicle(
      id: id ?? this.id,
      name: name ?? this.name,
      licensePlate: licensePlate ?? this.licensePlate,
      odometer: odometer ?? this.odometer,
      model: model ?? this.model,
    );
  }
}
