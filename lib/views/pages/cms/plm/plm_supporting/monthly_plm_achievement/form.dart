import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/models/plm/plm_supporting/plm_achievement/plm_achievement.dart';
import 'package:umgkh_mobile/utils/odoo_model.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/view_models/log_note_form_view_model.dart';
import 'package:umgkh_mobile/view_models/log_note_view_model.dart';
import 'package:umgkh_mobile/view_models/plm/plm_supporting/monthly_plm_achievement_form_view_model.dart';
import 'package:umgkh_mobile/view_models/selections_view_model.dart';
import 'package:umgkh_mobile/views/pages/cms/plm/plm_supporting/monthly_plm_achievement/widget/achievement_widget_card.dart';
import 'package:umgkh_mobile/views/pages/log_note/widget_comment_log_note.dart';
import 'package:umgkh_mobile/widgets/custom_drop_list.dart';
import 'package:umgkh_mobile/widgets/custom_scaffold.dart';
import 'package:umgkh_mobile/widgets/textfield.dart';

class MonthlyPLMAchievementFormPage extends StatefulWidget {
  final PLMAchievement data;
  static const routeName = '/monthly-plm-achievement-info';
  static const pageName = 'Monthly PLM Achievement';
  const MonthlyPLMAchievementFormPage({super.key, required this.data});

  @override
  State<MonthlyPLMAchievementFormPage> createState() =>
      _MonthlyPLMAchievementFormPageState();
}

class _MonthlyPLMAchievementFormPageState
    extends State<MonthlyPLMAchievementFormPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = Provider.of<MonthlyPlmAchievementFormViewModel>(context,
          listen: false);
      vm.setDefaultData(widget.data);
      fetchLogNote();
    });
  }

  Future<void> fetchLogNote() async {
    final vmLN = Provider.of<LogNoteViewModel>(context, listen: false);
    final vmLNF = Provider.of<LogNoteFormViewModel>(context, listen: false);
    vmLN.fetchData(widget.data.id, monthlyPLMEmployeeAchievement);
    vmLNF.resetForm();
  }

  @override
  Widget build(BuildContext context) =>
      Consumer<MonthlyPlmAchievementFormViewModel>(
          builder: (context, viewModel, _) => CustomScaffold(
              title: MonthlyPLMAchievementFormPage.pageName,
              body: SingleChildScrollView(
                child: Column(
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _item(
                                  title: 'Year',
                                  ctrl: TextEditingController(),
                                  isYear: true),
                              heith5Space,
                              _item(
                                  title: 'Month',
                                  ctrl: TextEditingController(),
                                  isMonth: true),
                              heith5Space,
                              _item(
                                  title: 'Employee',
                                  ctrl: viewModel.employeeCtrl),
                              heith5Space,
                              _item(
                                  title: 'Department',
                                  ctrl: viewModel.departmentCtrl),
                              heith5Space,
                              _item(
                                  title: 'Job Position',
                                  ctrl: viewModel.jobPositionCtrl),
                              heithSpace,
                              const SizedBox(
                                height: 10.0,
                              ),
                              achievementWidgetCard(
                                  context, "Daily", widget.data.dailyLines!,
                                  noRadiusValue: true),
                              achievementWidgetCard(
                                  context, "Weekly", widget.data.weeklyLines!,
                                  noRadiusHeadTile: true,
                                  noRadiusValue: true,
                                  isWeekly: true),
                              achievementWidgetCard(
                                  context, "Monthly", widget.data.monthlyLines!,
                                  noRadiusHeadTile: true, isMonthly: true),
                              const SizedBox(height: 10),
                            ],
                          )),
                    ),
                    // LOG NOTE

                    WidgetCommentLogNote(
                        padding: EdgeInsets.symmetric(horizontal: mainPadding),
                        resId: widget.data.id,
                        model: monthlyPLMEmployeeAchievement),
                    heithSpace,
                    heithSpace
                  ],
                ),
              )));
  Widget _item(
          {required String title,
          required TextEditingController ctrl,
          bool isYear = false,
          bool isMonth = false}) =>
      Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        // TITLE
        Expanded(
            child:
                Text(title, style: primary15Bold.copyWith(color: blackColor))),

        // CTRL
        if (!isYear && !isMonth) ...[
          Expanded(
              flex: 2,
              child: InputTextField(
                ctrl: ctrl,
                isNoTitle: true,
                readOnly: true,
                readOnlyAndFilled: true,
                enableSelectText: false,
              ))
        ],

        // YEAR
        if (isYear) ...[
          Consumer<SelectionsViewModel>(
              builder: (context, viewModel, _) => Expanded(
                  flex: 2,
                  child: CustomDropList(
                      selected: viewModel.yearSelection[widget.data.year],
                      items: viewModel.yearSelection.values.toList(),
                      itemAsString: (i) => i.toString(),
                      enabled: false,
                      readOnlyAndFilled: true,
                      onChanged: (v) {})))
        ],

        // MONTH
        if (isMonth) ...[
          Consumer<SelectionsViewModel>(
              builder: (context, viewModel, _) => Expanded(
                  flex: 2,
                  child: CustomDropList(
                      selected: viewModel.monthSelection[widget.data.month],
                      items: viewModel.monthSelection.values.toList(),
                      itemAsString: (i) => i.toString(),
                      enabled: false,
                      readOnlyAndFilled: true,
                      onChanged: (v) {})))
        ]
      ]);
}
