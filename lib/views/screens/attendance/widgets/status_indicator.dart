import 'package:flutter/material.dart';
import 'package:umgkh_mobile/models/hr/attendance/attendance.dart';

Widget statusIndicator({required Attendance attendance}) {
  IconData icon;
  Color color;
  String status;

  if (attendance.checkOutMorning != null &&
      attendance.checkInAfternoon != null &&
      attendance.checkOut != null) {
    icon = Icons.check_circle; // Example icon for fully attended
    color = Colors.green; // Example color for fully attended
    status = 'Completed';
  } else {
    icon = Icons.error; // Example icon for incomplete attendance
    color = Colors.red; // Example color for incomplete attendance
    status = 'Incomplete';
  }

  return Column(
    children: [
      Icon(icon, color: color),
      Text(status, style: TextStyle(color: color),),
    ],
  );
}
