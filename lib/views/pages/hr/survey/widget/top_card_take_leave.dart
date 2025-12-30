import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/view_models/survey_view_model.dart';
import 'package:umgkh_mobile/views/pages/hr/survey/widget/survey_filter.dart';

class TopCardSurvey extends StatefulWidget {
  const TopCardSurvey({Key? key}) : super(key: key);

  @override
  State<TopCardSurvey> createState() => _TopCardSurveyState();
  
}

class _TopCardSurveyState extends State<TopCardSurvey> {

  @override
  Widget build(BuildContext context) {
    return Consumer<SurveyViewModel>(
      builder: (context, viewModel, child) {
        return const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SurveyFilter(),
          ],
        );
      },
    );
  }
}
