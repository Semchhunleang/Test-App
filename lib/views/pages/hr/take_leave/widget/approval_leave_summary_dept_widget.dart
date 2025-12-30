import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/view_models/approve_leave_view_model.dart';

class ApprovalLeaveSummaryDeptWidget extends StatefulWidget {
  final int deptId;
  final String deptName;
  const ApprovalLeaveSummaryDeptWidget(
      {super.key, required this.deptId, required this.deptName});

  @override
  State<ApprovalLeaveSummaryDeptWidget> createState() =>
      _ApprovalLeaveSummaryDeptWidgetState();
}

class _ApprovalLeaveSummaryDeptWidgetState
    extends State<ApprovalLeaveSummaryDeptWidget> {
  bool _isExpanded = false;
  @override
  void initState() {
    final vm = Provider.of<ApproveLeaveViewModel>(context, listen: false);
    vm.fetchLeaveByDept(widget.deptId);

    super.initState();
  }

  @override
  Widget build(BuildContext context) => Consumer<ApproveLeaveViewModel>(
      builder: (context, viewModel, _) => FadeIn(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Padding(
                    padding: EdgeInsets.only(
                        top: mainPadding / 2, bottom: mainPadding),
                    child:
                        Divider(color: greyColor.withOpacity(0.9), height: 0)),
                Padding(
                    padding: EdgeInsets.only(
                        left: mainPadding / 2, right: mainPadding / 2),
                    child: viewModel.totalLeaveByDept <= 0
                        ? FadeIn(
                            child: Row(children: [
                            Text('Loading leave summaries by department...\t\t',
                                style: hintStyle),
                            SizedBox(
                                height: 15,
                                width: 15,
                                child: CircularProgressIndicator(
                                    color: greyColor, strokeWidth: 2))
                          ]))
                        : FadeIn(
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                Expanded(
                                    child: Text(
                                        '${widget.deptName} (${viewModel.year})',
                                        style: titleStyle15.copyWith(
                                            fontWeight: FontWeight.bold))),
                                width10Space,
                                Text(
                                    '${viewModel.totalLeaveByDept} Day${viewModel.totalLeaveByDept > 1 ? 's' : '\t\t'}',
                                    style: primary15Bold)
                              ]))),
                _isExpanded
                    ? FadeIn(
                        child: Padding(
                            padding: EdgeInsets.only(
                                left: mainPadding,
                                top: mainPadding / 3,
                                right: mainPadding / 2,
                                bottom: mainPadding / 3),
                            child: Column(
                                children: viewModel.leaveDeptSummaries
                                    .asMap()
                                    .entries
                                    .map((e) => Column(children: [
                                          heith10Space,
                                          Row(children: [
                                            Expanded(
                                                child: Text(
                                                    '${e.key + 1}. ${e.value.employeeName}',
                                                    style:
                                                        titleStyle14.copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold))),
                                            Text(
                                                '${e.value.employeeTotalLeave} Day${e.value.employeeTotalLeave > 1 ? 's' : '\t\t'}',
                                                style: primary14Bold)
                                          ]),
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  left: mainPadding),
                                              child: Column(
                                                  children: e.value.leaveTypes
                                                      .map(
                                                          (e) => Row(children: [
                                                                Expanded(
                                                                    child: Text(
                                                                        '• ${e.name}',
                                                                        style:
                                                                            titleStyle13)),
                                                                Text(
                                                                    '${e.numberOfDays} Day${e.numberOfDays! > 1 ? 's' : '\t\t'}',
                                                                    style:
                                                                        titleStyle13)
                                                              ]))
                                                      .toList()))
                                        ]))
                                    .toList())))
                    : sizedBoxShrink,
                Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                        padding: EdgeInsets.only(right: mainPadding / 2),
                        child: InkWell(
                            onTap: () =>
                                setState(() => _isExpanded = !_isExpanded),
                            borderRadius: BorderRadius.circular(mainRadius),
                            child: Padding(
                                padding: EdgeInsets.all(mainPadding / 2),
                                child: Text(
                                    _isExpanded ? 'Show Less' : 'Show More',
                                    style: titleStyle12.copyWith(
                                        fontWeight: FontWeight.normal)))))),
                heith5Space,
                Padding(
                    padding: EdgeInsets.only(bottom: mainPadding),
                    child:
                        Divider(color: greyColor.withOpacity(0.9), height: 0))
              ])));
}
