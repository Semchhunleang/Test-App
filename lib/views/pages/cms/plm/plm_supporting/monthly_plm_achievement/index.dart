import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/view_models/access_levels_view_model.dart';
import 'package:umgkh_mobile/view_models/plm/plm_supporting/monthly_plm_achievement_view_model.dart';
import 'package:umgkh_mobile/view_models/profile_view_model.dart';
import 'package:umgkh_mobile/view_models/selections_view_model.dart';
import 'package:umgkh_mobile/views/pages/cms/plm/plm_supporting/monthly_plm_achievement/widget/item_widget_achievement.dart';
import 'package:umgkh_mobile/views/pages/cms/plm/plm_supporting/monthly_plm_achievement/widget/utils_widget_achievement.dart';
import 'package:umgkh_mobile/widgets/custom_scaffold.dart';
import 'package:umgkh_mobile/widgets/list_condition.dart';

class MonthlyPLMAchievementPage extends StatefulWidget {
  static const routeName = '/monthly-plm-achievement';
  static const pageName = 'Monthly PLM Achievement';
  const MonthlyPLMAchievementPage({super.key});

  @override
  State<MonthlyPLMAchievementPage> createState() =>
      _MonthlyPLMAchievementState();
}

class _MonthlyPLMAchievementState extends State<MonthlyPLMAchievementPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final providerUser =
          Provider.of<ProfileViewModel>(context, listen: false);
      final selectionsProvider =
          Provider.of<SelectionsViewModel>(context, listen: false);
      final vm =
          Provider.of<MonthlyPlmAchievementViewModel>(context, listen: false);

      selectionsProvider.fetchAllEmployee();
      final accessLevel = context.read<AccessLevelViewModel>().accessLevel;

      vm.setDefaultEmployee(
        providerUser.user,
        isDh: accessLevel.isDh == 1,
      );
      vm.onClearFilter(
        providerUser.user,
        isDh: accessLevel.isDh == 1,
      );
      vm.fetchMonthlyPLMAchievement();
    });
  }

  @override
  Widget build(BuildContext context) =>
      Consumer<MonthlyPlmAchievementViewModel>(
          builder: (context, viewModel, _) => CustomScaffold(
              title: MonthlyPLMAchievementPage.pageName,
              body: Column(
                children: [
                  Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      color: primaryColor.withOpacity(0.1),
                      margin: EdgeInsets.symmetric(
                          horizontal: mainPadding, vertical: mainPadding / 2),
                      child: Padding(
                          padding: EdgeInsets.all(mainPadding),
                          child: Column(
                            children: [
                              selectEmployees(
                                  selected: viewModel.selectEmployee,
                                  departmentId: viewModel.departmentId,
                                  onChanged: viewModel.onChangeEmployee),
                              const SizedBox(
                                height: 15.0,
                              ),
                              Row(children: [
                                filterSelectYear(
                                  selected: viewModel.selectedYear,
                                  onValue: (v) =>
                                      viewModel.onChangedYear(context, v),
                                ),
                                width10Space,
                                filterSelectMonth(
                                  selected: viewModel.selectedMonth,
                                  onValue: (v) =>
                                      viewModel.onChangedMonth(context, v),
                                )
                              ]),
                            ],
                          ))),
                  ListCondition(
                      viewModel: viewModel,
                      showedData: viewModel.showedAchievementData,
                      onRefresh: () => viewModel.fetchMonthlyPLMAchievement(),
                      child: ListView.builder(
                          padding: EdgeInsets.symmetric(
                              horizontal: mainPadding,
                              vertical: mainPadding / 2),
                          itemCount: viewModel.showedAchievementData.length,
                          itemBuilder: (context, i) => ItemPLMAchievementWidget(
                              data: viewModel.showedAchievementData[i])))
                ],
              )));
}
