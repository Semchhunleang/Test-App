import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/view_models/activity_view_model.dart';
import 'package:umgkh_mobile/view_models/selections_view_model.dart';
import 'package:umgkh_mobile/views/pages/crm/activity/widget/item_activity_widget.dart';
import 'package:umgkh_mobile/widgets/custom_scaffold.dart';
import 'package:umgkh_mobile/widgets/list_condition.dart';

class ActivityAndSchedulePage extends StatefulWidget {
  final bool isSchedule;
  const ActivityAndSchedulePage({super.key, required this.isSchedule});

  @override
  State<ActivityAndSchedulePage> createState() =>
      _ActivityAndSchedulePageState();
}

class _ActivityAndSchedulePageState extends State<ActivityAndSchedulePage> {
  @override
  void initState() {
    super.initState();
    final p = Provider.of<ActivityViewModel>(context, listen: false);
    final p2 = Provider.of<SelectionsViewModel>(context, listen: false);
    p.fetchActivityOrSchedule(widget.isSchedule);
    p2.fetchActType();
  }

  @override
  Widget build(BuildContext context) => Consumer<ActivityViewModel>(
      builder: (context, viewModel, _) => CustomScaffold(
          title: widget.isSchedule ? 'Schedule' : 'Activity',
          body: Column(children: [
            ListCondition(
                viewModel: viewModel,
                showedData: viewModel.showActivity,
                onRefresh: () =>
                    viewModel.fetchActivityOrSchedule(widget.isSchedule),
                child: ListView.builder(
                    padding: EdgeInsets.fromLTRB(
                        mainPadding, 0, mainPadding, mainPadding * 5.5),
                    itemCount: viewModel.showActivity.length,
                    itemBuilder: (context, i) => ItemActivityWidget(
                        canEdit: widget.isSchedule,
                        data: viewModel.showActivity[i],
                        leadId: viewModel.showActivity[i].resId)))
          ])));
}
