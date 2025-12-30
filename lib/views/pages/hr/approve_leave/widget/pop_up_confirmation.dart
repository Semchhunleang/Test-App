import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/models/hr/leave/leave.dart';
import 'package:umgkh_mobile/view_models/approve_leave_view_model.dart';
// import 'package:umgkh_mobile/view_models/approve_employee_overtime_form_view_model.dart';
// import 'package:umgkh_mobile/view_models/approve_employee_overtime_dh_view_model.dart';
// import '../../../../../utils/show_dialog.dart';
import '../../../../../utils/theme.dart';

///************** popUpConfirmation **************/
Future<void> popUpConfirmation(BuildContext context,
        {String message = "",
        String titleAction = "Confirm",
        GestureTapCallback? onTapAction,
        String state = "",
        bool isBackToList = true,
        required Leave data,
        bool isDissible = false}) =>
    showDialog<void>(
      context: context,
      barrierDismissible: isDissible,
      useRootNavigator: false,
      builder: (BuildContext contextDialog) =>
          Consumer<ApproveLeaveViewModel>(builder: (context, provider, child) {
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
                        await provider.updateLeaveStatus(
                            context, state, data.id);
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
