import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'package:umgkh_mobile/view_models/survey_view_model.dart';
import 'package:umgkh_mobile/view_models/profile_view_model.dart';
import 'package:umgkh_mobile/views/pages/hr/survey/widget/survey_card.dart';
import 'package:umgkh_mobile/views/pages/hr/survey/widget/top_card_take_leave.dart';
import 'package:umgkh_mobile/widgets/custom_scaffold.dart';
import 'package:umgkh_mobile/widgets/list_condition.dart';

class SurveyPage extends StatefulWidget {
  static const routeName = '/survey';
  static const pageName = 'Survey';
  const SurveyPage({Key? key}) : super(key: key);

  @override
  State<SurveyPage> createState() => SurveyPageState();
}

class SurveyPageState extends State<SurveyPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _resetDate();
      _fetchData();
    });
  }

  Future<void> _resetDate() async {
    await Provider.of<SurveyViewModel>(context, listen: false).resetData();
  }

  Future<void> _fetchData() async {
    if (mounted) {
      await Provider.of<SurveyViewModel>(context, listen: false)
          .fetchSurveys();
    }

    if (mounted) {
      await Provider.of<ProfileViewModel>(context, listen: false)
          .fetchUserData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        title: SurveyPage.pageName,
        body: Consumer<SurveyViewModel>(
          builder: (context, viewModel, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TopCardSurvey(),
                Divider(
                  color: theme().primaryColor,
                ),
                ListCondition(
                  viewModel: viewModel,
                  showedData: viewModel.filteredSurveyUserInputs,
                  onRefresh: _fetchData,
                  child: ListView.builder(
                    physics: kBounce,
                    padding: EdgeInsets.only(
                        left: mainPadding / 3,
                        right: mainPadding / 3,
                        bottom: mainPadding * 6),
                    itemCount: viewModel.filteredSurveyUserInputs.length,
                    itemBuilder: (context, index) {
                      final survey = viewModel.filteredSurveyUserInputs[index];
                      return surveyCard(context: context, survey: survey);
                    },
                  ),
                ),
              ],
            );
          },
        ),
        );
  }
}
