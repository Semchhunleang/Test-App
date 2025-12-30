import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:umgkh_mobile/models/hr/leave/leave.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import '../../approve_leave/widget/widget_text_value.dart';

void showLeaveDetailsDialog(
    BuildContext context, Leave leave, String state) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: mainPadding * 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: EdgeInsets.fromLTRB(
                        mainPadding, mainPadding, mainPadding, mainPadding / 2),
                    child:
                        Text('Leave Details', style: primary15Bold),),
                const Divider(),

                // text
                heith5Space,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WidgetTextValue(
                      title: 'Type: ',
                      value:  leave.leaveType.name,
                    ),
                    heithSpace,
                    WidgetTextValue(
                      title: 'State: ',
                      value: stateTitleLeave(state),
                      fontWeight: FontWeight.w800,
                      valueColor: stateColor(state),
                    ),
                    heithSpace,
                    WidgetTextValue(
                      title: 'Date: ',
                      value:  '${DateFormat('d MMM yyyy').format(leave.requestDateFrom)} - ${DateFormat('d MMM yyyy').format(leave.requestDateTo)}',
                    ),
                    heithSpace,
                    WidgetTextValue(
                      title: 'Duration: ',
                      value:  '${leave.numberOfDays} Day',
                    ),
                  ],
                ),
                heith10Space,
                const Divider(),
                heith10Space,
                Text(leave.description, style: titleStyle13),
                // if (state != 'submit')
                Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('Close',
                            style: primary12Bold.copyWith(color: redColor),),),),
              ],
            ),
          ),
        ),
      );
    },
  );
}
