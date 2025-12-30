import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/view_models/field_service_view_model.dart';
import 'package:umgkh_mobile/view_models/timesheet_form_view_model.dart';

///************** continuePopup **************/
Future<void> continuePopup(BuildContext parentContext,
    {String title = "",
    String titleAction = "Confirm",
    GestureTapCallback? onTapAction,
    bool isBackToList = true,
    Widget? child,
    bool isAlertFail = false,
    int? timesheetId,
    bool isDissible = false}) async {
  return showDialog<void>(
    context: parentContext,
    barrierDismissible: isDissible,
    useRootNavigator: false,
    builder: (BuildContext contextDialog) {
      return GestureDetector(
        onTap: () {
          FocusScope.of(contextDialog).requestFocus(
            FocusNode(),
          );
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
                    children: [
                      if (title.isNotEmpty)
                        Text(
                          title,
                          style: titleStyle15.copyWith(
                              fontWeight: FontWeight.w600),
                        ),
                      const SizedBox(height: 10),
                      Text("You are on Pause!", style: titleStyle13),
                      Text("Do you want to continue?", style: titleStyle13),
                      if (child != null) child,
                      const SizedBox(height: 20),
                      Consumer2<TimesheetFormViewModel, FieldServiceViewModel>(
                          builder: (context, provider, providerFS, _) {
                        return ElevatedButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            await provider.updateContinueTask(
                                context, timesheetId!);
                            await providerFS.fetchDataByData(
                              providerFS.selectedData!.id,
                              'field_service',
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(20),
                            minimumSize: const Size(20, 20),
                          ),
                          child: const FittedBox(
                            child: Text(
                              'Continue\nTask',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      })
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
