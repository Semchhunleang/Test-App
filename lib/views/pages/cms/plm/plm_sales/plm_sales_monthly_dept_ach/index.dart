import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/view_models/plm/plm_sales/plm_sales_monthly_dept_view_model.dart';
import 'package:umgkh_mobile/view_models/selections_view_model.dart';
import 'package:umgkh_mobile/views/pages/cms/plm/plm_sales/plm_sales_monthly_dept_ach/widget/item_monthly_dept_plm_sales_ach_widget.dart';
import 'package:umgkh_mobile/widgets/custom_drop_list.dart';
import 'package:umgkh_mobile/widgets/custom_scaffold.dart';
import 'package:umgkh_mobile/widgets/list_condition.dart';
import 'package:umgkh_mobile/widgets/textfield.dart';

class MonthlyDeptPLMSalesAchievementPage extends StatefulWidget {
  static const routeName = '/monthly-dept-plm-sales-achievement';
  static const pageName = 'Monthly Department PLM Sales Achievement';
  const MonthlyDeptPLMSalesAchievementPage({super.key});

  @override
  State<MonthlyDeptPLMSalesAchievementPage> createState() =>
      _MonthlyDeptPLMSalesAchievementPageState();
}

class _MonthlyDeptPLMSalesAchievementPageState
    extends State<MonthlyDeptPLMSalesAchievementPage> {
  @override
  void initState() {
    super.initState();
    final vm =
        Provider.of<PLMSalesMonthlyDeptViewModel>(context, listen: false);
    vm.resetData();
    vm.fetchData();
  }

  @override
  Widget build(BuildContext context) => Consumer<PLMSalesMonthlyDeptViewModel>(
      builder: (context, viewModel, _) => CustomScaffold(
          title: MonthlyDeptPLMSalesAchievementPage.pageName,
          body: Column(children: [
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
                        // SEARCH
                        SearchTextfield(
                            ctrl: viewModel.searchCtrl,
                            onChanged: viewModel.onSearchChanged),
                        heith10Space,
                        Row(children: [
                          // YEAR
                          Consumer<SelectionsViewModel>(
                            builder: (context, vm, _) => Expanded(
                              child: CustomDropList(
                                  selected: vm.yearSelection[viewModel.year],
                                  items: vm.yearSelection.values.toList(),
                                  itemAsString: (i) => i.toString(),
                                  onChanged: (v) {
                                    final selectedKey = vm.yearSelection.entries
                                        .firstWhere((entry) => entry.value == v)
                                        .key;
                                    viewModel.onYearChanged(selectedKey);
                                  }),
                            ),
                          ),
                          width10Space,
                          // MONTH
                          Consumer<SelectionsViewModel>(
                              builder: (context, vm, _) {
                            final dropdownData = {
                              "00": "All",
                              ...vm.monthSelection,
                            };
                            return Expanded(
                              child: CustomDropList(
                                  selected: dropdownData[viewModel.month],
                                  items: dropdownData.values.toList(),
                                  itemAsString: (i) => i.toString(),
                                  onChanged: (v) {
                                    final selectedKey = dropdownData.entries
                                        .firstWhere((entry) => entry.value == v)
                                        .key;
                                    viewModel.onMonthChanged(selectedKey);
                                  }),
                            );
                          }),
                        ]),
                      ],
                    ))),

            // list
            ListCondition(
                viewModel: viewModel,
                showedData: viewModel.showedData,
                onRefresh: () => viewModel.fetchData(),
                child: ListView.builder(
                    padding: EdgeInsets.symmetric(
                        horizontal: mainPadding, vertical: mainPadding / 2),
                    itemCount: viewModel.showedData.length,
                    itemBuilder: (context, i) =>
                        ItemMonthlyDeptPLMSalesAchWidget(
                            data: viewModel.showedData[i])))
          ])));
}
