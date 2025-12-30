import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/view_models/take_leave_view_model.dart';
import 'package:umgkh_mobile/views/pages/hr/take_leave/widget/leave_filter.dart';

class TopCardTakeLeave extends StatefulWidget {
  const TopCardTakeLeave({Key? key}) : super(key: key);

  @override
  State<TopCardTakeLeave> createState() => _TopCardTakeLeaveState();
  
}

class _TopCardTakeLeaveState extends State<TopCardTakeLeave> {

  @override
  Widget build(BuildContext context) {
    return Consumer<TakeLeaveViewModel>(
      builder: (context, viewModel, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const LeaveFilter(),
            if (viewModel.totalLeave > 0)
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Leave Summary",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: theme().primaryColor,
                      ),
                    ),
                    Text(
                      '${viewModel.totalLeave} Days',
                      style: TextStyle(
                        color: theme().primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.fromLTRB(20, 0, 8, 5),
              itemCount: viewModel.leaveSummaries.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final summary = viewModel.leaveSummaries[index];
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(summary.leaveType.name),
                    Text('${summary.numberOfDays} Days'),
                  ],
                );
              },
            ),
          ],
        );
      },
    );
  }
}
