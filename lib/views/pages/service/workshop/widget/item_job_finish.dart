import 'package:flutter/material.dart';
import 'package:umgkh_mobile/models/service-project_task/job_finish/job_finish.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'package:umgkh_mobile/views/pages/service/field_service/widget/utils_widget.dart';

class ItemJobFinishWidget extends StatelessWidget {
  final JobFinish data;
  const ItemJobFinishWidget({super.key, required this.data});

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              item(
                title: 'Datetime Finish',
                data: formatReadableDT(data.finishDatetime!),
              ),
              item(title: 'Customer Satified', data: data.customerSatisfied),
              item(title: 'Customer Comment', data: data.customerComment),
              item(
                  title: 'Servie Recommendation',
                  data: data.serviceRecommendation),
              item(title: 'Customer Name', data: data.customerName),
              item(title: 'Phone', data: data.phone),
              if (data.sign != 0)
                item(
                    title: 'Sign',
                    data: null,
                    noSize: true,
                    img: true,
                    id: data.sign),
              heithSpace,
              if (data.mechanicSign != 0)
                item(
                    title: 'Mechanic Sign',
                    data: null,
                    noSize: true,
                    img: true,
                    id: data.mechanicSign)
            ],
          ),
        ),
      );

  Widget item(
          {required String title,
          required String? data,
          bool img = false,
          int id = 0,
          bool noSize = false}) =>
      Padding(
        padding: EdgeInsets.only(bottom: noSize ? 0 : mainPadding / 2.5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                title,
                style: titleStyle12.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: img
                  ? Align(
                      alignment: Alignment.centerLeft,
                      child: widgetImg(id, onTap: () {}),
                    )
                  : Text(ifNullStr(data),
                      style: titleStyle12,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
            )
          ],
        ),
      );
}
