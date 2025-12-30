import 'package:flutter/material.dart';
import 'package:umgkh_mobile/models/hr/overtime/overtime.dart';
import 'package:umgkh_mobile/utils/navigator.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'package:umgkh_mobile/views/pages/hr/overtime/form.dart';
import 'package:umgkh_mobile/widgets/button_custom.dart';

class OvertimeItem extends StatelessWidget {
  final Overtime data;
  const OvertimeItem({super.key, required this.data});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () =>
            navPush(context, CreateEmployeeOvertimePage(overtime: data)),
        // onTap: () => showInfoDialog(context, data),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(mainRadius),
          ),
          color: primaryColor.withOpacity(0.1),
          margin: EdgeInsets.symmetric(vertical: mainPadding / 2),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: mainPadding * 1.5),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              heith10Space,
              SizedBox(
                width: double.infinity,
                height: 25,
                child: StatusCustom(
                  textsize: 11,
                  text: stateTitleOvertime(data.state),
                  color: stateColor(data.state),
                ),
              ),
              heith5Space,

              /// data info
              Text(formatDDMMMMYYYY(data.overtimeDate), style: titleStyle12),
              Text(data.employee?.name ?? nullStr, style: primary12Bold),
              Text(data.employee?.department?.name ?? nullStr,
                  style: titleStyle12),
              Text(
                  'Request: ${data.overtimeHours} hours ${data.overtimeMinutes} mins',
                  style: titleStyle12),
              Text(
                  'Approved: ${data.approvedOvertimeHours} hours ${data.approvedOvertimeMinutes} mins',
                  style: titleStyle12),
              if (data.createBy.isNotEmpty) ...[
                Text('Create By: ${data.createBy}', style: titleStyle12)
              ],
              heith10Space,
              if (data.reason != null) ...[
                Text(data.reason!.replaceAll('\n', ''),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: titleStyle12)
              ],
              heith10Space
            ]),
          ),
        ),
      );
}
