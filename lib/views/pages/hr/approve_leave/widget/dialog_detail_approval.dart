import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/models/hr/leave/leave.dart';
import 'package:umgkh_mobile/view_models/approve_leave_view_model.dart';

// import '../../../../../models/request_overtime.dart';
// import '../../../../../utils/format_datetime_string.dart';
import '../../../../../utils/static_state.dart';
import '../../../../../utils/theme.dart';
import '../../../../../utils/utlis.dart';
// import '../../../../../view_models/approve_request_overtime_form_view_model.dart';
// import '../../../../../view_models/approve_request_overtime_view_model.dart';
import '../../../../../widgets/button_custom.dart';
import '../../approve_leave/widget/widget_text_value.dart';
import 'pop_up_confirmation.dart';

void showApproveLeaveDetailsDialog(
    BuildContext context, Leave leave, String state) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: mainPadding * 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: EdgeInsets.fromLTRB(
                        mainPadding, mainPadding, mainPadding, mainPadding / 2),
                    child: Text('Request Leave Details', style: primary15Bold)),
                const Divider(),

                // text
                heith5Space,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WidgetTextValue(
                      title: 'State: ',
                      value: stateTitleLeave(state),
                      fontWeight: FontWeight.w800,
                      valueColor: stateColor(state),
                    ),
                    heithSpace,
                    WidgetTextValue(
                      title: 'Date: ',
                      value:
                          '${DateFormat('d MMM yyyy').format(leave.requestDateFrom)} - ${DateFormat('d MMM yyyy').format(leave.requestDateTo)}',
                    ),
                    heithSpace,
                    WidgetTextValue(
                      title: 'Name: ',
                      value: leave.user.name,
                    ),
                    heithSpace,
                    WidgetTextValue(
                      title: 'Department: ',
                      value: leave.user.department!.name,
                    ),
                  ],
                ),
                heith10Space,
                const Divider(),
                heith10Space,
                Text(leave.description, style: titleStyle13),
                if (state == confirm) heith10Space,
                if (state == confirm) heith10Space,
                if (state == confirm)
                  Consumer<ApproveLeaveViewModel>(
                      builder: (context, provide, child) {
                    return Row(
                      children: [
                        ButtonCustom(
                          onTap: () {
                            Navigator.pop(context);
                            // provider.hourCtrl.text =
                            //     requestOvertimeList.overtimeHours.toString();
                            // provider.minuteCtrl.text =
                            //     requestOvertimeList.overtimeMinutes.toString();
                            popUpConfirmation(
                              context,
                              message:
                                  "Are you sure you want to approve the leave?",
                              titleAction: "Approve",
                              state: "validate1",
                              data: leave,
                            );
                          },
                          text: 'Approve',
                        ),
                        widthSpace,
                        ButtonCustom(
                          onTap: () {
                            Navigator.pop(context);
                            popUpConfirmation(
                              context,
                              message:
                                  "Are you sure you want to reject the leave?",
                              titleAction: "Reject",
                              state: "refuse",
                              data: leave,
                            );
                          },
                          text: 'Reject',
                          color: redColor,
                        )
                      ],
                    );
                  }),
                if (state == submit) heith10Space,
                // if (state != 'submit')
                Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('Close',
                            style: primary12Bold.copyWith(color: redColor)))),
              ],
            ),
          ),
        ),
      );
    },
  );
}

// button for approve in form info
class WidgetApprovalLeaveButton extends StatelessWidget {
  final Leave leave;
  const WidgetApprovalLeaveButton({super.key, required this.leave});

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(horizontal: mainPadding * 2),
        child: Row(
          children: [
            ButtonCustom(
              text: 'Approve',
              color: approvedColor,
              isExpan: true,
              onTap: () {
                popUpConfirmation(
                  context,
                  message: "Are you sure you want to approve the leave?",
                  titleAction: "Approve",
                  state: "validate1",
                  data: leave,
                );
              },
            ),
            widthSpace,
            ButtonCustom(
              text: 'Reject',
              color: redColor,
              isExpan: true,
              onTap: () {
                popUpConfirmation(
                  context,
                  message: "Are you sure you want to reject the leave?",
                  titleAction: "Reject",
                  state: "refuse",
                  data: leave,
                );
              },
            ),
          ],
        ),
      );
}
