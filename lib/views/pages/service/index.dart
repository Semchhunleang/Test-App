import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/view_models/access_levels_view_model.dart';
import 'package:umgkh_mobile/views/pages/service/field_service/index.dart';
import 'package:umgkh_mobile/views/pages/service/workshop/index.dart';
import 'package:umgkh_mobile/widgets/custom_scaffold.dart';
import 'package:umgkh_mobile/widgets/widget_button_action.dart';
import 'package:umgkh_mobile/widgets/widget_no_access.dart';

class ServicePage extends StatefulWidget {
  static const routeName = '/service';
  static const pageName = 'Service';

  const ServicePage({super.key});

  @override
  State<ServicePage> createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  @override
  Widget build(BuildContext context) => Consumer<AccessLevelViewModel>(
      builder: (context, viewModel, _) => CustomScaffold(
          title: ServicePage.pageName,
          body: viewModel.hasFSAccess()
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: mainPadding),
                  child: Column(children: [
                    if (viewModel.accessLevel.fieldService == 1) ...[
                      const WidgetButtonActionn(
                          name: 'Field Service',
                          page: FieldServicePage(),
                          icon: Icons.settings)
                    ],
                    if (viewModel.accessLevel.workshop == 1) ...[
                      const WidgetButtonActionn(
                          name: 'Workshop',
                          page: WorkshopPage(),
                          icon: Icons.warehouse)
                    ],
                  ]),
                )
              : const WidgetNoAccess()));
}
