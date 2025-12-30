import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/view_models/timesheet_form_view_model.dart';

///************** popUpFormAndInfo **************/
Future<void> popUpFormAndInfo(BuildContext parentContext,
    {String message = "",
    String title = "",
    String titleAction = "Confirm",
    GestureTapCallback? onTapAction,
    bool isBackToList = true,
    Widget? child,
    bool isAlertFail = false,
    bool isDissible = false}) async {
  return showDialog<void>(
    context: parentContext,
    barrierDismissible: isDissible,
    useRootNavigator: false,
    builder: (BuildContext contextDialog) {
      return GestureDetector(
        onTap: () {
          FocusScope.of(contextDialog).requestFocus(FocusNode(),);
        },
        behavior: HitTestBehavior.translucent,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Dialog(
              insetPadding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (title.isNotEmpty)
                        Text(
                          title,
                          style: titleStyle15.copyWith(
                              fontWeight: FontWeight.w600),
                        ),
                      const SizedBox(height: 10),
                      if (message.isNotEmpty)
                        Text(message, style: titleStyle12),
                      if (child != null) child,
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Consumer<TimesheetFormViewModel>(
                            builder: (context, provider, _) {
                              return TextButton(
                                onPressed: () {
                                  Navigator.of(contextDialog).pop();
                                  provider.resetForm();
                                },
                                child: Text(isAlertFail ? 'OK' : 'Close',
                                    style: primary12Bold.copyWith(
                                        color: redColor),),
                              );
                            },
                          ),
                          if (!isAlertFail)
                            Consumer<TimesheetFormViewModel>(
                              builder: (context, provider, _) {
                                return TextButton(
                                  onPressed: onTapAction,
                                  child:
                                      Text(titleAction, style: primary12Bold),
                                );
                              },
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    },
  );
}
