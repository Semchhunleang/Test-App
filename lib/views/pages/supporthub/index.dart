import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/view_models/access_levels_view_model.dart';
import 'package:umgkh_mobile/view_models/profile_view_model.dart';
import 'package:umgkh_mobile/views/pages/supporthub/erp_team/request/contact/index.dart';
import 'package:umgkh_mobile/views/pages/supporthub/erp_team/erp/index.dart';
import 'package:umgkh_mobile/views/pages/supporthub/ict_team/request/index.dart';
import 'package:umgkh_mobile/views/pages/supporthub/marketing_team/request/index.dart';
import 'package:umgkh_mobile/widgets/custom_scaffold.dart';
import 'package:umgkh_mobile/widgets/widget_button_action.dart';

class SupportHubPage extends StatefulWidget {
  static const routeName = '/supporthub-ticket';
  static const pageName = 'SupportHub';
  const SupportHubPage({super.key});

  @override
  State<SupportHubPage> createState() => _SupportHubPageState();
}

class _SupportHubPageState extends State<SupportHubPage> {
  @override
  Widget build(BuildContext context) =>
      Consumer2<AccessLevelViewModel, ProfileViewModel>(
          builder: (context, accessVM, userVM, _) => CustomScaffold(
              title: SupportHubPage.pageName,
              body: Padding(
                  padding: EdgeInsets.symmetric(horizontal: mainPadding),
                  child: Column(children: [
                    if (userVM.isErp()) ...[
                      const WidgetButtonActionn(
                          name: ErpTeamPage.pageName,
                          page: ErpTeamPage(),
                          icon: Icons.groups_rounded)
                    ],
                    // const WidgetButtonActionn(
                    //     name: ICTTeamPage.pageName,
                    //     page: ICTTeamPage(),
                    //     icon: Icons.groups_rounded),
                    const WidgetButtonActionn(
                        name: RequestContactPage.pageName,
                        page: RequestContactPage(),
                        icon: Icons.perm_contact_cal_rounded),
                    const WidgetButtonActionn(
                        name: RequestICTTicketPage.pageName,
                        page: RequestICTTicketPage(),
                        icon: Icons.wifi_calling_3_rounded),
                    const WidgetButtonActionn(
                        name: RequestMarketingTicketPage.pageName,
                        page: RequestMarketingTicketPage(),
                        icon: Icons.campaign),
                  ]))));
}
