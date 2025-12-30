import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/utils/static_state.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/view_models/access_levels_view_model.dart';
import 'package:umgkh_mobile/views/pages/supporthub/erp_team/erp/contact_product/index.dart';
import 'package:umgkh_mobile/widgets/custom_scaffold.dart';
import 'package:umgkh_mobile/widgets/widget_button_action.dart';

class ErpTeamPage extends StatefulWidget {
  static const routeName = '/erp-team';
  static const pageName = 'ERP Team';
  const ErpTeamPage({super.key});

  @override
  State<ErpTeamPage> createState() => _ErpTeamPageState();
}

class _ErpTeamPageState extends State<ErpTeamPage> {
  @override
  Widget build(BuildContext context) => Consumer<AccessLevelViewModel>(
      builder: (context, viewModel, _) => CustomScaffold(
          title: ErpTeamPage.pageName,
          body: Padding(
              padding: EdgeInsets.symmetric(horizontal: mainPadding),
              child: const Column(children: [
                WidgetButtonActionn(
                    name: RequestContactAndProductForERPPage.pageNameContact,
                    page: RequestContactAndProductForERPPage(type: contact),
                    icon: Icons.perm_contact_cal_rounded),
                WidgetButtonActionn(
                    name: RequestContactAndProductForERPPage.pageNameProduct,
                    page: RequestContactAndProductForERPPage(type: product),
                    icon: Icons.category_rounded)
              ]))));
}
