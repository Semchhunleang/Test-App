import 'package:flutter/material.dart';
import 'package:umgkh_mobile/models/hr/overtime/overtime.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/utils/utlis.dart';

Future<void> showInfoDialog(BuildContext context, Overtime data) => showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) => Dialog(
        child: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: mainPadding * 2),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: EdgeInsets.fromLTRB(mainPadding, mainPadding,
                              mainPadding, mainPadding / 2),
                          child:
                              Text('Overtime Details', style: primary15Bold),),
                      const Divider(),

                      // text
                      heith5Space,
                      Text(stateTitleOvertime(data.state),
                          style: primary13Bold.copyWith(
                              color: stateColor(data.state),),),
                      Text(formatDDMMMMYYYY(data.overtimeDate),
                          style: titleStyle12),
                      Text(data.employee?.name ?? nullStr,
                          style: primary12Bold),
                      Text(data.employee?.department?.name ?? nullStr,
                          style: titleStyle12),
                      Text('Day: ${data.dayname ?? nullStr}',
                          style: titleStyle12),
                      Text(
                          'First 30 mins: ${data.isFirst30Min == true ? 'Counted' : 'Not Counted'}',
                          style: titleStyle12),
                      Text('Distance: ${data.distance} km',
                          style: titleStyle12),
                      Text(
                          'Worked duration: ${data.overtimeHours}:${data.overtimeMinutes}',
                          style: titleStyle12),
                      Text(
                          'Approved duration: ${data.approvedOvertimeHours}:${data.approvedOvertimeMinutes}',
                          style: titleStyle12),
                      Text.rich(TextSpan(
                          text: 'Amount: ',
                          style: titleStyle12,
                          children: [
                            TextSpan(
                                text:
                                    '\$ ${formatDecimal(data.amountOvertime)}',
                                style: primary12Bold)
                          ]),),
                      heith10Space,
                      const Divider(),
                      heith10Space,
                      Text(data.reason ?? nullStr, style: titleStyle12),
                      Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text('Close',
                                  style: primary12Bold.copyWith(
                                      color: redColor),),),),
                      heith5Space
                    ]),),),));
