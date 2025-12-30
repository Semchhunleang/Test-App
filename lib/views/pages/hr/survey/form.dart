import 'package:flutter/material.dart';
import 'package:umgkh_mobile/models/hr/survey/survey_user_input.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'package:umgkh_mobile/views/pages/hr/survey/widget/build_table_widget.dart';
import 'package:umgkh_mobile/widgets/custom_scaffold.dart';

class SurveyFromPage extends StatefulWidget {
  final SurveyUserInput survey;
  static const routeName = '/survey-form';
  static const pageName = 'Survey Form';
  const SurveyFromPage({super.key, required this.survey});

  @override
  State<SurveyFromPage> createState() => _SurveyFromPageState();
}

class _SurveyFromPageState extends State<SurveyFromPage> {
  @override
  Widget build(BuildContext context) => CustomScaffold(
      title: widget.survey.survey.title,
      body: ListView(
        physics: kBounce,
        children: [
          Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              color: primaryColor.withOpacity(0.1),
              margin: EdgeInsets.all(mainPadding / 2),
              child: Padding(
                  padding: EdgeInsets.all(mainPadding),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _item(
                          title: 'Created On',
                          data: formatDDMMMMYYYY(widget.survey.createDate)),
                      heith10Space,
                      if (widget.survey.employeeName != null) ...[
                        _item(
                            title: 'Employee',
                            data: widget.survey.employeeName ?? '-')
                      ],
                      heithSpace,
                      heith10Space,

                      //  BUILD TABLE
                      BuildSurveyFormTableWidget(
                          data: widget.survey.feedbackLines)
                    ],
                  ))),
        ],
      ));

  Widget _item({required String title, required String data}) =>
      Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        // TITLE
        width5Space,
        Expanded(
            child:
                Text(title, style: primary15Bold.copyWith(color: blackColor))),
        // DATA
        Expanded(
            flex: 2,
            child: Text(
              data,
              style: primary15Bold.copyWith(color: Colors.black54),
            ))
      ]);
}
