import 'package:flutter/material.dart';
import 'package:umgkh_mobile/models/plm/plm_supporting/plm_target/plm_supporting.dart';
import 'package:umgkh_mobile/utils/navigator.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/views/pages/cms/plm/plm_supporting/monthly_plm_target/form.dart';

class ItemPLMTargetWidget extends StatelessWidget {
  final PLMTarget data;
  const ItemPLMTargetWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: () => navPush(context, MonthlyPLMTargetFormPage(data: data)),
      child: Container(
          decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(mainRadius / 2)),
          padding: EdgeInsets.all(mainPadding),
          margin: EdgeInsets.only(bottom: mainPadding),
          child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(data.employee.name.toUpperCase(),
                      style: primary15Bold.copyWith(letterSpacing: 1.5)),
                  heith5Space,
                  Text(data.employee.jobTitle,
                      style: titleStyle13.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700])),
                  heith5Space,
                  Text("${data.month} • ${data.year}",
                      style: titleStyle13.copyWith(
                          color: Colors.grey[500], fontStyle: FontStyle.italic))
                ])),
          ])));
}
