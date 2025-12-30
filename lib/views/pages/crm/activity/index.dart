import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/utils/navigator.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/view_models/activity_view_model.dart';
import 'package:umgkh_mobile/views/pages/crm/activity/form.dart';
import 'package:umgkh_mobile/views/pages/crm/activity/widget/item_activity_widget.dart';
import 'package:umgkh_mobile/widgets/custom_scaffold.dart';
import 'package:umgkh_mobile/widgets/float_bt.dart';
import 'package:umgkh_mobile/widgets/list_condition.dart';

class ScheduleActivityPage extends StatefulWidget {
  static const routeName = '/schedule-activity';
  static const scheduleName = 'Schedule';
  static const activityName = 'Activities';
  static const bothName = 'Schedule & Activities';
  final int id;
  const ScheduleActivityPage({super.key, required this.id});

  @override
  State<ScheduleActivityPage> createState() => _ScheduleActivityPageState();
}

class _ScheduleActivityPageState extends State<ScheduleActivityPage> {
  @override
  void initState() {
    super.initState();
    final p = Provider.of<ActivityViewModel>(context, listen: false);
    p.fetchSchedule(widget.id);
    p.fetchActivity(widget.id);
  }

  @override
  Widget build(BuildContext context) => Consumer<ActivityViewModel>(
      builder: (context, viewModel, _) => CustomScaffold(
          title: title(viewModel),
          body: Column(children: [
            ListCondition(
                viewModel: viewModel,
                showedData: viewModel.showActivity.isNotEmpty
                    ? viewModel.showActivity
                    : viewModel.showSchedule,
                onRefresh: () async {
                  await viewModel.fetchSchedule(widget.id);
                  await viewModel.fetchActivity(widget.id);
                },
                child: ListView(children: [
                  if (viewModel.showSchedule.isNotEmpty) ...[
                    Column(
                        children: viewModel.showSchedule
                            .map((item) => Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: mainPadding),
                                child: ItemActivityWidget(
                                    data: item,
                                    leadId: widget.id,
                                    isRefreshSchedule: true,
                                    canEdit: true)))
                            .toList()),
                    if (viewModel.showActivity.isNotEmpty)
                      Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: mainPadding * 5,
                              vertical: mainPadding),
                          child: Divider(color: primaryColor.withOpacity(0.5)))
                  ],
                  Column(
                      children: viewModel.showActivity
                          .map((item) => Padding(
                              padding: EdgeInsets.fromLTRB(
                                  mainPadding, 0, mainPadding, 0),
                              child: ItemActivityWidget(
                                  data: item, leadId: widget.id)))
                          .toList())
                ]))
          ]),
          floatingBt: DefaultFloatButton(onTap: () async {
            if (mounted) {
              await navPush(context, ActivityFormPage(id: widget.id));
              viewModel.fetchSchedule(widget.id);
              viewModel.fetchActivity(widget.id);
            }
          })));

  String title(ActivityViewModel p) =>
      p.showActivity.isNotEmpty && p.showSchedule.isNotEmpty
          ? ScheduleActivityPage.bothName
          : p.showActivity.isNotEmpty
              ? ScheduleActivityPage.activityName
              : p.showSchedule.isNotEmpty
                  ? ScheduleActivityPage.scheduleName
                  : ScheduleActivityPage.bothName;
}
