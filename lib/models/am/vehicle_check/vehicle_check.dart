import 'package:umgkh_mobile/models/base/user/user.dart';
import 'package:umgkh_mobile/models/crm/city/city.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'fleet_vehicle.dart';

import 'row.dart';
import 'row_inout.dart';

class VehicleCheck {
  final int? id;
  final String? name;
  final String? state;
  final double? kmCurrent;
  final double? kmStart;
  final double? kmEnd;
  final DateTime? auditDatetime;
  final DateTime? plannedDatetimeIn;
  final DateTime? plannedDatetimeOut;
  final DateTime? actualDatetimeIn;
  final DateTime? actualDatetimeOut;
  final String? purpose;
  final String? checkType;
  final City? location;
  final User? requestor;
  final User? approver;
  final User? checker;
  final FleetVehicle? fleetVehicle;
  final List<Rows>? row;
  final List<RowInout>? rowInout;

  VehicleCheck({
    this.id,
    this.name,
    this.state,
    this.kmCurrent,
    this.kmStart,
    this.kmEnd,
    this.auditDatetime,
    this.plannedDatetimeIn,
    this.plannedDatetimeOut,
    this.actualDatetimeIn,
    this.actualDatetimeOut,
    this.purpose,
    this.checkType,
    this.location,
    this.requestor,
    this.approver,
    this.checker,
    this.fleetVehicle,
    this.row,
    this.rowInout,
  });
  VehicleCheck.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? int,
        name = json['name'] ?? "",
        state = json['state'] ?? "",
        kmCurrent = json['km_current']?.toDouble(),
        kmStart = json['km_start']?.toDouble(),
        kmEnd = json['km_end']?.toDouble(),
        auditDatetime = parseDateTime(json['audit_datetime']),
        plannedDatetimeIn = parseDateTime(json['planned_datetime_in']),
        plannedDatetimeOut = parseDateTime(json['planned_datetime_out']),
        actualDatetimeIn = json['actual_datetime_in'] != null
            ? DateTime.tryParse(json['actual_datetime_in'])
            : null,
        actualDatetimeOut = json['actual_datetime_out'] != null
            ? DateTime.tryParse(json['actual_datetime_out'])
            : null,
        purpose = json['purpose'] ?? "",
        checkType = json['check_type'] ?? "",
        location =
            json['location'] != null ? City.fromJson(json['location']) : null,
        requestor =
            json['requestor'] != null ? User.fromJson(json['requestor']) : null,
        approver =
            json['approver'] != null ? User.fromJson(json['approver']) : null,
        checker =
            json['checker'] != null ? User.fromJson(json['checker']) : null,
        fleetVehicle = json['fleet_vehicle'] != null
            ? FleetVehicle.fromJson(json['fleet_vehicle'])
            : null,
        row =
            (json['row'] as List?)?.map((item) => Rows.fromJson(item),).toList(),
        rowInout = (json['row_inout'] as List?)
            ?.map((item) => RowInout.fromJson(item),)
            .toList();
}
