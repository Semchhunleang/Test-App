import 'package:flutter/material.dart';
import 'package:umgkh_mobile/models/hr/survey/survey_user_input.dart';
import 'package:umgkh_mobile/utils/static_state.dart';

Widget surveyStatusIndicator({required SurveyUserInput survey}) {
  IconData icon;
  Color color;
  String status;

  if (survey.state == draft || survey.state == newState) {
    icon = Icons.error; //
    color = const Color.fromARGB(255, 127, 135, 139);
    if (survey.state == newState) {
      status = 'New';
    } else {
      status = 'Draft';
    }
  } else if (survey.state == onProgress || survey.state == inProgress) {
    icon = Icons.error; //
    color = const Color.fromARGB(255, 236, 220, 70);
    if (survey.state == inProgress) {
      status = 'New';
    } else {
      status = 'To Approve';
    }
  } else  {
    icon = Icons.check_circle;
    color = const Color.fromARGB(255, 5, 180, 8);
    status = 'Done';
  }

  return Padding(
    padding: const EdgeInsets.all(5.0),
    child: Column(
      children: [
        Icon(icon, color: color),
        Text(
          status,
          style: TextStyle(color: color),
        ),
      ],
    ),
  );
}
