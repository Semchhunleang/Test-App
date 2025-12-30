import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/view_models/access_levels_view_model.dart';
import 'package:umgkh_mobile/views/pages/cms/plm/plm_sales/plm_sales_ach/index.dart';
import 'package:umgkh_mobile/views/pages/cms/plm/plm_sales/plm_sales_monthly_dept_ach/index.dart';
import 'package:umgkh_mobile/widgets/custom_scaffold.dart';
import 'package:umgkh_mobile/widgets/widget_button_action.dart';

class PLMSalesPage extends StatefulWidget {
  static const routeName = '/plm-sales';
  static const pageName = 'PLM Sales';
  const PLMSalesPage({super.key});

  @override
  State<PLMSalesPage> createState() => _PLMSalesPageState();
}

class _PLMSalesPageState extends State<PLMSalesPage> {
  @override
  Widget build(BuildContext context) => Consumer<AccessLevelViewModel>(
      builder: (context, viewModel, _) => CustomScaffold(
            title: PLMSalesPage.pageName,
            body: Padding(
                padding: EdgeInsets.symmetric(horizontal: mainPadding),
                child: const Column(children: [
                  WidgetButtonActionn(
                      name: PLMSalesAchievementPage.pageName,
                      page: PLMSalesAchievementPage(),
                      icon: Icons.view_timeline),
                  WidgetButtonActionn(
                      name: MonthlyDeptPLMSalesAchievementPage.pageName,
                      page: MonthlyDeptPLMSalesAchievementPage(),
                      icon: Icons.table_view_rounded),
                ])),
          ));
}
