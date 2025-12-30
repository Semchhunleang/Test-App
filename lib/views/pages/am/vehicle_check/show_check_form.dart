import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/widgets/custom_scaffold.dart';
import 'package:umgkh_mobile/widgets/float_bt.dart';
import 'package:umgkh_mobile/widgets/textfield.dart';
import '../../../../models/am/vehicle_check/row.dart';
import '../../../../utils/show_dialog.dart';
import '../../../../view_models/check_form_vehicle_check_view_model.dart';
import '../../../../view_models/vehicle_check_view_model.dart';
import 'widget/ratio_check_form_widget.dart';

class ShowCheckForm extends StatefulWidget {
  final List<Rows>? rows;
  final int? vehicleCheckId;
  final String state;
  const ShowCheckForm(
      {super.key, this.rows, this.vehicleCheckId, this.state = ""});

  @override
  State<ShowCheckForm> createState() => _ShowCheckFormState();
}

class _ShowCheckFormState extends State<ShowCheckForm> {
  @override
  void initState() {
    final checkFormViewModel =
        Provider.of<CheckFormVehicleCheckViewModel>(context, listen: false);
    checkFormViewModel.initializeCheckValues(widget.rows!);
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
          if ((viewModel.rowIds.length != widget.rows!.length) &&
              viewModel.isSubmitted) {
            viewModel.rowIds.clear();
            viewModel.isSubmitted = false;
          }
          Navigator.pop(context);
        },
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: mainPadding),
          child: ListView.builder(
            padding: EdgeInsets.only(bottom: mainPadding * 5.5),
            itemCount: widget.rows?.length ?? 0,
            itemBuilder: (context, index) {
              final row = widget.rows![index];
              final isRemarkRequired =
                  (viewModel.selectedCheckValues[index] == 'bad' ||
                      viewModel.selectedCheckValues[index] == 'non');

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
                    Row(
                      children: [
                        RatioCheckFormWidget(
                            selectedValue:
                                viewModel.selectedCheckValues[index] ?? '',
                            value: 'good',
                            label: "Good",
                            onChanged: !disableSelectByState(widget.state)
                                ? (value) {
                                    _updateRowSelection(viewModel, row, index,
                                        value!, widget.rows![index].id!);
                                  }
                                : null),
                        RatioCheckFormWidget(
                            selectedValue:
                                viewModel.selectedCheckValues[index] ?? '',
                            value: 'bad',
                            label: "Bad",
                            onChanged: !disableSelectByState(widget.state)
                                ? (value) {
                                    _updateRowSelection(viewModel, row, index,
                                        value!, widget.rows![index].id!);
                                  }
                                : null),
                        RatioCheckFormWidget(
                            selectedValue:
                                viewModel.selectedCheckValues[index] ?? '',
                            value: 'non',
                            label: "Non",
                            onChanged: !disableSelectByState(widget.state)
                                ? (value) {
                                    _updateRowSelection(viewModel, row, index,
                                        value!, widget.rows![index].id!);
                                  }
                                : null),
                      ],
                    ),
                    isRemarkRequired &&
                            (!disableSelectByState(widget.state) ||
                                disableSelectByState(widget.state))
                        ? Padding(
                            padding: EdgeInsets.fromLTRB(
                                mainPadding, 0, mainPadding, mainPadding / 1.5),
                            child: MutliLineTextField(
                                ctrl: viewModel.remarkControllers[index],
                                title: 'Remark',
                                hint: 'Enter remark',
                                minLine: 1,
                                maxLine: 20,
                                enableSelectText:
                                    !disableSelectByState(widget.state),
                                readOnlyAndFilled:
                                    disableSelectByState(widget.state),
                                readOnly: disableSelectByState(widget.state),
                                isValidate: isRemarkRequired &&
                                    (viewModel.remarkControllers[index].text
                                        .isEmpty) &&
                                    !disableSelectByState(widget.state),
                                onChanged: (text) => viewModel.updateCheckValue(
                                    index,
                                    viewModel.selectedCheckValues[index],
                                    row.id!),),)
                        : sizedBoxShrink,
                  ],
                ),
              );
            },
          ),
        ),
        floatingBt: !disableSelectByState(widget.state)
            ? DefaultFloatButton(
                onTap: () async {
                  viewModel.rowIds = List.from(viewModel.rowIdsLocal);
                  bool allRemarksValid = true;
                  bool isSelectedAllRows = true;
                  for (int index = 0; index < widget.rows!.length; index++) {
                    final selectedValue = viewModel.selectedCheckValues[index];
                    final remarkController = viewModel.remarkControllers[index];

                    final row = widget.rows![index];

                    if ((selectedValue == 'bad' || selectedValue == 'non') &&
                        remarkController.text.isEmpty) {
                      allRemarksValid = false;
                      viewModel.notCompletedForm = true;
                      break;
                    }

                    if (row.goodCheck != false ||
                        row.badCheck != false ||
                        row.nonCheck != false) {
                      if (!viewModel.rowIdsLocal.contains(row.id!)) {
                        viewModel.rowIdsLocal.add(row.id!);
                      }
                      viewModel.updateCheckValue(index, selectedValue, row.id!);
                    }

                    if (selectedValue == null) {
                      isSelectedAllRows = false;
                    }
                  }

                  if (isSelectedAllRows && allRemarksValid) {
                    await viewModel
                        .updateRowsById(context, widget.vehicleCheckId!)
                        .then((value) async {
                      if (value) {
                        viewModel.isSubmitted = true;
                        viewModel.notCompletedForm = false;
                        await viewVehicleCheck
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

  void _updateRowSelection(CheckFormVehicleCheckViewModel viewModel, Rows row,
      int index, String value, int id) {
    if (!viewModel.rowIdsLocal.contains(row.id!)) {
      viewModel.rowIdsLocal.add(row.id!);
    }
    viewModel.updateCheckValue(index, value, id);
  }

  bool disableSelectByState(String state) {
    if (state == "submit" ||
        state == "approve" ||
        state == "confirm" ||
        state == "done" ||
        state == "reject") {
      return true;
    } else {
      return false;
    }
  }
}
