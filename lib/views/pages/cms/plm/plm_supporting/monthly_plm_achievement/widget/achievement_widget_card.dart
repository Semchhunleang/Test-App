import 'package:flutter/material.dart';
import 'package:umgkh_mobile/utils/navigator.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/views/pages/cms/plm/plm_supporting/monthly_plm_achievement/detail_form.dart';
import 'package:umgkh_mobile/views/pages/cms/plm/plm_supporting/monthly_plm_achievement/detail_form_monthly.dart';

Widget achievementWidgetCard(
    BuildContext context, String mainTitle, List<dynamic> lines,
    {bool noRadiusValue = false,
    bool noRadiusHeadTile = false,
    bool isMonthly = false,
    bool isWeekly = false}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.vertical(
              top: noRadiusHeadTile
                  ? const Radius.circular(0)
                  : const Radius.circular(10)),
        ),
        child: Text(
          mainTitle,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          decoration: BoxDecoration(
            // color: Colors.red,
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
                bottom: noRadiusValue
                    ? const Radius.circular(0)
                    : const Radius.circular(10)),
          ),
          child: Column(
            children: List.generate(lines.length, (index) {
              final line = lines[index];
              return Column(
                children: [
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        isMonthly
                            ? navPush(
                                context,
                                DetailFormMonthly(
                                  activity: line.activity.activityName,
                                  monthlyLines: line,
                                ))
                            : navPush(
                                context,
                                DetailForm(
                                  activity: line.activity.activityName,
                                  data: line.detail,
                                  score: line.score,
                                  isWeekly: isWeekly,
                                ));
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                line.activity.activityName,
                                style: primary14Bold,
                              ),
                            ),
                            Text(
                              "${line.score}",
                              style: titleStyle14,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (index != lines.length - 1)
                    Divider(color: primaryColor, height: 15),
                ],
              );
            }),
          )),
    ],
  );
}
