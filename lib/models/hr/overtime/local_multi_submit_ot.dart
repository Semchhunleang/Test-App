import 'package:flutter/material.dart';
import 'package:umgkh_mobile/models/hr/overtime/overtime_attendance.dart';
import 'package:umgkh_mobile/models/hr/request_overtime/request_overtime.dart';

class LocalMultiSubmitOT {
  RequestOvertime request;
  OvertimeAttendance otAttendance;
  TextEditingController reason;
  TextEditingController distance;
  TextEditingController approveHr;
  TextEditingController approveMin;

  LocalMultiSubmitOT({
    required this.request,
    required this.otAttendance,
    required this.reason,
    required this.distance,
    required this.approveHr,
    required this.approveMin,
  });
}
