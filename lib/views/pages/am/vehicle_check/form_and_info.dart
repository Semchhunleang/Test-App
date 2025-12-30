import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/models/am/vehicle_check/vehicle_check.dart';
import 'package:umgkh_mobile/utils/static_state.dart';
import 'package:umgkh_mobile/view_models/vehicle_check_form_view_model.dart';
import 'package:umgkh_mobile/widgets/custom_scaffold.dart';
import '../../../../utils/theme.dart';
import '../../../../utils/utlis.dart';
import '../../../../view_models/check_form_vehicle_check_view_model.dart';
import '../../../../view_models/profile_view_model.dart';
import '../../../../view_models/vehicle_check_view_model.dart';
import '../../../../widgets/button_custom.dart';
import '../../../../widgets/custom_selected_date.dart';
import '../../../../widgets/custom_state_bar.dart';
import '../../../../widgets/textfield.dart';
import 'widget/button_in_form.dart';
import 'widget/utils_widget.dart';

class VehicleCheckFormInfoPage extends StatefulWidget {
  final bool isForm, isScan;
  final VehicleCheck? data;
  final String kmEnd;
  const VehicleCheckFormInfoPage(
      {super.key,
      this.isForm = false,
      this.data,
      this.isScan = false,
      this.kmEnd = ''});

  @override
  State<VehicleCheckFormInfoPage> createState() =>
      _VehicleCheckFormInfoPageState();
}

