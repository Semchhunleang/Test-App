import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/models/plm/plm_supporting/plm_target/plm_supporting.dart';
import 'package:umgkh_mobile/utils/odoo_model.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'package:umgkh_mobile/view_models/log_note_form_view_model.dart';
import 'package:umgkh_mobile/view_models/log_note_view_model.dart';
import 'package:umgkh_mobile/view_models/plm/plm_supporting/monthly_plm_target_form_view_model.dart';
import 'package:umgkh_mobile/view_models/selections_view_model.dart';
import 'package:umgkh_mobile/views/pages/cms/plm/plm_supporting/monthly_plm_target/widget/build_table_widget.dart';
import 'package:umgkh_mobile/views/pages/log_note/widget_comment_log_note.dart';
import 'package:umgkh_mobile/widgets/custom_drop_list.dart';
import 'package:umgkh_mobile/widgets/custom_scaffold.dart';
import 'package:umgkh_mobile/widgets/textfield.dart';

class MonthlyPLMTargetFormPage extends StatefulWidget {
  final PLMTarget data;
  static const routeName = '/plm-sales-info';
  static const pageName = 'Monthly PLM Target';
  const MonthlyPLMTargetFormPage({super.key, required this.data});

  @override
  State<MonthlyPLMTargetFormPage> createState() =>
      _MonthlyPLMTargetFormPageState();
}

class _MonthlyPLMTargetFormPageState extends State<MonthlyPLMTargetFormPage> {
  @override
  void initState() {
    super.initState();
    var vm = Provider.of<MonthlyPlmTargetFormViewModel>(context, listen: false);
    vm.resetForm();
    vm.setInfo(widget.data);
    fetchLogNote();
  }

  Future<void> fetchLogNote() async {
    final vmLN = Provider.of<LogNoteViewModel>(context, listen: false);
    final vmLNF = Provider.of<LogNoteFormViewModel>(context, listen: false);
    vmLN.fetchData(widget.data.id, monthlyPLMEmployeeTarget);
    vmLNF.resetForm();
  }

  @override
  Widget build(BuildContext context) => Consumer<MonthlyPlmTargetFormViewModel>(
      builder: (context, viewModel, _) => CustomScaffold(
          title: MonthlyPLMTargetFormPage.pageName,
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
                              title: 'Employee', ctrl: viewModel.employeeCtrl),
                          heith5Space,
                          _item(title: 'Department', ctrl: viewModel.deptCtrl),
                          heith5Space,
                          _item(title: 'Job Position', ctrl: viewModel.jobCtrl),
                          heithSpace,

                          //  BUILD TABLE - TARGET
                          BuildPLMTargetTableWidget(data: widget.data.targets)
                        ],
                      ))),

              // LOG NOTE
              heithSpace,
              WidgetCommentLogNote(
                  padding: EdgeInsets.symmetric(horizontal: mainPadding),
                  resId: widget.data.id,
                  model: monthlyPLMEmployeeTarget),
              heithSpace
            ],
          )));

  Widget _item(
          {required String title,
          required TextEditingController ctrl,
          bool isYear = false,
          bool isMonth = false}) =>
      Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        // TITLE
        width5Space,
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
                      selected: viewModel.monthSelection[
                          viewModel.reverseMonthSelection()[widget.data.month]],
                      items: viewModel.monthSelection.values.toList(),
                      itemAsString: (i) => i.toString(),
                      enabled: false,
                      readOnlyAndFilled: true,
                      onChanged: (v) {})))
        ]
      ]);
}
