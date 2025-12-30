import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/view_models/approve_leave_view_model.dart';

class ApprovalLeaveSummaryEmpWidget extends StatefulWidget {
  final int employeeId;
  final String employeeName;
  const ApprovalLeaveSummaryEmpWidget(
      {super.key, required this.employeeId, required this.employeeName});

  @override
  State<ApprovalLeaveSummaryEmpWidget> createState() =>
      _ApprovalLeaveSummaryEmpWidgetState();
}

class _ApprovalLeaveSummaryEmpWidgetState
    extends State<ApprovalLeaveSummaryEmpWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) =>
      Consumer<ApproveLeaveViewModel>(builder: (context, viewModel, _) {
        double totalLeave = 0;
        for (var e in viewModel.leaveSummaries) {
          if (e.userId == widget.employeeId) totalLeave = e.numberOfDays;
        }
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
              padding: EdgeInsets.only(left: mainPadding, right: mainPadding),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${widget.employeeName} (${viewModel.year})',
                        style:
                            titleStyle15.copyWith(fontWeight: FontWeight.bold)),
                    Text('$totalLeave Day${totalLeave > 1 ? 's' : '\t\t'}',
                        style: primary15Bold)
                  ])),
          heith5Space,
          Padding(
              padding:
                  EdgeInsets.only(left: mainPadding * 1.5, right: mainPadding),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: viewModel.leaveSummaries
                      .where((e) => e.userId == widget.employeeId)
                      .expand((e) => e.summaries.map((summary) => _isExpanded
                          ? FadeIn(
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                  Expanded(
                                      child: Text('• ${summary.leaveType.name}',
                                          style: titleStyle15)),
                                  Text(
                                      '${summary.numberOfDays} Day${summary.numberOfDays > 1 ? 's' : '\t\t'}',
                                      style: primary15Bold500)
                                ]))
                          : sizedBoxShrink))
                      .toList())),
          Align(
              alignment: Alignment.centerRight,
              child: Padding(
                  padding: EdgeInsets.only(right: mainPadding / 2),
                  child: InkWell(
                      onTap: () => setState(() => _isExpanded = !_isExpanded),
                      borderRadius: BorderRadius.circular(mainRadius),
                      child: Padding(
                          padding: EdgeInsets.all(mainPadding / 2),
                          child: Text(_isExpanded ? 'Show Less' : 'Show More',
                              style: titleStyle12.copyWith(
                                  fontWeight: FontWeight.normal)))))),
          heith5Space,
          Padding(
              padding: EdgeInsets.only(bottom: mainPadding),
              child: Divider(color: greyColor.withOpacity(0.9), height: 0))
        ]);
      });
}
