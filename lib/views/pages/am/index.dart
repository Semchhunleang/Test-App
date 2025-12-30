import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/view_models/access_levels_view_model.dart';
import 'package:umgkh_mobile/views/pages/am/schedule_truck_driver/index.dart';
import 'package:umgkh_mobile/views/pages/am/small_paper/index.dart';
import 'package:umgkh_mobile/views/pages/am/vehicle_check/index.dart';
import 'package:umgkh_mobile/views/pages/am/scan/index.dart';
import 'package:umgkh_mobile/widgets/custom_scaffold.dart';
import 'package:umgkh_mobile/widgets/widget_button_action.dart';
import 'package:umgkh_mobile/widgets/widget_no_access.dart';

class AMPage extends StatefulWidget {
  static const routeName = '/am';
  static const pageName = 'Assets Management';
  const AMPage({super.key});

  @override
  State<AMPage> createState() => _AMPageState();
}

class _AMPageState extends State<AMPage> {
  @override
  Widget build(BuildContext context) => Consumer<AccessLevelViewModel>(
        builder: (context, viewModel, _) => CustomScaffold(
            title: AMPage.pageName,
            body: viewModel.hasAMAccess()
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: mainPadding),
                    child: Column(children: [
                      if (viewModel.accessLevel.smallPaper == 1) ...[
                        const WidgetButtonActionn(
                            name: 'Small Paper',
                            page: SmallPaperPage(),
                            icon: Icons.approval_rounded)
                      ],
                      // if (viewModel.accessLevel.scanSmallPaper == 1) ...[
                      //   const WidgetButtonActionn(
                      //       name: 'Scan Small Paper',
                      //       page: ScanSmallPaperPage(),
                      //       icon: Icons.qr_code_scanner_rounded)
                      // ],
                      if (viewModel.accessLevel.vehicleCheck == 1) ...[
                        const WidgetButtonActionn(
                            name: 'Vehicle Check',
                            page: VehicleCheckPage(),
                            icon: Icons.car_repair),
                      ],
                      if (viewModel.accessLevel.scanVehicleCheck == 1 ||
                          viewModel.accessLevel.scanSmallPaper == 1) ...[
                        const WidgetButtonActionn(
                            name: 'Scan  QR',
                            page: ScanVehicleCheckPage(),
                            icon: Icons.qr_code_scanner_rounded)
                      ],
                      if (true) ...[
                        const WidgetButtonActionn(
                            name: ScheduleTruckDriverPage.pageName,
                            page: ScheduleTruckDriverPage(),
                            icon: Icons.fire_truck_rounded)
                      ],
                    ]))
                : const WidgetNoAccess()),
      );
}
