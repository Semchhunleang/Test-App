import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/models/service-project_task/job_assign_line/job_assign_line.dart';
import 'package:umgkh_mobile/services/local_storage/models/offline_actions_local_storage_service.dart';
import 'package:umgkh_mobile/utils/show_dialog.dart';
import 'package:umgkh_mobile/utils/static_state.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/view_models/field_service_form_view_model.dart';
import 'package:umgkh_mobile/view_models/field_service_view_model.dart';
import 'package:umgkh_mobile/widgets/textfield.dart';

///************** popUpConfirmation **************/
Future<void> popUpReason(BuildContext parentContext,
        {String message = "",
        String titleAction = "Confirm",
        GestureTapCallback? onTapAction,
        String state = "",
        bool isBackToList = true,
        required JobAssignLine jobAssignLine,
        bool isDissible = false}) =>
    showDialog<void>(
      context: parentContext,
      barrierDismissible: isDissible,
      useRootNavigator: false,
      builder: (BuildContext contextDialog) =>
          Consumer2<FieldServiceFormViewModel, FieldServiceViewModel>(
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
              title: state != reject
                  ? Text(
                      "Confirmation",
                      style: titleStyle15.copyWith(fontWeight: FontWeight.w600),
                    )
                  : null,
              content: state != reject
                  ? Text(message, style: titleStyle12)
                  : SizedBox(
                      height: 140,
                      width: double.infinity,
                      child: MutliLineTextField(
                        ctrl: provider.reason,
                        title: 'Reason',
                        isValidate: provider.validateReason,
                        validatedText: provider.validateText,
                        onChanged: (reason) {
                          provider.onValidateReason(reason);
                        },
                      ),
                    ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
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
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                        onPressed: !provider.isLoading
                            ? () async {
                                if (state == reject) {
                                  provider
                                      .onValidateReason(provider.reason.text);
                                }
                                if (!provider.validateReason ||
                                    state == accept) {
                                  Navigator.pop(context);
                                }
                                final mainContext =
                                    Navigator.of(context).context;
                                if (!provider.validateReason) {
                                  await provider.updateStateJobAssign(
                                      jobAssignLine.id!,
                                      state,
                                      jobAssignLine,
                                      DateTime.now().toIso8601String(),
                                      reason: provider.reason.text);
                                  providerView.fetchDataByData(
                                      providerView.selectedData!.id,
                                      'field_service');
                                  await OfflineActionStorageService()
                                      .saveOfflineAction(
                                    'job.assign.line',
                                    jobAssignLine.id!,
                                    'update',
                                    jsonEncode({
                                      "state": state,
                                      "datetime":
                                          DateTime.now().toIso8601String(),
                                    }),
                                  );
                                  SchedulerBinding.instance
                                      .addPostFrameCallback((_) async {
                                    if (provider.status) {
                                      if (state == accept) {
                                        // await FieldServiceViewModel().checkUpdateStage(providerView.selectedData!);
                                        providerView
                                            .onUpdateStageFieldServiceLocal(
                                                providerView.selectedData!.id,
                                                data:
                                                    providerView.selectedData);
                                        providerView.onUpdateStageFieldService(
                                            providerView.selectedData!.id,
                                            data: providerView.selectedData);
                                      }
                                      if (mainContext.mounted) {
                                        showResultDialog(
                                            mainContext,
                                            state == reject
                                                ? 'Successfully of reject job assign'
                                                : 'Successfully of accept job assign',
                                            isBackToList: false,
                                            isDone: true);
                                      }
                                    } else {
                                      showResultDialog(
                                          mainContext,
                                          state == reject
                                              ? 'Failed to update job assign. Please try again!'
                                              : 'Failed to update job assign. Please try again!',
                                          isBackToList: false);
                                    }
                                  });
                                }
                              }
                            : null,
                        child: Text(titleAction, style: primary12Bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
