import 'package:flutter/material.dart';
import 'package:umgkh_mobile/models/service-project_task/job_analytic/job_analytic.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/utils/utlis.dart';

class ItemJobAnalyticWidget extends StatelessWidget {
  final JobAnalytic data;
  const ItemJobAnalyticWidget({super.key, required this.data});

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
              title: 'Action Date',
              data: formatReadableDT(data.actionDate!),
            ),
            item(
              title: 'Component',
              data: ifNullModel(
                data.system,
                (p) => ifNullStr(p.name),
              ),
            ),
            item(
              title: 'Phenomenon',
              data: ifNullModel(
                data.phenomenon,
                (p) => ifNullStr(p.name),
              ),
            ),
            item(
              title: 'Action',
              data: ifNullModel(
                data.action,
                (p) => ifNullStr(p.name),
              ),
            ),
            item(
              title: 'Action By',
              data: ifNullModel(
                data.actionBy,
                (p) => ifNullStr(p.name),
              ),
            ),
            item(title: 'Service Job Point', data: data.serviceJobPoint),
            item(title: 'Note', data: data.note, noSize: true, maxline: 10)
          ]),
        ),
      );

  Widget item(
          {required String title,
          required String? data,
          int maxline = 2,
          bool noSize = false}) =>
      Padding(
        padding: EdgeInsets.only(bottom: noSize ? 0 : mainPadding / 2.5),
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Expanded(
            child: Text(
              title,
              style: titleStyle12.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(ifNullStr(data),
                style: titleStyle12,
                maxLines: maxline,
                overflow: TextOverflow.ellipsis),
          )
        ]),
      );
}
