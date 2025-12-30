import 'package:umgkh_mobile/models/base/user/work_location_coordinate.dart';

class WorkLocation {
  final int id;
  final String name;
  List<WorkLocationCoordinate>? coordinate;

  WorkLocation({
    required this.id,
    required this.name,
    this.coordinate,
  });

  factory WorkLocation.fromJson(Map<String, dynamic> json) {
    return WorkLocation(
      id: json['id'],
      name: json['name'],
      coordinate: json['coordinate'] != null
          ? (json['coordinate'] as List)
              .map((i) =>
                  WorkLocationCoordinate.fromJson(Map<String, dynamic>.from(i),),)
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'coordinate': coordinate?.map((v) => v.toJson(),).toList(),
    };
  }
}
