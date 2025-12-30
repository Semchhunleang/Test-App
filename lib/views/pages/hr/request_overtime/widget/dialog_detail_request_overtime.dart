import 'package:flutter/material.dart';
import 'package:umgkh_mobile/models/hr/request_overtime/request_overtime.dart';
import '../../../../../utils/theme.dart';
import '../../../../../utils/utlis.dart';
import 'widget_text_value.dart';

void showRequestOvertimeDetailsDialog(
    BuildContext context, RequestOvertime requestOvertimeList, String state) {
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
                        Text('Request Overtime Details', style: primary15Bold),),
                const Divider(),

                // text
                heith5Space,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WidgetTextValue(
                      title: 'State: ',
                      value: stateTitleOvertime(state),
                      fontWeight: FontWeight.w800,
                      valueColor: stateColor(state),
                    ),
                    heithSpace,
                    WidgetTextValue(
                      title: 'Overtime Date: ',
                      value: requestOvertimeList.overtimeDate != null
                          ? formatDDMMMMYYYY(requestOvertimeList.overtimeDate!)
                          : "N/A",
                    ),
                    heithSpace,
                    WidgetTextValue(
                      title: 'Name: ',
                      value: requestOvertimeList.employee!.name,
                    ),
                    heithSpace,
                    WidgetTextValue(
                      title: 'Department: ',
                      value: requestOvertimeList.employee!.department!.name,
                    ),
                    heithSpace,
                    WidgetTextValue(
                      title: 'Manager: ',
                      value: requestOvertimeList.employee!.manager!.name,
                    ),
                    heithSpace,
                    WidgetTextValue(
                      title: 'Request: ',
                      value:
                          "${requestOvertimeList.overtimeHours} hours ${requestOvertimeList.overtimeMinutes} Minute",
                    ),
                    heithSpace,
                    WidgetTextValue(
                      title: 'Approved: ',
                      value:
                          "${requestOvertimeList.dhOvertimeHours} hours ${requestOvertimeList.dhOvertimeMinutes} Minute",
                    ),
                    heithSpace,
                    WidgetTextValue(
                      title: 'Approve DH Date: ',
                      value: requestOvertimeList.approveDhDatetime != null
                          ? formatDDMMMMYYYY(
                              requestOvertimeList.approveDhDatetime!)
                          : "N/A",
                    ),
                    heithSpace,
                    WidgetTextValue(
                      title: 'Reject Date: ',
                      value: requestOvertimeList.rejectDatetime != null
                          ? formatDDMMMMYYYY(
                              requestOvertimeList.rejectDatetime!)
                          : "N/A",
                    ),
                  ],
                ),
                heith10Space,
                const Divider(),
                heith10Space,
                Text(requestOvertimeList.reason ?? "", style: titleStyle13),
                Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('Close',
                            style: primary12Bold.copyWith(color: redColor),),),),
                heith5Space
              ],
            ),
          ),
        ),
      );
    },
  );
}
