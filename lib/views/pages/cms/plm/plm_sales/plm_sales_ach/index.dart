import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/view_models/plm/plm_sales/plm_sales_view_model.dart';
import 'package:umgkh_mobile/views/pages/cms/plm/plm_sales/plm_sales_ach/widget/item_plm_sales_widget.dart';
import 'package:umgkh_mobile/widgets/custom_scaffold.dart';
import 'package:umgkh_mobile/widgets/list_condition.dart';
import 'package:umgkh_mobile/widgets/textfield.dart';

class PLMSalesAchievementPage extends StatefulWidget {
  static const routeName = '/plm-sales-achievement';
  static const pageName = 'PLM Sales Achievement';
  const PLMSalesAchievementPage({super.key});

  @override
  State<PLMSalesAchievementPage> createState() =>
      _PLMSalesAchievementPageState();
}

class _PLMSalesAchievementPageState extends State<PLMSalesAchievementPage> {
  @override
  void initState() {
    super.initState();
    final vm = Provider.of<PLMSalesViewModel>(context, listen: false);
    vm.resetData();
    vm.fetchData();
  }

  @override
  Widget build(BuildContext context) => Consumer<PLMSalesViewModel>(
      builder: (context, viewModel, _) => CustomScaffold(
          title: PLMSalesAchievementPage.pageName,
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
                    child: Row(children: [
                      Expanded(
                          child: SearchTextfield(
                              ctrl: viewModel.searchCtrl,
                              onChanged: (v) =>
                                  viewModel.onSearchChanged(context, v)))
                    ]))),

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
                        ItemPLMSalesWidget(data: viewModel.showedData[i])))
          ])));
}
