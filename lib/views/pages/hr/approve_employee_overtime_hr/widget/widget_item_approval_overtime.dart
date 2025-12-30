import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/models/hr/overtime/overtime.dart';
import 'package:umgkh_mobile/view_models/approve_employee_overtime_form_view_model.dart';
import 'package:umgkh_mobile/widgets/button_custom.dart';
import '../../../../../utils/static_state.dart';
import '../../../../../utils/theme.dart';
import '../../../../../utils/utlis.dart';
import 'dialog_detail_approval.dart';
import 'pop_up_confirmation.dart';

class WidgetItemApprovalOvertime extends StatefulWidget {
  final Overtime data;
  const WidgetItemApprovalOvertime({super.key, required this.data});

  @override
  State<WidgetItemApprovalOvertime> createState() =>
      _WidgetItemApprovalOvertimeState();
}

class _WidgetItemApprovalOvertimeState
    extends State<WidgetItemApprovalOvertime> {
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () {
          showApprovalDetailsDialog(context, widget.data, widget.data.state!);
        },
        child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(mainRadius),),
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
                          text: stateTitleOvertime(widget.data.state),
                          color: stateColor(widget.data.state),),),
                  heith5Space,

                  /// data info
                  Text(formatDMMMMYYYY(widget.data.overtimeDate),
                      style: titleStyle12),

                  Text(
                      ifNullModel(
                          widget.data.employee, (e) => ifNullStr(e.name),),
                      style: primary12Bold),

                  Text(
                      ifNullModel(widget.data.employee!.department,
                          (e) => ifNullStr(e.name),),
                      style: titleStyle12),

                  Text(
                      'Request: ${widget.data.overtimeHours} hours ${widget.data.overtimeMinutes} minutes',
                      style: titleStyle12),
                  Text(
                      'Approved: ${widget.data.approvedOvertimeHours} hours ${widget.data.approvedOvertimeMinutes} minutes',
                      style: titleStyle12),
                  heithSpace,
                  Text('${widget.data.reason}',
                      style: titleStyle12,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  heith10Space,

                  if (widget.data.state == approveDH)
                    Consumer<ApproveEmployeeOvertimeFormViewModel>(
                        builder: (context, provider, child) {
                      return Row(children: [
                        ButtonCustom(
                            onTap: () {
                              popUpConfirmation(context,
                                  message:
                                      "Are you sure you want to approve the employee overtime?",
                                  titleAction: "Approve",
                                  state: "approve_hr",
                                  data: widget.data);
                            },
                            text: 'Approve'),
                        widthSpace,
                        ButtonCustom(
                            onTap: () {
                              popUpConfirmation(context,
                                  message:
                                      "Are you sure you want to reject the employee overtime?",
                                  titleAction: "Reject",
                                  state: "reject",
                                  data: widget.data);
                            },
                            text: 'Reject',
                            color: redColor)
                      ]);
                    }),
                  if (widget.data.state == approveDH) heith10Space,
                ],
              ),
            ),),
      );
}
