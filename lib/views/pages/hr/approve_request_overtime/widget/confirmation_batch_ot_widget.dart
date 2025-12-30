import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/utils/static_state.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/view_models/approve_request_overtime_form_view_model.dart';
import 'package:umgkh_mobile/view_models/approve_request_overtime_view_model.dart';

///************** popUpConfirmation **************/
Future<void> popUpConfirmation(BuildContext context,
        {String message = "",
        String titleAction = "Confirm",
        GestureTapCallback? onTapAction,
        String state = "",
        bool isBackToList = true,
        bool isDissible = false}) =>
    showDialog<void>(
      context: context,
      barrierDismissible: isDissible,
      useRootNavigator: false,
      builder: (BuildContext contextDialog) => Consumer2<
              ApproveRequestOvertimeFormViewModel,
              ApproveRequestOvertimeViewModel>(
          builder: (context, provider, providerView, child) {
        return Stack(
          children: [
            GestureDetector(
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
                    height: 60,
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            state == reject
                                ? "Are you sure you want to reject these request overtime?"
                                : "Are you sure you want to approve these request overtime?",
                            style: titleStyle13),
                      ],
                    ),
                  ),
                  actions: [
                    Row(
                      children: [
                        Align(
                          alignment: Alignment.bottomRight,
                          child: TextButton(
                            onPressed: providerView.isLoadingBatch
                                ? () {}
                                : () async {
                                    final parentContext =
                                        Navigator.of(context).context;
                                    Navigator.of(context).pop();
                                    await providerView
                                        .batchApproveRequestOvertime(
                                            providerView.selectedRequests
                                                .toList(),
                                            state,
                                            context: parentContext);
                                    providerView.fetchApproveRequestOT();
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
            ),
            if (providerView.isLoadingBatch)
              const Center(child: CircularProgressIndicator())
          ],
        );
      }),
    );
