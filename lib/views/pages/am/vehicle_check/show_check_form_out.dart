import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/models/am/vehicle_check/row_inout.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/widgets/custom_scaffold.dart';
import 'package:umgkh_mobile/widgets/float_bt.dart';
import 'package:umgkh_mobile/widgets/textfield.dart';
import '../../../../utils/show_dialog.dart';
import '../../../../view_models/check_form_vehicle_check_view_model.dart';
import '../../../../view_models/vehicle_check_view_model.dart';
import 'widget/ratio_check_form_widget.dart';

class ShowCheckFormOut extends StatefulWidget {
  final List<RowInout>? rowsInout;
  final int? vehicleCheckId;
  final String state;
  const ShowCheckFormOut(
      {super.key, this.rowsInout, this.vehicleCheckId, this.state = ""});

  @override
  State<ShowCheckFormOut> createState() => _ShowCheckFormInState();
}

class _ShowCheckFormInState extends State<ShowCheckFormOut> {
  @override
  void initState() {
    final checkFormViewModel =
        Provider.of<CheckFormVehicleCheckViewModel>(context, listen: false);
    checkFormViewModel.initializeCheckValuesInout(widget.rowsInout!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<CheckFormVehicleCheckViewModel, VehicleCheckViewModel>(
        builder: (context, viewModel, viewVehicleCheck, _) {
      return CustomScaffold(
        title: "Check Form",
        resizeToAvoidBottomInset: true,
        backAction: () {
          if ((viewModel.rowIdsInout.length != widget.rowsInout!.length) &&
              viewModel.isSubmitted) {
            viewModel.rowIdsInout.clear();
            viewModel.isSubmitted = false;
          }
          Navigator.pop(context);
        },
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: mainPadding),
          child: ListView.builder(
            padding: EdgeInsets.only(bottom: mainPadding * 5.5),
            itemCount: widget.rowsInout?.length ?? 0,
            itemBuilder: (context, index) {
              final row = widget.rowsInout![index];
              final isRemarkRequired =
                  (viewModel.selectedCheckValuesOut[index] == 'badOut' ||
                      viewModel.selectedCheckValuesOut[index] == 'nonOut');
              return Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(mainRadius)),
                color: primaryColor.withOpacity(0.1),
                margin: EdgeInsets.symmetric(vertical: mainPadding / 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: EdgeInsets.fromLTRB(
                            mainPadding, mainPadding, mainPadding, 0),
                        child: Text.rich(TextSpan(children: [
                          TextSpan(text: "${index + 1}.", style: primary13Bold),
                          TextSpan(
                              text: row.question?.name ?? 'No question',
                              style: titleStyle12.copyWith(
                                  fontWeight: FontWeight.bold))
                        ]),),),
                    Row(children: [
                      RatioCheckFormWidget(
                          selectedValue:
                              viewModel.selectedCheckValuesOut[index] ?? '',
                          value: 'goodOut',
                          label: "Good Out",
                          onChanged: !disableSelectByState(widget.state)
                              ? (value) {
                                  _updateRowSelection(viewModel, row, index,
                                      value!, widget.rowsInout![index].id!);
                                }
                              : null),
                      RatioCheckFormWidget(
                          selectedValue:
                              viewModel.selectedCheckValuesOut[index] ?? '',
                          value: 'badOut',
                          label: "Bad Out",
                          onChanged: !disableSelectByState(widget.state)
                              ? (value) {
                                  _updateRowSelection(viewModel, row, index,
                                      value!, widget.rowsInout![index].id!);
                                }
                              : null),
                      RatioCheckFormWidget(
                          selectedValue:
                              viewModel.selectedCheckValuesOut[index] ?? '',
                          value: 'nonOut',
                          label: "Non Out",
                          onChanged: !disableSelectByState(widget.state)
                              ? (value) {
                                  _updateRowSelection(viewModel, row, index,
                                      value!, widget.rowsInout![index].id!);
                                }
                              : null)
                    ]),
                    isRemarkRequired &&
                            (!disableSelectByState(widget.state) ||
                                disableSelectByState(widget.state))
                        ? Padding(
                            padding: EdgeInsets.fromLTRB(
                                mainPadding, 0, mainPadding, mainPadding / 1.5),
                            child: MutliLineTextField(
                                ctrl: viewModel.remarkOutControllers[index],
                                title: 'Remark Out',
                                hint: 'Enter remark out',
                                minLine: 1,
                                maxLine: 20,
                                enableSelectText:
                                    !disableSelectByState(widget.state),
                                readOnlyAndFilled:
                                    disableSelectByState(widget.state),
                                readOnly: disableSelectByState(widget.state),
                                isValidate: isRemarkRequired &&
                                    (viewModel.remarkOutControllers[index].text
                                        .isEmpty) &&
                                    !disableSelectByState(widget.state),
                                onChanged: (text) =>
                                    viewModel.updateCheckValueOut(
                                        index,
                                        viewModel.selectedCheckValuesOut[index],
                                        row.id!),),)
                        : sizedBoxShrink,
                    heith5Space,
                  ],
                ),
              );
            },
          ),
        ),
        floatingBt: !disableSelectByState(widget.state)
            ? DefaultFloatButton(
                onTap: () async {
                  viewModel.rowIdsInout = List.from(viewModel.rowIdsLocalInout);
                  bool allRemarksValid = true;
                  bool isSelectedAllRows = true;
                  for (int index = 0;
                      index < widget.rowsInout!.length;
                      index++) {
                    final selectedValue =
                        viewModel.selectedCheckValuesOut[index];
                    final remarkController =
                        viewModel.remarkOutControllers[index];
                    final row = widget.rowsInout![index];

                    if ((selectedValue == 'badOut' ||
                            selectedValue == 'nonOut') &&
                        remarkController.text.isEmpty) {
                      allRemarksValid = false;
                      viewModel.notCompletedForm = allRemarksValid;
                      break;
                    }
                    if (row.goodCheckOut != false ||
                        row.badCheckOut != false ||
                        row.nonCheckOut != false) {
                      if (!viewModel.rowIdsLocalInout.contains(row.id!)) {
                        viewModel.rowIdsLocalInout.add(row.id!);
                      }
                      viewModel.updateCheckValueOut(
                          index, selectedValue, row.id!);
                    }

                    if (selectedValue == null) {
                      isSelectedAllRows = false;
                    }
                  }
                  if (isSelectedAllRows && allRemarksValid) {
                    await viewModel
                        .updateRowsByIdInout(context, widget.vehicleCheckId!)
                        .then((value) async {
                      if (value) {
                        viewModel.isSubmitted = true;
                        viewModel.notCompletedFormOut = false;
                        viewVehicleCheck
                            .fetchVehicleCheckById(widget.vehicleCheckId!);
                      }
                    });
                  } else {
                    showResultDialog(
                      context,
                      "Submission failed. Please complete your form first.",
                      isBackToList: false,
                    );
                  }
                },
                icon: Icons.save_rounded)
            : null,
      );
    });
  }

  void _updateRowSelection(CheckFormVehicleCheckViewModel viewModel,
      RowInout row, int index, String value, int id) {
    if (!viewModel.rowIdsLocalInout.contains(row.id!)) {
      viewModel.rowIdsLocalInout.add(row.id!);
    }
    viewModel.updateCheckValueOut(index, value, id);
  }

  bool disableSelectByState(String state) {
    if (state == "submit" ||
        state == "approve" ||
        state == "on_progress" ||
        state == "confirm" ||
        state == "done" ||
        state == "reject") {
      return true;
    } else {
      return false;
    }
  }
}
