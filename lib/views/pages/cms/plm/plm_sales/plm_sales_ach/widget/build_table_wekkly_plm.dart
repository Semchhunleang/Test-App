import 'package:flutter/material.dart';
import 'package:umgkh_mobile/models/plm/plm_sales/weekly_plm.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/views/pages/cms/plm/plm_sales/plm_sales_ach/widget/widget_table.dart';

Widget buildTableWeeklyPLM(BuildContext context, List<WeeklyPLM> data) =>
    Column(children: [
      // HEAD
      cardHeadTabBar(widget: [
        textTitleHeadTabBar('Activity'),
        textTitleHeadTabBar('Result'),
        textTitleHeadTabBar('Weekly Line'),
      ]),

      // ITEM
      ...data
          .map((e) => InkWell(
              splashColor: primaryColor.withOpacity(0.1),
              highlightColor: primaryColor.withOpacity(0.1),
              onTap: () => showInfoPLMBottomSheet(context,
                  activity: e.activity,
                  result: e.result.toString(),
                  data: e.details,
                  isWeekly: true),
              child: cardItemTabBarView(widget: [
                textItemTabBarView(e.activity),
                textItemTabBarView(e.result.toStringAsFixed(2)),
                textItemTabBarView('${e.record} records'),
              ])))
          .toList()
    ]);
