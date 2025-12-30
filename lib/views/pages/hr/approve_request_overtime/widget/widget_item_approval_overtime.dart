import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/models/hr/request_overtime/request_overtime.dart';
import 'package:umgkh_mobile/utils/navigator.dart';
import 'package:umgkh_mobile/utils/static_state.dart';
import 'package:umgkh_mobile/views/pages/hr/request_overtime/form.dart';
import 'package:umgkh_mobile/widgets/button_custom.dart';
import '../../../../../utils/theme.dart';
import '../../../../../utils/utlis.dart';
import '../../../../../view_models/approve_request_overtime_form_view_model.dart';
import 'pop_up_confirmation.dart';

class WidgetItemApprovalOvertime extends StatefulWidget {
  final RequestOvertime requestOvertimeList;
  const WidgetItemApprovalOvertime(
      {super.key, required this.requestOvertimeList});

  @override
  State<WidgetItemApprovalOvertime> createState() =>
      _WidgetItemApprovalOvertimeState();
}

class _WidgetItemApprovalOvertimeState
    extends State<WidgetItemApprovalOvertime> {
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () async {
          // showApprovalDetailsDialog(context, widget.requestOvertimeList,
          //     widget.requestOvertimeList.state!);
          await navPush(context,
              CreateRequestOvertimePage(overtime: widget.requestOvertimeList));
        },
        child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(mainRadius)),
            color: primaryColor.withOpacity(0.1),
            margin: EdgeInsets.symmetric(vertical: mainPadding / 2),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: mainPadding * 1.5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  heith10Space,

                  /// button
                  SizedBox(
                      width: double.infinity,
                      height: 25,
                      child: StatusCustom(
                          textsize: 11,
                          text: stateTitleOvertime(
                              widget.requestOvertimeList.state),
                          color: stateColor(widget.requestOvertimeList.state))),
                  heith5Space,

                  /// data info
                  Text(formatDate(widget.requestOvertimeList.overtimeDate!),
                      style: titleStyle12),
                  Text(widget.requestOvertimeList.employee!.name,
                      style: primary12Bold),
                  Text(widget.requestOvertimeList.employee!.department!.name,
                      style: titleStyle12),
                  Text(
                      'Request: ${widget.requestOvertimeList.overtimeHours} hours ${widget.requestOvertimeList.overtimeMinutes} Minute',
                      style: titleStyle12),
                  Text(
                      'Approved: ${widget.requestOvertimeList.dhOvertimeHours} hours ${widget.requestOvertimeList.dhOvertimeMinutes} Minute',
                      style: titleStyle12),
                  if (widget.requestOvertimeList.createBy != null) ...[
                    Text('Create By: ${widget.requestOvertimeList.createBy}',
                        style: titleStyle12)
                  ],
                  heithSpace,
                  if (widget.requestOvertimeList.reason != null) ...[
                    Text(
                      widget.requestOvertimeList.reason!.replaceAll('\n', ''),
                      style: titleStyle12,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                  heith10Space,

                  if (widget.requestOvertimeList.state == submit)
                    Consumer<ApproveRequestOvertimeFormViewModel>(
                        builder: (context, provider, child) {
                      return Row(
                        children: [
                          ButtonCustom(
                            onTap: () {
                              provider.hourCtrl.text = widget
                                  .requestOvertimeList.overtimeHours
                                  .toString();
                              provider.minuteCtrl.text = widget
                                  .requestOvertimeList.overtimeMinutes
                                  .toString();
                              popUpConfirmation(
                                context,
                                message:
                                    "Are you sure you want to approve the request overtime?",
                                titleAction: "Approve",
                                state: "approve_dh",
                                requestOvertimeList: widget.requestOvertimeList,
                              );
                            },
                            text: 'Approve',
                          ),
                          widthSpace,
                          ButtonCustom(
                            onTap: () {
                              popUpConfirmation(
                                context,
                                message:
                                    "Are you sure you want to reject the request overtime?",
                                titleAction: "Reject",
                                state: "reject",
                                requestOvertimeList: widget.requestOvertimeList,
                              );
                            },
                            text: 'Reject',
                            color: redColor,
                          )
                        ],
                      );
                    }),
                  if (widget.requestOvertimeList.state == submit) heith10Space,
                ],
              ),
            )),
      );
}
