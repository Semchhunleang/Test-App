import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:umgkh_mobile/models/hr/leave/leave.dart';
import 'package:umgkh_mobile/utils/navigator.dart';
import 'package:umgkh_mobile/views/pages/hr/take_leave/form.dart';
import 'package:umgkh_mobile/views/pages/hr/take_leave/widget/leave_status_indicator.dart';

Widget leaveCard({required BuildContext context, required Leave leave}) {
  return GestureDetector(
    onTap: () async {
      //showLeaveDetailsDialog(context, leave, leave.state);
      navPush(context, TakeLeaveFormPage(leave: leave));
    },
    child: Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.all(5),
            width: MediaQuery.of(context).size.width / 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  leave.leaveType.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                leaveStatusIndicator(leave: leave),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${leave.numberOfDays} Day',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          leave.requestUnitHalf
                              ? Text(
                                  '${DateFormat('d MMM yyyy').format(leave.requestDateFrom)} ${leave.requestDateFromPeriod != null && leave.requestDateFromPeriod == "am" ? "Morning" : "Afternoon"}',
                                  style: const TextStyle(fontSize: 13),
                                )
                              : Text(
                                  '${DateFormat('d MMM yyyy').format(leave.requestDateFrom)} - ${DateFormat('d MMM yyyy').format(leave.requestDateTo)}',
                                  style: const TextStyle(fontSize: 13),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(),
                Text(
                  leave.description,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
