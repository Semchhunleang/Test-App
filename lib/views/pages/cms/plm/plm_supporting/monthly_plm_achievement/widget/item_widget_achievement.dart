import 'package:flutter/material.dart';
import 'package:umgkh_mobile/models/plm/plm_supporting/plm_achievement/plm_achievement.dart';
import 'package:umgkh_mobile/utils/navigator.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'package:umgkh_mobile/views/pages/cms/plm/plm_supporting/monthly_plm_achievement/form.dart';

class ItemPLMAchievementWidget extends StatelessWidget {
  final PLMAchievement data;
  const ItemPLMAchievementWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: () => navPush(context, MonthlyPLMAchievementFormPage(data: data)),
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
                  Text(data.job!.name,
                      style: titleStyle13.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700])),
                  heith5Space,
                  Text("${monthNumberToName(data.month)} • ${data.year}",
                      style: titleStyle13.copyWith(
                          color: Colors.grey[500], fontStyle: FontStyle.italic))
                ])),
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
