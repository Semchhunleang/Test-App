import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/view_models/access_levels_view_model.dart';
import 'package:umgkh_mobile/views/pages/cms/plm/plm_supporting/monthly_plm_achievement/index.dart';
import 'package:umgkh_mobile/views/pages/cms/plm/plm_supporting/monthly_plm_target/index.dart';
import 'package:umgkh_mobile/widgets/custom_scaffold.dart';
import 'package:umgkh_mobile/widgets/widget_button_action.dart';

class PLMSupportingPage extends StatefulWidget {
  static const routeName = '/plm-supporting';
  static const pageName = 'PLM Supporting';
  const PLMSupportingPage({super.key});

  @override
  State<PLMSupportingPage> createState() => _PLMSupportingPageState();
}

class _PLMSupportingPageState extends State<PLMSupportingPage> {
  @override
  Widget build(BuildContext context) => Consumer<AccessLevelViewModel>(
      builder: (context, viewModel, _) => CustomScaffold(
            title: PLMSupportingPage.pageName,
            body: Padding(
                padding: EdgeInsets.symmetric(horizontal: mainPadding),
                child: const Column(children: [
                  WidgetButtonActionn(
                      name: MonthlyPLMTargetPage.pageName,
                      page: MonthlyPLMTargetPage(),
                      icon: Icons.view_timeline),
                  WidgetButtonActionn(
                      name: MonthlyPLMAchievementPage.pageName,
                      page: MonthlyPLMAchievementPage(),
                      icon: Icons.timeline),
                ])),
          ));
}
