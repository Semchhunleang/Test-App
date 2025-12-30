import 'package:flutter/material.dart';
import 'package:umgkh_mobile/models/hr/survey/survey_user_input.dart';
import 'package:umgkh_mobile/utils/navigator.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'package:umgkh_mobile/views/pages/hr/survey/form.dart';
import 'package:umgkh_mobile/views/pages/hr/survey/widget/survey_status_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

Widget surveyCard(
    {required BuildContext context, required SurveyUserInput survey}) {
  return GestureDetector(
    onTap: () async {
      if (survey.link != null &&
          survey.link!.isNotEmpty &&
          (survey.state == 'new' || survey.state == 'in_progress')) {
        await launchUrl(Uri.parse(survey.link!));
      } else {
        if (context.mounted) navPush(context, SurveyFromPage(survey: survey));
      }
      //showLeaveDetailsDialog(context, survey, survey.state);
    },
    child: Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.all(5),
            width: MediaQuery.of(context).size.width / 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                surveyStatusIndicator(survey: survey),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              survey.survey.title,
                              style: const TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.bold),
                            )
                          ]),
                    ),
                  ],
                ),
                Text(
                  survey.employeeName != null ? survey.employeeName! : '',
                ),
                const Divider(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      survey.deadline == null
                          ? formatDMMMMYYYY(survey.createDate)
                          : '${formatDMMMMYYYY(survey.createDate)} - ${formatDMMMMYYYY(DateTime.parse(survey.deadline!))}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
