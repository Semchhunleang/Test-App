import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/view_models/approve_leave_view_model.dart';
import 'package:umgkh_mobile/views/pages/hr/approve_leave/widget/leave_filter.dart';

class TopCardApproveLeave extends StatefulWidget {
  const TopCardApproveLeave({Key? key}) : super(key: key);

  @override
  State<TopCardApproveLeave> createState() => _TopCardApproveLeaveState();
}

class _TopCardApproveLeaveState extends State<TopCardApproveLeave> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<ApproveLeaveViewModel>(
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
            SizedBox(
              height: _isExpanded
                  ? MediaQuery.of(context).size.height * 0.3
                  : MediaQuery.of(context).size.height * 0.04,
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 0, 8, 5),
                itemCount: viewModel.leaveSummaries.length,
                itemBuilder: (context, index) {
                  final leaveSummary = viewModel.leaveSummaries[index];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            leaveSummary.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text('${leaveSummary.numberOfDays} Days'),
                        ],
                      ),
                      if (_isExpanded)
                        ListView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(left: 20),
                          itemCount: leaveSummary.summaries.length,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, subIndex) {
                            final subSummary = leaveSummary.summaries[subIndex];
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(subSummary.leaveType.name),
                                Text('${subSummary.numberOfDays} Days'),
                              ],
                            );
                          },
                        ),
                    ],
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: mainPadding / 3),
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  child: Text(_isExpanded ? 'Show Less' : 'Show More',
                      style: primary12Bold.copyWith(
                          fontWeight: FontWeight.normal),),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
