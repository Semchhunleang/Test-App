class WorkLocationCoordinate {
  final int id;
  final int partnerId;
  final double? longitude;
  final double? latitude;

  WorkLocationCoordinate({
    required this.id,
    required this.partnerId,
    required this.longitude,
    required this.latitude,
  });

  factory WorkLocationCoordinate.fromJson(Map<String, dynamic> json) {
    return WorkLocationCoordinate(
      id: json['id'] ?? 0,
      partnerId: json['partner_id'] ?? 0,
      longitude: json['longitude'],
      latitude: json['latitude'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'partner_id': partnerId,
      'longitude': longitude,
      'latitude': latitude,
    };
  }
}
