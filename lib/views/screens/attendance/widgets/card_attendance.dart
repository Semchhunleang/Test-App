import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:umgkh_mobile/models/hr/attendance/attendance.dart';
import 'package:umgkh_mobile/utils/format_float_hour.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'package:umgkh_mobile/views/screens/attendance/widgets/dialog_attendance.dart';
import 'package:umgkh_mobile/views/screens/attendance/widgets/status_indicator.dart';

class CardAttendance extends StatelessWidget {
  final Attendance attendance;

  const CardAttendance({Key? key, required this.attendance}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showAttendanceDetailsDialog(context, attendance);
      },
      child: Stack(
        children: [
          Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('dd MMMM yyyy').format(attendance.checkIn),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Duration: ${formatWorkedHours(attendance.workedHours)}',
                  ),
                  // if (attendance.lateType != null)
                  //   Text(
                  //     'Late: ${capitalizeFirstLetter(attendance.lateType!)}',
                  //   ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      statusIndicator(attendance: attendance),
                      const SizedBox(width: 20),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Morning Check-in '),
                          if (attendance.checkOutMorning != null)
                            const Text('Morning Check-out'),
                          if (attendance.checkInAfternoon != null)
                            const Text('Afternoon Check-in '),
                          if (attendance.checkOut != null)
                            const Text('Afternoon Check-Out'),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              ': ${DateFormat('HH:mm').format(attendance.checkIn)}'),
                          if (attendance.checkOutMorning != null)
                            Text(
                                ': ${DateFormat('HH:mm').format(attendance.checkOutMorning!)}'),
                          if (attendance.checkInAfternoon != null)
                            Text(
                                ': ${DateFormat('HH:mm').format(attendance.checkInAfternoon!)}'),
                          if (attendance.checkOut != null)
                            Text(
                                ': ${DateFormat('HH:mm').format(attendance.checkOut!)}'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (attendance.lateType != null)
            Positioned(
              top: 8.0,
              right: 15.0,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                decoration: const BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(4),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
                child: Text(
                  capitalizeFirstLetter(attendance.lateType!),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
