import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/models/hr/request_overtime/request_overtime.dart';
import 'package:umgkh_mobile/utils/static_state.dart';
import 'package:umgkh_mobile/view_models/approve_request_overtime_view_model.dart';
import '../../../../../utils/show_dialog.dart';
import '../../../../../utils/theme.dart';
import '../../../../../view_models/approve_request_overtime_form_view_model.dart';
import '../../../../../widgets/textfield.dart';

///************** popUpConfirmation **************/
Future<void> popUpConfirmation(BuildContext context,
        {String message = "",
        String titleAction = "Confirm",
        GestureTapCallback? onTapAction,
        String state = "",
        bool isBackToList = true,
        required RequestOvertime requestOvertimeList,
        bool isDissible = false}) =>
    showDialog<void>(
      context: context,
      barrierDismissible: isDissible,
      useRootNavigator: false,
      builder: (BuildContext contextDialog) => Consumer2<
              ApproveRequestOvertimeFormViewModel,
              ApproveRequestOvertimeViewModel>(
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
              content: state == reject
                  ? Text(message, style: titleStyle12)
                  : SizedBox(
                      height: 130,
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              "Request: ${requestOvertimeList.overtimeHours} hours ${requestOvertimeList.overtimeMinutes} Minute",
                              style: titleStyle13),
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// hour
                                Flexible(
                                  child: InputTextField(
                                    ctrl: provider.hourCtrl,
                                    title: '',
                                    hint: 'DH Approve Hour',
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

                                /// minutes
                                Flexible(
                                  child: InputTextField(
                                      ctrl: provider.minuteCtrl,
                                      focusNode: provider.minuteFocusNode,
                                      title: '',
                                      maxLength: 2,
                                      hint: 'DH Approve Minute',
                                      suffixText: 'Minute',
                                      keyboardType: TextInputType.number),
                                )
                              ]),
                        ],
                      ),
                    ),
              actions: [
                Row(
                  children: [
                    Align(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                        onPressed: () async {
                          if (!provider.validateHour) {
                            Navigator.of(context).pop();
                            await provider.updateApproveRequestOvertime(
                                requestOvertimeList.id, state,
                                context: context);
                            providerView.fetchApproveRequestOT();
                            if (!provider.isLoading) {
                              if (provider.status) {
                                if (context.mounted) {
                                  await showResultDialog(
                                      contextDialog,
                                      state == approveDH
                                          ? 'Successfully of approve request overtime'
                                          : 'Successfully of reject request overtime',
                                      isBackToList: false);
                                }
                              } else {
                                if (context.mounted) {
                                  await showResultDialog(
                                      contextDialog,
                                      state == approveDH
                                          ? 'Request overtime failed to approve. Try again!'
                                          : 'Request overtime failed to reject. Try again!',
                                      isBackToList: false);
                                }
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
                  ],
                ),
              ]),
        );
      }),
    );
