class FleetVehicleBrand {
  final int? id;
  final String? name;

  FleetVehicleBrand({this.id, this.name});

  FleetVehicleBrand.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? int,
        name = json['name'] ?? "";

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
