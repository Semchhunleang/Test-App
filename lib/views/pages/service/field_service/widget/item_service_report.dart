import 'package:flutter/material.dart';
import 'package:umgkh_mobile/models/service-project_task/service_report/service_report.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'package:umgkh_mobile/views/pages/service/field_service/widget/utils_widget.dart';

class ItemServiceReportWidget extends StatelessWidget {
  final ServiceReport data;
  const ItemServiceReportWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) => Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(mainRadius),),
      color: primaryColor.withOpacity(0.1),
      margin: EdgeInsets.symmetric(vertical: mainPadding / 2),
      child: Padding(
          padding: EdgeInsets.all(mainPadding * 1.2),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            item(title: 'Date', data: formatDDMMMMYYYY(data.date!),),
            item(title: 'Problem', data: data.problem),
            item(title: 'Root Cause', data: data.rootCause),
            item(title: 'Action', data: data.action, noSize: true, maxline: 5),
            if (data.attachments.isNotEmpty) ...[
              heith10Space,
              imageFieldServies(context, data.attachments)
            ],
            if (data.images != null && data.images!.isNotEmpty) ...[
              heith10Space,
              imageFieldServiesLocal(context, data.images!)
            ]
          ]),),);

  Widget item(
          {required String title,
          required String? data,
          int maxline = 2,
          bool noSize = false}) =>
      Padding(
          padding: EdgeInsets.only(bottom: noSize ? 0 : mainPadding / 2.5),
          child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Expanded(
                flex: 1,
                child: Text(title,
                    style: titleStyle12.copyWith(fontWeight: FontWeight.bold),),),
            Expanded(
                flex: 3,
                child: Text(ifNullStr(data),
                    style: titleStyle12,
                    maxLines: maxline,
                    overflow: TextOverflow.ellipsis),)
          ]),);
}
