import 'package:flutter/material.dart';
import 'package:umgkh_mobile/models/hr/leave/leave.dart';
import 'package:umgkh_mobile/utils/static_state.dart';

Widget leaveStatusIndicator({required Leave leave}) {
  IconData icon;
  Color color;
  String status;

  if (leave.state == draft) {
    icon = Icons.error; //
    color = const Color.fromARGB(255, 127, 135, 139);
    status = 'To Submit';
  } else if (leave.state == confirm) {
    icon = Icons.error; //
    color = const Color.fromARGB(255, 236, 220, 70);
    status = 'To Approve';
  } else if (leave.state == refuse) {
    icon = Icons.cancel; //
    color = const Color.fromARGB(255, 236, 20, 20);
    status = 'Refused';
  } else {
    icon = Icons.check_circle;
    color = const Color.fromARGB(255, 5, 180, 8);
    status = leave.state == validate1 ? 'Second Approval' : 'Approved';
  }

  return Padding(
    padding: const EdgeInsets.all(5.0),
    child: Column(
      children: [
        Icon(icon, color: color),
        Text(
          status,
          style: TextStyle(color: color),
        ),
      ],
    ),
  );
}
