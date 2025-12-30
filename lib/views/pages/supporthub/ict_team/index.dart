import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/view_models/access_levels_view_model.dart';
import 'package:umgkh_mobile/view_models/profile_view_model.dart';
import 'package:umgkh_mobile/views/pages/supporthub/erp_team/erp/index.dart';
import 'package:umgkh_mobile/views/pages/supporthub/ict_team/request/index.dart';
import 'package:umgkh_mobile/widgets/custom_scaffold.dart';
import 'package:umgkh_mobile/widgets/widget_button_action.dart';

class ICTTeamPage extends StatefulWidget {
  static const routeName = '/ict-team';
  static const pageName = 'ICT Team';
  const ICTTeamPage({super.key});

  @override
  State<ICTTeamPage> createState() => _ICTTeamPageState();
}

class _ICTTeamPageState extends State<ICTTeamPage> {
  @override
  Widget build(BuildContext context) =>
      Consumer2<AccessLevelViewModel, ProfileViewModel>(
          builder: (context, accessVM, userVM, _) => CustomScaffold(
              title: ICTTeamPage.pageName,
              body: Padding(
                  padding: EdgeInsets.symmetric(horizontal: mainPadding),
                  child: Column(children: [
                    if (userVM.isICT()) ...[
                      const WidgetButtonActionn(
                          name: ErpTeamPage.pageName,
                          page: ErpTeamPage(),
                          icon: Icons.groups_rounded)
                    ],
                    const WidgetButtonActionn(
                        name: RequestICTTicketPage.pageName,
                        page: RequestICTTicketPage(),
                        icon: Icons.medical_information_rounded)
                  ]))));
}
