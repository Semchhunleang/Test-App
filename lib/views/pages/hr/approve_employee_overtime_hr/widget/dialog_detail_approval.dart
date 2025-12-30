import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/models/hr/overtime/overtime.dart';
import 'package:umgkh_mobile/utils/static_state.dart';
import 'package:umgkh_mobile/view_models/approve_employee_overtime_form_view_model.dart';
import 'package:umgkh_mobile/view_models/approve_employee_overtime_dh_view_model.dart';
import '../../../../../utils/theme.dart';
import '../../../../../utils/utlis.dart';
import '../../../../../widgets/button_custom.dart';
import 'pop_up_confirmation.dart';

void showApprovalDetailsDialog(
    BuildContext context, Overtime data, String state) {
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
                    child: Text('Employee Overtime Details',
                        style: primary15Bold),),
                const Divider(),

                // text
                heith5Space,
                Text(stateTitleOvertime(data.state),
                    style:
                        primary13Bold.copyWith(color: stateColor(data.state),),),
                Text(formatDDMMMMYYYY(data.overtimeDate), style: titleStyle12),
                Text(data.employee?.name ?? nullStr, style: primary12Bold),
                Text(data.employee?.department?.name ?? nullStr,
                    style: titleStyle12),
                Text('Day: ${data.dayname ?? nullStr}', style: titleStyle12),
                Text(
                    'First 30 mins: ${data.isFirst30Min == true ? 'Counted' : 'Not Counted'}',
                    style: titleStyle12),
                Text('Distance: ${data.distance} km', style: titleStyle12),
                Text(
                    'Worked duration: ${data.overtimeHours}:${data.overtimeMinutes}',
                    style: titleStyle12),
                Text(
                    'Approved duration: ${data.approvedOvertimeHours}:${data.approvedOvertimeMinutes}',
                    style: titleStyle12),
                Text.rich(TextSpan(
                    text: 'Amount: ',
                    style: titleStyle12,
                    children: [
                      TextSpan(
                          text: '\$ ${formatDecimal(data.amountOvertime)}',
                          style: primary12Bold)
                    ]),),

                heith10Space,
                const Divider(),
                heith10Space,
                Text(data.reason ?? "", style: titleStyle13),

                if (state == approveDH) heith10Space,
                if (state == approveDH) heith10Space,

                // to update
                if (state == approveDH)
                  Consumer2<ApproveEmployeeOvertimeFormViewModel,
                          ApproveEmployeeOvertimeDHViewModel>(
                      builder: (context, provider, providerView, child) {
                    return Row(children: [
                      ButtonCustom(
                          onTap: () {
                            Navigator.pop(context);
                            popUpConfirmation(context,
                                message:
                                    "Are you sure you want to approve the employee overtime?",
                                titleAction: "Approve",
                                state: "approve_hr",
                                data: data);
                          },
                          text: 'Approve',
                          isExpan: true),
                      widthSpace,
                      ButtonCustom(
                          onTap: () {
                            Navigator.pop(context);
                            popUpConfirmation(context,
                                message:
                                    "Are you sure you want to reject the employee overtime?",
                                titleAction: "Reject",
                                state: "reject",
                                data: data);
                          },
                          text: 'Reject',
                          color: redColor,
                          isExpan: true)
                    ]);
                  }),

                Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('Close',
                            style: primary12Bold.copyWith(color: redColor),),),),
              ],
            ),
          ),
        ),
      );
    },
  );
}
