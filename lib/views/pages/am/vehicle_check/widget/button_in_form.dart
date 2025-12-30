import 'package:flutter/material.dart';
import 'package:umgkh_mobile/models/am/vehicle_check/row_inout.dart';
import 'package:umgkh_mobile/models/am/vehicle_check/vehicle_check.dart';
import 'package:umgkh_mobile/view_models/check_form_vehicle_check_view_model.dart';
import 'package:umgkh_mobile/view_models/vehicle_check_form_view_model.dart';
import 'package:umgkh_mobile/view_models/vehicle_check_view_model.dart';

import '../../../../../models/am/vehicle_check/row.dart';
import '../../../../../utils/navigator.dart';
import '../../../../../utils/show_dialog.dart';
import '../../../../../utils/static_state.dart';
import '../../../../../utils/theme.dart';
import '../../../../../utils/utlis.dart';
import '../../../../../widgets/button_custom.dart';
import '../show_check_form.dart';
import '../show_check_form_in.dart';
import '../show_check_form_out.dart';
import 'utils_widget.dart';

buildButtonRow({
  required VehicleCheck data,
  required List<Rows> rows,
  required List<RowInout> rowsInout,
  required bool isForm,
  required bool isScan,
  required VehicleCheckViewModel viewModelList,
  required VehicleCheckFormViewModel viewModel,
  required CheckFormVehicleCheckViewModel checkFormView,
  required String kmEnd,
  required BuildContext context,
}) =>
    Row(
      children: [
        if (!isForm && (checkTypeAudit(viewModel)))
          ButtonCustom(
            text: 'Form',
            isExpan: true,
            color: primaryColor,
            onTap: () async {
              final result = await navPush(
                  context,
                  ShowCheckForm(
                    rows: rows,
                    vehicleCheckId: data.id,
                    state: data.state!,
                  ));
              if (result == true) {
                viewModelList.fetchVehicleCheckById(data.id!);
              }
            },
          ),
        if (!isForm && (checkTypeInout(viewModel)))
          ButtonCustom(
            text: 'Form Out ',
            isExpan: true,
            color: primaryColor,
            onTap: () {
              navPush(
                  context,
                  ShowCheckFormOut(
                    rowsInout: rowsInout,
                    vehicleCheckId: data.id,
                    state: data.state!,
                  ));
            },
          ),
        if (checkState(draft, data)) ...[
          widthSpace,
          ButtonCustom(
            text: 'Submit',
            isExpan: true,
            color: stateColor(submit),
            onTap: () {
              bool isAnyCheckInvalid = rows.any((row) {
                bool isCheckInvalid = (row.goodCheck != true &&
                    row.badCheck != true &&
                    row.nonCheck != true);
                return isCheckInvalid;
              });

              bool isAnyCheckInvalidOut = rowsInout.any((row) {
                bool isCheckOutInvalid = (row.goodCheckOut != true &&
                    row.badCheckOut != true &&
                    row.nonCheckOut != true);
                return isCheckOutInvalid;
              });

              if (!viewModel.isValidated(context)) {
                if (checkTypeAudit(viewModel)) {
                  if (!isAnyCheckInvalid && !checkFormView.notCompletedForm) {
                    viewModel
                        .updateVehicleCheck(context, data.id!, submit, true)
                        .then((value) {
                      checkFormView.clearState();
                    });
                  } else {
                    showResultDialog(
                      context,
                      "Submission failed. Please complete in form and saved first before submit.",
                      isBackToList: false,
                    );
                  }
                } else {
                  if (!isAnyCheckInvalidOut &&
                      !checkFormView.notCompletedFormOut) {
                    viewModel
                        .updateVehicleCheck(context, data.id!, submit, true)
                        .then((value) {
                      checkFormView.clearState();
                    });
                  } else {
                    showResultDialog(
                      context,
                      "Submission failed. Please complete in form and saved first before submit.",
                      isBackToList: false,
                    );
                  }
                }
              }
            },
          ),
          widthSpace,
        ],
        if (checkState(draft, data)) ...[
          ButtonCustom(
            text: 'Update',
            isExpan: true,
            onTap: () {
              onUpdate(viewModel, context, isForm, data);
            },
          ),
        ],
        if (checkState(submit, data)) ...[
          widthSpace,
          ButtonCustom(
            text: 'Confirm',
            isExpan: true,
            onTap: () {
              viewModel.updateVehicleCheck(context, data.id!, confirm, true);
            },
          ),
        ],
        if (checkState(confirm, data) &&
            viewModel.isDH(context, data.approver!.id)) ...[
          widthSpace,
          ButtonCustom(
            text: 'Approve',
            isExpan: true,
            onTap: () {
              viewModel.updateVehicleCheck(context, data.id!, approve, true);
            },
          ),
          widthSpace,
          ButtonCustom(
            text: 'Reject',
            color: redColor,
            isExpan: true,
            onTap: () {
              viewModel.updateVehicleCheck(context, data.id!, reject, true);
            },
          ),
        ],
        if (checkState(approve, data) &&
            viewModel.isRequestor(context, data.requestor!.id) &&
            !isScan &&
            checkTypeInout(viewModel)) ...[
          widthSpace,
          ButtonCustom(
            text: 'Show QR',
            isExpan: true,
            onTap: () {
              showQRCode(context, data.id!, data.requestor!.name, "");
            },
          ),
        ],
        if (checkState(approve, data) &&
            isScan &&
            checkTypeInout(viewModel)) ...[
          widthSpace,
          ButtonCustom(
            text: 'On Progress',
            isExpan: true,
            onTap: () {
              viewModel.updateVehicleCheck(context, data.id!, onProgress, true);
            },
          ),
        ],
        if (checkState(approve, data) &&
            (checkTypeAudit(viewModel)) &&
            viewModel.isDH(context, data.approver!.id)) ...[
          widthSpace,
          ButtonCustom(
            text: 'Done',
            isExpan: true,
            onTap: () {
              viewModel.updateVehicleCheck(context, data.id!, done, true);
            },
          ),
        ],
        if (checkState(onProgress, data)) ...[
          if (checkTypeInout(viewModel)) ...[
            widthSpace,
            ButtonCustom(
              text: 'Form In ',
              isExpan: true,
              color: primaryColor,
              onTap: () {
                navPush(
                    context,
                    ShowCheckFormIn(
                      rowsInout: rowsInout,
                      state: data.state!,
                      vehicleCheckId: data.id,
                    ));
              },
            ),
            widthSpace,
          ],
          if (viewModel.isRequestor(context, data.requestor!.id) &&
              !isScan) ...[
            ButtonCustom(
              text: 'Show QR',
              isExpan: true,
              onTap: () {
                bool isAnyCheckInvalidIn = rowsInout.any((row) {
                  return (row.goodCheckIn == false &&
                      row.badCheckIn == false &&
                      row.nonCheckIn == false);
                });
                if (!viewModel.isValidatedKmEnd(context)) {
                  if (!isAnyCheckInvalidIn &&
                      !checkFormView.notCompletedFormIn) {
                    viewModel.kmEndStoreCtrl.text = viewModel.kmEndCtrl.text;
                    showQRCode(context, data.id!, data.requestor!.name,
                        viewModel.kmEndStoreCtrl.text);
                  } else {
                    showResultDialog(
                      context,
                      "QR show failed. Please complete in Form In and saved first",
                      isBackToList: false,
                    );
                  }
                }
              },
            ),
          ]
        ],
        if (checkState(onProgress, data) && isScan) ...[
          ButtonCustom(
            text: 'Done',
            isExpan: true,
            onTap: () {
              viewModel.kmEndCtrl.text = kmEnd;
              viewModel.updateVehicleCheck(context, data.id!, done, true);
            },
          ),
        ],
        if (checkState(done, data) && checkTypeInout(viewModel)) ...[
          widthSpace,
          ButtonCustom(
            text: 'Form In ',
            isExpan: true,
            color: primaryColor,
            onTap: () {
              navPush(
                  context,
                  ShowCheckFormIn(
                    rowsInout: rowsInout,
                    state: data.state!,
                    vehicleCheckId: data.id,
                  ));
            },
          ),
          widthSpace,
        ],
      ],
    );

bool checkState(String state, VehicleCheck data) => data.state == state;
onUpdate(VehicleCheckFormViewModel p, BuildContext context, bool isForm,
    VehicleCheck data) {
  if (!p.isValidated(context)) {
    p.updateVehicleCheck(context, data.id!, draft, true);
  }
}

bool checkTypeAudit(VehicleCheckFormViewModel p) =>
    (p.selectedCheckType == "audit" || p.selectedCheckType == "check");
bool checkTypeInout(VehicleCheckFormViewModel p) =>
    (p.selectedCheckType == "inout" || p.selectedCheckType == "borrow");
