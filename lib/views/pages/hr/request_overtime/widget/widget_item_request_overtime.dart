import 'package:flutter/material.dart';
import 'package:umgkh_mobile/models/hr/request_overtime/request_overtime.dart';
import 'package:umgkh_mobile/utils/navigator.dart';
import 'package:umgkh_mobile/views/pages/hr/request_overtime/form.dart';
import 'package:umgkh_mobile/widgets/button_custom.dart';
import '../../../../../utils/theme.dart';
import '../../../../../utils/utlis.dart';

class WidgetItemRequestOvertime extends StatelessWidget {
  final RequestOvertime requestOvertimeList;
  const WidgetItemRequestOvertime(
      {super.key, required this.requestOvertimeList});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () async {
          // showRequestOvertimeDetailsDialog(
          //     context, requestOvertimeList, requestOvertimeList.state!);
          await navPush(context,
              CreateRequestOvertimePage(overtime: requestOvertimeList));
        },
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(mainRadius),
          ),
          color: primaryColor.withOpacity(0.1),
          margin: EdgeInsets.symmetric(vertical: mainPadding / 2),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: mainPadding * 1.5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                heith10Space,

                /// button
                SizedBox(
                  width: double.infinity,
                  height: 25,
                  child: StatusCustom(
                    textsize: 11,
                    text: stateTitleOvertime(requestOvertimeList.state),
                    color: stateColor(requestOvertimeList.state),
                  ),
                ),
                heith5Space,

                /// data info
                Text(formatDDMMMMYYYY(requestOvertimeList.overtimeDate!),
                    style: titleStyle12),
                Text(requestOvertimeList.employee!.name, style: primary12Bold),
                Text(requestOvertimeList.employee!.department!.name,
                    style: titleStyle12),
                Text(
                    'Request: ${requestOvertimeList.overtimeHours} hours ${requestOvertimeList.overtimeMinutes} Minute',
                    style: titleStyle12),
                Text(
                    'Approved: ${requestOvertimeList.dhOvertimeHours} hours ${requestOvertimeList.dhOvertimeMinutes} Minute',
                    style: titleStyle12),
                if (requestOvertimeList.createBy != null) ...[
                  Text('Create By: ${requestOvertimeList.createBy}',
                      style: titleStyle12)
                ],
                heithSpace,
                if (requestOvertimeList.reason != null) ...[
                  Text(requestOvertimeList.reason!.replaceAll('\n', ''),
                      style: titleStyle12,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis)
                ],
                heith10Space
              ],
            ),
          ),
        ),
      );
}
