import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/utils/navigator.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/view_models/access_levels_view_model.dart';
import 'package:umgkh_mobile/views/pages/crm/activity/activity_schedule.dart';
import 'package:umgkh_mobile/views/pages/crm/lead/index.dart';
import 'package:umgkh_mobile/widgets/custom_scaffold.dart';
import 'package:umgkh_mobile/widgets/widget_no_access.dart';
import 'opportunity/index.dart';

class CRMPage extends StatefulWidget {
  static const routeName = '/crm';
  static const pageName = 'CRM';
  const CRMPage({super.key});

  @override
  State<CRMPage> createState() => _CRMPageState();
}

class _CRMPageState extends State<CRMPage> {
  @override
  Widget build(BuildContext context) => Consumer<AccessLevelViewModel>(
        builder: (context, viewModel, _) => CustomScaffold(
          title: CRMPage.pageName,
          body: viewModel.hasCRMAccess()
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: mainPadding),
                  child: Column(children: [
                    if (viewModel.accessLevel.isCrmUnit == 1) ...[
                      item(
                          name: 'Lead Unit',
                          page: const LeadPage(isLeadUnit: true),
                          icon: Icons.agriculture_outlined),
                      item(
                          name: 'Opportunity Unit',
                          page: const OpportunityPage(serviceType: "unit"),
                          icon: Icons.agriculture_rounded)
                    ],
                    if (viewModel.accessLevel.isCrmSparepart == 1) ...[
                      item(
                          name: 'Lead Spare Part',
                          page: const LeadPage(isLeadUnit: false),
                          icon: Icons.extension_outlined),
                      item(
                          name: 'Opportunity Sparepart',
                          page: const OpportunityPage(serviceType: "sparepart"),
                          icon: Icons.extension)
                    ],
                    item(
                        name: 'Schedule',
                        page: const ActivityAndSchedulePage(isSchedule: true),
                        icon: Icons.schedule_rounded),
                    item(
                        name: 'Activity',
                        page: const ActivityAndSchedulePage(isSchedule: false),
                        icon: Icons.local_activity_rounded)
                  ]),
                )
              : const WidgetNoAccess(),
        ),
      );

  Widget item(
          {required String name,
          required Widget page,
          required IconData icon}) =>
      GestureDetector(
        onTap: () => navPush(context, page),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(mainRadius),
          ),
          color: primaryColor,
          margin: EdgeInsets.symmetric(vertical: mainPadding / 2),
          child: Padding(
            padding: EdgeInsets.all(mainPadding * 1.2),
            child: Row(children: [
              Icon(icon, color: whiteColor),
              widthSpace,
              Text(name, style: white13Bold)
            ]),
          ),
        ),
      );
}
