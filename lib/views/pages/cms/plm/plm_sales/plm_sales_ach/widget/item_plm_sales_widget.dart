import 'package:flutter/material.dart';
import 'package:umgkh_mobile/models/plm/plm_sales/plm_sales.dart';
import 'package:umgkh_mobile/utils/navigator.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/views/pages/cms/plm/plm_sales/plm_sales_ach/form.dart';

class ItemPLMSalesWidget extends StatelessWidget {
  final PLMSales data;
  const ItemPLMSalesWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: () => navPush(context, PLMSalesFormInfoPage(data: data)),
      child: Container(
          decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              // border: Border(left: BorderSide(color: primaryColor, width: 5)),
              borderRadius: BorderRadius.circular(mainRadius / 2)),
          padding: EdgeInsets.all(mainPadding),
          margin: EdgeInsets.only(bottom: mainPadding),
          child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(data.sales.name.toUpperCase(),
                      style: primary15Bold.copyWith(letterSpacing: 1.5)),
                  heith5Space,
                  Text(data.sales.jobTitle,
                      style: titleStyle13.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700])),
                  heith5Space,
                  Text("${data.month} • ${data.year}",
                      style: titleStyle13.copyWith(
                          color: Colors.grey[500], fontStyle: FontStyle.italic))
                ])),

            // SCORE
            buildScorePLM(data.score)
          ])));
}

Widget buildScorePLM(double score) => Container(
    decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(mainRadius),
        border: Border.all(color: primaryColor.withOpacity(0.3))),
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(Icons.leaderboard, color: primaryColor, size: 15),
      const SizedBox(width: 3),
      Text.rich(TextSpan(
          text: 'Score: ',
          style: hintStyle.copyWith(color: Colors.grey[700]),
          children: [
            TextSpan(text: score.toStringAsFixed(2), style: primary12Bold)
          ]))
    ]));
