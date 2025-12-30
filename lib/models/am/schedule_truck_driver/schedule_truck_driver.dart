import 'package:umgkh_mobile/models/am/vehicle_check/fleet_vehicle.dart';
import 'package:umgkh_mobile/models/base/user/user.dart';
import 'package:umgkh_mobile/utils/utlis.dart';

class ScheduleTruckDriver {
  int id;
  String name;
  DateTime requestDatetime;
  DateTime? approveDatetime;
  DateTime? scheduleDeliveryDatetime;
  DateTime? actualDeliveryDatetime;
  DateTime? scheduleArriveDatetime;
  DateTime? actualArriveDatetime;
  DateTime createDate;
  double? kmStart;
  double? kmEnd;
  double? totalKm;
  String state;
  String? tag;
  FleetVehicle? vehicle;
  User requestor;
  User? driver;

  ScheduleTruckDriver({
    required this.id,
    required this.name,
    required this.requestDatetime,
    this.approveDatetime,
    this.scheduleDeliveryDatetime,
    this.actualDeliveryDatetime,
    this.scheduleArriveDatetime,
    this.actualArriveDatetime,
    required this.createDate,
    this.kmStart,
    this.kmEnd,
    this.totalKm,
    required this.state,
    this.tag,
    this.vehicle,
    required this.requestor,
    this.driver,
  });

  factory ScheduleTruckDriver.fromJson(Map<String, dynamic> json) {
    return ScheduleTruckDriver(
      id: json['id'],
      name: json['name'],
      requestDatetime: parseDateTime(json['request_datetime']),
      approveDatetime: json['approve_datetime'] != null
          ? parseDateTime(json['approve_datetime'])
          : null,
      scheduleDeliveryDatetime: json['schedule_delivery_datetime'] != null
          ? parseDateTime(json['schedule_delivery_datetime'])
          : null,
      actualDeliveryDatetime: json['actual_delivery_datetime'] != null
          ? parseDateTime(json['actual_delivery_datetime'])
          : null,
      scheduleArriveDatetime: json['schedule_arrive_datetime'] != null
          ? parseDateTime(json['schedule_arrive_datetime'])
          : null,
      actualArriveDatetime: json['actual_arrive_datetime'] != null
          ? parseDateTime(json['actual_arrive_datetime'])
          : null,
      createDate: parseDateTime(json['create_date']),
      kmStart: (json['km_start'] as num?)?.toDouble(),
      kmEnd: (json['km_end'] as num?)?.toDouble(),
      totalKm: (json['total_km'] as num?)?.toDouble(),
      state: json['state'],
      tag: json['tag'] ?? '',
      vehicle: (json['vehicle'] != null && json['vehicle']['id'] != null)
          ? FleetVehicle.fromJson(json['vehicle'])
          : null,
      requestor: User.fromJson(json['requestor']),
      driver: (json['driver'] != null && json['driver']['id'] != null)
          ? User.fromJson(json['driver'])
          : null,
    );
  }
}
