import 'package:flutter/material.dart';
import 'package:umgkh_mobile/models/plm/plm_sales/monthly_plm.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/views/pages/cms/plm/plm_sales/plm_sales_ach/widget/widget_table.dart';

Widget buildTableMonthlyPLM(BuildContext context, List<MonthlyPLM> data) =>
    Column(children: [
      // HEAD
      cardHeadTabBar(widget: [
        textTitleHeadTabBar('Activity'),
        textTitleHeadTabBar('Target'),
        textTitleHeadTabBar('Ach'),
        textTitleHeadTabBar('Result'),
        textTitleHeadTabBar('State'),
      ]),

      // ITEM
      ...data
          .map((e) => InkWell(
              splashColor: primaryColor.withOpacity(0.1),
              highlightColor: primaryColor.withOpacity(0.1),
              onTap: null,
              child: cardItemTabBarView(widget: [
                textItemTabBarView(e.activity),
                textItemTabBarView(e.target.toString()),
                textItemTabBarView(e.achievement.toStringAsFixed(2)),
                textItemTabBarView(e.result.toStringAsFixed(2)),
                textItemTabBarView(e.state),
              ])))
          .toList()
    ]);
