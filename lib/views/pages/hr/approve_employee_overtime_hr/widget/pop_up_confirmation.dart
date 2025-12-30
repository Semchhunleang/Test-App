import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/models/hr/overtime/overtime.dart';
import 'package:umgkh_mobile/utils/static_state.dart';
import 'package:umgkh_mobile/view_models/approve_employee_overtime_form_view_model.dart';
import 'package:umgkh_mobile/view_models/approve_employee_overtime_hr_view_model.dart';
import '../../../../../utils/show_dialog.dart';
import '../../../../../utils/theme.dart';

///************** popUpConfirmation **************/
Future<void> popUpConfirmation(BuildContext context,
        {String message = "",
        String titleAction = "Confirm",
        GestureTapCallback? onTapAction,
        String state = "",
        bool isBackToList = true,
        required Overtime data,
        bool isDissible = false}) =>
    showDialog<void>(
      context: context,
      barrierDismissible: isDissible,
      useRootNavigator: false,
      builder: (BuildContext contextDialog) => Consumer2<
              ApproveEmployeeOvertimeFormViewModel,
              ApproveEmployeeOvertimeHRViewModel>(
          builder: (context, provider, providerView, child) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(
              FocusNode(),
            );
          },
          behavior: HitTestBehavior.translucent,
          child: AlertDialog(
              actionsPadding: EdgeInsets.all(mainPadding / 2),
              title: Text(
                "Confirmation",
                style: titleStyle15.copyWith(fontWeight: FontWeight.w600),
              ),
              content: Text(message, style: titleStyle12),
              actions: [
                Row(children: [
                  Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                      onPressed: () async {
                        await provider.updateApproveRequestOvertime(
                            data.id ?? 0, state,
                            context: context);
                        providerView.fetchApproveEmployeeOT();
                        if (provider.status) {
                          if (context.mounted) {
                            showResultDialog(
                                context,
                                state == approveHR
                                    ? 'Successfully of approve employee overtime'
                                    : 'Successfully of reject employee overtime',
                                isBackToList: false);
                          }
                        } else {
                          if (context.mounted) {
                            showResultDialog(
                                context,
                                state == approveHR
                                    ? 'Employee overtime failed to approve. Try again!'
                                    : 'Employee overtime failed to reject. Try again!',
                                isBackToList: false);
                          }
                        }
                      },
                      child: Text(titleAction, style: primary12Bold),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'Close',
                        style: primary12Bold.copyWith(color: redColor),
                      ),
                    ),
                  )
                ])
              ]),
        );
      }),
    );
