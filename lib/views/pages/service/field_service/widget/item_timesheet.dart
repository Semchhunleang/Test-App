import 'package:flutter/material.dart';
import 'package:umgkh_mobile/models/service-project_task/timesheet_project_task/timesheet_project_task.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/utils/utlis.dart';

class ItemTimeSheetWidget extends StatelessWidget {
  final TimesheetProjectTask data;
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
            item(data: 'Trip ${data.trip}', isSingle: true),
            item(
                title: 'Fleet',
                data: data.fleetVehicle != null
                    ? data.fleetVehicle!.name
                    : "n/a"),
            item(
              title: 'Odometer Start',
              data: data.odometerStart.toString(),
            ),
            item(
              title: 'Odometer End',
              data: data.odometerEnd.toString(),
            ),
            item(
              title: 'Total Mileage',
              data: data.totalMileage.toString(),
            ),
            item(
                title: 'Dispatch From',
                data: data.dispatchFrom != null
                    ? titleDispatchFrom(data.dispatchFrom)
                    : "n/a"),
            item(
                title: 'Dispatch',
                data: data.dispatchDt != null
                    ? formatReadableDT(data.dispatchDt!)
                    : "n/a"),
            item(
                title: 'Arrive at Site',
                data: data.arrivalAtSiteDt != null
                    ? formatReadableDT(data.arrivalAtSiteDt!)
                    : "n/a"),
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
                title: 'Leave from Site',
                data: data.leaveFromSiteDt != null
                    ? formatReadableDT(data.leaveFromSiteDt!)
                    : "n/a"),
            item(
                title: 'Arrive at Office',
                data: data.arriveAtOfficeDt != null
                    ? formatReadableDT(data.arriveAtOfficeDt!)
                    : "n/a"),
            item(
                title: 'Arrive At',
                data: data.arriveAt != null
                    ? titleDispatchFrom(data.arriveAt)
                    : "n/a"),
            item(
                title: 'Total Time',
                data:
                    '${data.totalTimeHour ?? 0} hr ${data.totalTimeMinute ?? 0} min',
                noSize: true),
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
