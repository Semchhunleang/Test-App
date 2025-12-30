import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/view_models/access_levels_view_model.dart';
import 'package:umgkh_mobile/views/pages/cms/plm/plm_sales/index.dart';
import 'package:umgkh_mobile/views/pages/cms/plm/plm_supporting/index.dart';
import 'package:umgkh_mobile/widgets/custom_scaffold.dart';
import 'package:umgkh_mobile/widgets/widget_button_action.dart';

class PLMPage extends StatefulWidget {
  static const routeName = '/plm';
  static const pageName = 'PLM';
  const PLMPage({super.key});

  @override
  State<PLMPage> createState() => _PLMPageState();
}

class _PLMPageState extends State<PLMPage> {
  @override
  Widget build(BuildContext context) => Consumer<AccessLevelViewModel>(
      builder: (context, viewModel, _) => CustomScaffold(
            title: PLMPage.pageName,
            body: Padding(
                padding: EdgeInsets.symmetric(horizontal: mainPadding),
                child: const Column(children: [
                  WidgetButtonActionn(
                      name: PLMSalesPage.pageName,
                      page: PLMSalesPage(),
                      icon: Icons.badge_rounded),
                  WidgetButtonActionn(
                    name: PLMSupportingPage.pageName,
                    page: PLMSupportingPage(),
                    icon: Icons.insert_chart_sharp,
                  ),
                ])),
          ));
}