class _VehicleCheckFormInfoPageState extends State<VehicleCheckFormInfoPage> {
  @override
  void initState() {
    super.initState();
    final p = Provider.of<VehicleCheckFormViewModel>(context, listen: false);
    final profile = Provider.of<ProfileViewModel>(context, listen: false);
    if (widget.isForm) {
      p.resetFormCreate(context, profile);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      p.resetValidate();
      p.resetForm(context, profile);
      if (!widget.isScan) {
        p.resetKmEnd();
      }
      if (notNullData()) p.checkReadOnly(widget.data!.state!);
      if (notNullData()) p.checkReadOnlyChecker(widget.data!.state!);
      if (!widget.isForm && widget.data != null) p.setInfo(widget.data!);

      final provider =
          Provider.of<VehicleCheckViewModel>(context, listen: false);
      if (widget.data != null) {
        provider.fetchVehicleCheckById(widget.data!.id!).then((_) {
          if (!mounted) return;
        }).catchError((error) {
          if (!mounted) return;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<VehicleCheckFormViewModel, VehicleCheckViewModel,
            CheckFormVehicleCheckViewModel>(
        builder: (context, viewModel, viewModelList, checkFormView, _) {
      return CustomScaffold(
          title: widget.isForm ? 'Vehicle Check Form' : 'Vehicle Check Info',
          resizeToAvoidBottomInset: true,
          isLoading: viewModel.isLoading,
          body: Column(
            children: [
              if (!widget.isForm && widget.data != null) ...[
                CustomStateBar(
                  text: stateTitleA4(widget.data!.state).toUpperCase(),
                  color: stateColor(widget.data!.state),
                ),
                heith10Space,
              ],
              Expanded(
                  child: Padding(
                padding: EdgeInsets.symmetric(horizontal: mainPadding),
                child: ListView(
                  physics: kBounce,
                  children: [
                    if (viewModel.selectedCheckType == "audit" ||
                        viewModel.selectedCheckType == "check") ...[
                      CustomSelectDate(
                          ctrl: viewModel.auditDateTimeCtrl,
                          title: 'Audit DT',
                          readOnlyAndFilled: viewModel.isReadOnly,
                          onTap: viewModel.isReadOnly
                              ? null
                              : () =>
                                  viewModel.selectDateTime(context, 'audit')),
                      heith10Space,
                    ],
                    if (viewModel.selectedCheckType == "inout" ||
                        viewModel.selectedCheckType == "borrow") ...[
                      labelSelectDateTimeInout(
                          "Planned DT Out", "Planned DT In"),
                      Row(
                        children: [
                          Expanded(
                            child: CustomSelectDate(
                                ctrl: viewModel.plannedDateTimeOutCtrl,
                                title: '',
                                readOnlyAndFilled: viewModel.isReadOnly,
                                onTap: viewModel.isReadOnly
                                    ? null
                                    : () => viewModel.selectDateTime(
                                        context, 'plannedOut',
                                        data: widget.data)),
                          ),
                          widthSpace,
                          Expanded(
                            child: CustomSelectDate(
                                ctrl: viewModel.plannedDateTimeInCtrl,
                                title: '',
                                readOnlyAndFilled: viewModel.isReadOnly,
                                onTap: viewModel.isReadOnly
                                    ? null
                                    : () => viewModel.selectDateTime(
                                        context, 'plannedIn',
                                        data: widget.data)),
                          ),
                        ],
                      ),
                      heith10Space,
                      if (viewModel.actualDateTimeOutCtrl.text != "" &&
                          viewModel.actualDateTimeInCtrl.text != "") ...[
                        labelSelectDateTimeInout(
                            "Actual DT Out", "Actual DT In"),
                        Row(
                          children: [
                            Expanded(
                              child: CustomSelectDate(
                                ctrl: viewModel.actualDateTimeOutCtrl,
                                title: '',
                                readOnlyAndFilled: viewModel.isReadOnly,
                              ),
                            ),
                            widthSpace,
                            Expanded(
                              child: CustomSelectDate(
                                ctrl: viewModel.actualDateTimeInCtrl,
                                title: '',
                                readOnlyAndFilled: viewModel.isReadOnly,
                              ),
                            ),
                          ],
                        ),
                        heith10Space,
                      ],
                      if (viewModel.actualDateTimeOutCtrl.text != "" &&
                          viewModel.actualDateTimeInCtrl.text == "") ...[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 0, 5),
                          child: Text(
                            "Actual DT Out",
                            style: titleStyle13,
                          ),
                        ),
                        CustomSelectDate(
                          ctrl: viewModel.actualDateTimeOutCtrl,
                          title: '',
                          readOnlyAndFilled: viewModel.isReadOnly,
                        ),
                        heith10Space,
                      ],
                    ],
                    checkTypeSelection(
                        readOnlyAndFilled: viewModel.isReadOnly,
                        enabled: !viewModel.isReadOnly,
                        isValidate: viewModel.isCheckType,
                        selected: viewModel.selectedCheckType,
                        onValue: viewModel.onCheckTypeChanged),
                    heith10Space,
                    selectFleetVehicle(
                      enabled: !viewModel.isReadOnly,
                      isValidate: viewModel.isFleetVehicle,
                      titleHead: "Fleet Vehicle",
                      selected: viewModel.selectFleetVehicle,
                      readOnlyAndFilled: viewModel.isReadOnly,
                      onChanged: (value) {
                        viewModel.onChangeFleetVehicle(value, context);
                      },
                    ),
                    heith10Space,
                    InputTextField(
                        ctrl: viewModel.departmentCtrl,
                        title: 'Department',
                        enableSelectText: false,
                        readOnly: true,
                        readOnlyAndFilled: true),
                    heith10Space,
                    Flex(direction: Axis.horizontal, children: [
                      Expanded(
                          child: InputTextField(
                              ctrl: viewModel.requestorCtrl,
                              title: 'Requestor',
                              enableSelectText: false,
                              readOnly: true,
                              readOnlyAndFilled: true)),
                      widthSpace,
                      Expanded(
                          child: InputTextField(
                              ctrl: viewModel.approverCtrl,
                              title: 'Approver',
                              enableSelectText: false,
                              readOnly: true,
                              readOnlyAndFilled: true))
                    ]),
                    heith10Space,
                    selectEmployees(
                      enabled: !viewModel.isReadOnlyChecker,
                      readOnlyAndFilled: viewModel.isReadOnlyChecker,
                      titleHead: "Checker",
                      selected: viewModel.selectedChecker,
                      onChanged: (value) {
                        viewModel.onChangeChecker(value, context);
                      },
                    ),
                    heith10Space,
                    if (viewModel.selectedCheckType == "audit" ||
                        viewModel.selectedCheckType == "check") ...[
                      InputTextField(
                        ctrl: viewModel.kmCurrentCtrl,
                        title: 'KM Current',
                        hint: "Enter km current",
                        keyboardType: TextInputType.number,
                        enableSelectText: false,
                        readOnly: viewModel.isReadOnly,
                        isValidate: viewModel.isKmCurrent,
                        readOnlyAndFilled: viewModel.isReadOnly,
                        validatedText:
                            viewModel.isKmCurrent ? 'KM Current Required' : '',
                        onChanged: viewModel.onChangeKmCurrent,
                      ),
                      heith10Space,
                    ],
                    if (viewModel.selectedCheckType == "inout" ||
                        viewModel.selectedCheckType == "borrow") ...[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: InputTextField(
                              ctrl: viewModel.kmStartCtrl,
                              title: 'KM Start',
                              hint: "Enter km start",
                              enableSelectText: false,
                              readOnly: viewModel.isReadOnly,
                              isValidate: viewModel.isKmStart,
                              readOnlyAndFilled: viewModel.isReadOnly,
                              keyboardType: TextInputType.number,
                              validatedText: viewModel.isKmStart
                                  ? 'KM Start Required'
                                  : '',
                              onChanged: viewModel.onChangeKmStart,
                            ),
                          ),
                          widthSpace,
                          Expanded(
                            child: InputTextField(
                              ctrl: widget.kmEnd.isNotEmpty
                                  ? TextEditingController(text: widget.kmEnd)
                                  : viewModel.kmEndCtrl,
                              title: 'KM End',
                              hint: "Enter km end",
                              isValidate: viewModel.isKmEnd,
                              keyboardType: TextInputType.number,
                              readOnly: viewModel.isReadOnly &&
                                      widget.data != null &&
                                      widget.data!.state != onProgress ||
                                  widget.isScan,
                              validatedText: viewModel.isKmEnd
                                  ? 'KM End Required and should more than KM Start'
                                  : '',
                              readOnlyAndFilled: viewModel.isReadOnly &&
                                      widget.data != null &&
                                      widget.data!.state != onProgress ||
                                  widget.isScan,
                              enableSelectText: false,
                              onChanged: viewModel.onChangeKmEnd,
                            ),
                          ),
                        ],
                      ),
                      heith10Space,
                    ],
                    selectState(
                      enabled: !viewModel.isReadOnly,
                      readOnlyAndFilled: viewModel.isReadOnly,
                      titleHead: "City",
                      selected: viewModel.selectedState,
                      onChanged: (value) {
                        viewModel.onChangeState(value, context);
                      },
                    ),
                    heith10Space,
                    MutliLineTextField(
                        ctrl: viewModel.purposeCtrl,
                        title: 'Purpose',
                        hint: 'Enter purpose',
                        isValidate: viewModel.isPurpose,
                        readOnlyAndFilled: viewModel.isReadOnly,
                        readOnly: viewModel.isReadOnly,
                        validatedText:
                            viewModel.isPurpose ? 'Purpose Required' : '',
                        onChanged: viewModel.onChangePurpose),
                    ...multiheithSpace(4),
                    if (widget.isForm)
                      ButtonCustom(
                        text: 'Create',
                        isExpan: false,
                        onTap: () {
                          if (!viewModel.isValidated(context)) {
                            viewModel.insertVehicleCheck(context);
                          }
                        },
                      ),
                    if (widget.data != null)
                      buildButtonRow(
                          data: widget.data!,
                          kmEnd: widget.kmEnd,
                          rows: viewModelList.vehicleCheck!.row != null
                              ? viewModelList.vehicleCheck!.row!
                              : [],
                          rowsInout:
                              viewModelList.vehicleCheck!.rowInout != null
                                  ? viewModelList.vehicleCheck!.rowInout!
                                  : [],
                          isForm: widget.isForm,
                          isScan: widget.isScan,
                          viewModelList: viewModelList,
                          viewModel: viewModel,
                          checkFormView: checkFormView,
                          context: context),
                    ...multiheithSpace(4),
                  ],
                ),
              )),
            ],
          ));
    });
  }

  bool notNullData() => widget.data != null;

  Widget labelSelectDateTimeInout(String titleLeft, String titleRight) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 5),
              child: Text(
                titleLeft,
                style: titleStyle13,
              ),
            ),
          ),
          widthSpace,
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 5),
              child: Text(
                titleRight,
                style: titleStyle13,
              ),
            ),
          )
        ],
      );
}
