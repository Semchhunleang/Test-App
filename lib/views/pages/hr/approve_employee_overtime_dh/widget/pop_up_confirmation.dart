import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/models/hr/overtime/overtime.dart';
import 'package:umgkh_mobile/utils/static_state.dart';
import 'package:umgkh_mobile/view_models/approve_employee_overtime_form_view_model.dart';
import 'package:umgkh_mobile/view_models/approve_employee_overtime_dh_view_model.dart';
import '../../../../../utils/show_dialog.dart';
import '../../../../../utils/theme.dart';
import '../../../../../widgets/textfield.dart';

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
              ApproveEmployeeOvertimeDHViewModel>(
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
              content: SizedBox(
                height: 130,
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        "Worked: ${data.overtimeHours} hours ${data.overtimeMinutes} Minute",
                        style: titleStyle13),
                    Text(
                        "Request: ${data.approvedOvertimeHours} hours ${data.approvedOvertimeMinutes} Minute",
                        style: titleStyle13),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// hour
                          Flexible(
                            child: InputTextField(
                              ctrl: provider.hourCtrl,
                              title: '',
                              hint: 'Approve Hour',
                              suffixText: "Hour",
                              keyboardType: TextInputType.number,
                              maxLength: 2,
                              isValidate: provider.validateHour,
                              validatedText: provider.validateHourText,
                              onChanged: (hour) {
                                provider.onValidateHour(hour);
                              },
                            ),
                          ),
                          widthSpace,

                          // minutes
                          Flexible(
                            child: InputTextField(
                                ctrl: provider.minuteCtrl,
                                focusNode: provider.minuteFocusNode,
                                title: '',
                                maxLength: 2,
                                hint: 'Approve Minute',
                                suffixText: 'Minute',
                                keyboardType: TextInputType.number),
                          )
                        ]),
                  ],
                ),
              ),
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
                                state == approveDH
                                    ? 'Successfully of approve employee overtime'
                                    : 'Successfully of reject employee overtime',
                                isBackToList: false);
                          } else {
                            if (context.mounted) {
                              showResultDialog(
                                  context,
                                  state == approveDH
                                      ? 'Employee overtime failed to approve. Try again!'
                                      : 'Employee overtime failed to reject. Try again!',
                                  isBackToList: false);
                            }
                          }
                        }
                      },
                      child: Text(titleAction, style: primary12Bold),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        provider.resetForm();
                      },
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
