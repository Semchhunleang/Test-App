import 'package:flutter/material.dart';
import 'package:umgkh_mobile/models/service-project_task/workshop/timesheet_workshop.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/utils/utlis.dart';

class ItemTimeSheetWidget extends StatelessWidget {
  final TimesheetWorkshop data;
  const ItemTimeSheetWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) => Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(mainRadius),
        ),
        color: primaryColor.withOpacity(0.1),
        margin: EdgeInsets.symmetric(vertical: mainPadding / 2),
        child: Padding(
          padding: EdgeInsets.all(mainPadding * 1.2),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            item(
                title: 'Job Start',
                data: data.jobStartDt != null
                    ? formatReadableDT(data.jobStartDt!)
                    : "n/a"),
            item(
                title: 'Job Complete',
                data: data.jobCompleteDt != null
                    ? formatReadableDT(data.jobCompleteDt!)
                    : "n/a"),
            item(
                title: 'Total Time',
                data:
                    '${data.totalTimeHour ?? 0} hr ${data.totalTimeMinute ?? 0} min',
                noSize: true),
            item(title: 'Remark', data: data.remark.toString(), noSize: true),
          ]),
        ),
      );

  Widget item(
          {String title = '',
          required String? data,
          bool isSingle = false,
          bool noSize = false}) =>
      Padding(
        padding: EdgeInsets.only(bottom: noSize ? 0 : mainPadding / 2.5),
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          if (isSingle) ...[
            Expanded(
              flex: 4,
              child: Text(
                ifNullStr(data),
                textAlign: TextAlign.start,
                style: titleStyle13.copyWith(fontWeight: FontWeight.bold),
              ),
            )
          ] else ...[
            Expanded(
              flex: 4,
              child: Text(
                title,
                style: titleStyle12.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            widthSpace,
            Expanded(
              flex: 7,
              child: Text(ifNullStr(data),
                  style: titleStyle12,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
            )
          ]
        ]),
      );
}
