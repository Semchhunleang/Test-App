import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/models/am/schedule_truck_driver/schedule_truck_driver.dart';
import 'package:umgkh_mobile/utils/static_state.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'package:umgkh_mobile/view_models/access_levels_view_model.dart';
import 'package:umgkh_mobile/view_models/schedule_truck_driver_form_view_model.dart';
import 'package:umgkh_mobile/view_models/selections_view_model.dart';
import 'package:umgkh_mobile/widgets/button_custom.dart';
import 'package:umgkh_mobile/widgets/custom_drop_list.dart';
import 'package:umgkh_mobile/widgets/custom_scaffold.dart';
import 'package:umgkh_mobile/widgets/custom_selected_date.dart';
import 'package:umgkh_mobile/widgets/textfield.dart';

class ScheduleTruckDriverFormAndInfoPage extends StatefulWidget {
  final bool isForm;
  final ScheduleTruckDriver? data;

  const ScheduleTruckDriverFormAndInfoPage(
      {super.key, this.isForm = true, this.data});

  @override
  State<ScheduleTruckDriverFormAndInfoPage> createState() =>
      _ScheduleTruckDriverFormAndInfoPageState();
}

class _ScheduleTruckDriverFormAndInfoPageState
    extends State<ScheduleTruckDriverFormAndInfoPage> {
  late String title;
  @override
  void initState() {
    final p =
        Provider.of<ScheduleTruckDriverFormViewModel>(context, listen: false);
    if (notNullData()) {
      p.checkReadOnly(widget.data!.state, context, widget.data!.requestor.id);
    }
    p.resetValidate();
    p.resetForm(context);
    if (widget.isForm) p.resetReadOnly();
    if (!widget.isForm && widget.data != null) p.setInfo(widget.data!);

    title = widget.isForm
        ? 'Schedule Truck Driver Form'
        : 'Schedule Truck Driver Info';
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Consumer2<
          ScheduleTruckDriverFormViewModel, AccessLevelViewModel>(
      builder: (context, formVM, accessVM, _) => CustomScaffold(
          title: title,
          resizeToAvoidBottomInset: true,
          isLoading: formVM.isLoading,
          body: Padding(
              padding: EdgeInsets.symmetric(horizontal: mainPadding),
              child: Column(children: [
                if (!widget.isForm && widget.data != null) ...[
                  heith10Space,
                  SizedBox(
                      width: double.infinity,
                      height: 30,
                      child: StatusCustom(
                          textsize: 11,
                          text: widget.data!.state.toUpperCase(),
                          color: stateColor(widget.data!.state))),
                  heith10Space,
                ],

                // info as form
                Expanded(
                    child: ListView(physics: kBounce, children: [
                  Flex(direction: Axis.horizontal, children: [
                    Expanded(
                        child: CustomSelectDate(
                            ctrl: formVM.requestDTCtrl,
                            title: 'Request DT',
                            readOnlyAndFilled:
                                (formVM.isReadOnly && !checkState(draft)),
                            onTap: (formVM.isReadOnly && !checkState(draft))
                                ? null
                                : () {
                                    if (notNullData()) {
                                      formVM.selectedDTRequest =
                                          widget.data!.requestDatetime;
                                    }
                                    formVM.selectDateTime(context,
                                        ctrl: formVM.requestDTCtrl,
                                        initialValue: formVM.selectedDTRequest,
                                        onSelected: (dt) =>
                                            formVM.selectedDTRequest = dt);
                                  })),
                    widthSpace,
                    accessVM.hasAmDh()
                        // ============ AM-DH ============ APPROVE DATE
                        ? Expanded(
                            child: CustomSelectDate(
                                ctrl: formVM.approveDTCtrl,
                                title: 'Approved DT',
                                readOnlyAndFilled: !checkState(submit),
                                isRequired: formVM.isRequiredAppDT,
                                onTap: () => formVM.selectDateTime(context,
                                    ctrl: formVM.approveDTCtrl,
                                    initialValue: formVM.selectedDTApprove,
                                    onSelected: formVM.onApproveDTChanged)))
                        // ============ REQUESTOR ============ APPROVE DATE
                        : notNullData() && widget.data!.approveDatetime != null
                            ? Expanded(
                                child: CustomSelectDate(
                                    ctrl: formVM.approveDTCtrl,
                                    readOnlyAndFilled: true,
                                    title: 'Approved DT'))
                            : sizedBoxShrink
                  ]),
                  heith10Space,

                  // ============ REQUESTOR ============
                  Flex(direction: Axis.horizontal, children: [
                    Expanded(
                        child: InputTextField(
                            ctrl: formVM.requestorCtrl,
                            title: 'Requestor',
                            enableSelectText: false,
                            readOnly: true,
                            readOnlyAndFilled: true)),
                    widthSpace,
                    Expanded(
                        child: InputTextField(
                            ctrl: formVM.deptCtrl,
                            title: 'Department',
                            enableSelectText: false,
                            readOnly: true,
                            readOnlyAndFilled: true))
                  ]),
                  heith10Space,
                  // ============ AM-DH ============ Schedule - Actual DT
                  if (accessVM.hasAmDh() && checkState(approve)) ...[
                    Flex(direction: Axis.horizontal, children: [
                      Expanded(
                          child: CustomSelectDate(
                              ctrl: formVM.scheduleDeliDTCtrl,
                              title: 'Schedule Delivery DT',
                              readOnlyAndFilled: !checkState(approve),
                              isRequired: formVM.isRequiredScheduleDeliDT,
                              onTap: () => formVM.selectDateTime(context,
                                  ctrl: formVM.scheduleDeliDTCtrl,
                                  initialValue: formVM.selectedDTScheduleDeli,
                                  onSelected: formVM.onChangeDTScheduleDeli))),
                      widthSpace,
                      Expanded(
                          child: CustomSelectDate(
                              ctrl: formVM.actualDeliDTCtrl,
                              title: 'Actual Delivery DT',
                              readOnlyAndFilled: !checkState(approve),
                              isRequired: formVM.isRequiredActualDeliDT,
                              onTap: () => formVM.selectDateTime(context,
                                  ctrl: formVM.actualDeliDTCtrl,
                                  initialValue: formVM.selectedDTActualDeli,
                                  onSelected: formVM.onChangeDTActualDeli)))
                    ]),
                  ] else ...[
                    // ============ REQUESTOR ============ Schedule - Actual DT
                    Flex(direction: Axis.horizontal, children: [
                      if (notNullSchDeli()) ...[
                        Expanded(
                            child: CustomSelectDate(
                                ctrl: formVM.scheduleDeliDTCtrl,
                                title: 'Schedule Delivery DT',
                                readOnlyAndFilled: true))
                      ],
                      if (notNullActDeli()) ...[
                        widthSpace,
                        Expanded(
                            child: CustomSelectDate(
                                ctrl: formVM.actualDeliDTCtrl,
                                readOnlyAndFilled: true,
                                title: 'Actual Delivery DT'))
                      ]
                    ]),
                    if (notNullSchDeli() || notNullActDeli()) heith10Space
                  ],
                  // ============ AM-DH ============ Schedule - Actual DT
                  if (accessVM.hasAmDh() && checkState(approve)) ...[
                    heith10Space,
                    Flex(direction: Axis.horizontal, children: [
                      Expanded(
                          child: CustomSelectDate(
                              ctrl: formVM.scheduleArriveDTCtrl,
                              title: 'Schedule Arrive DT',
                              readOnlyAndFilled: !checkState(approve),
                              isRequired: formVM.isRequiredScheduleArriDT,
                              onTap: () => formVM.selectDateTime(context,
                                  ctrl: formVM.scheduleArriveDTCtrl,
                                  initialValue: formVM.selectedDTScheduleArri,
                                  onSelected: formVM.onChangeDTScheduleArri))),
                      widthSpace,
                      Expanded(
                          child: CustomSelectDate(
                              ctrl: formVM.actualArriveDTCtrl,
                              title: 'Actual Arrive DT',
                              readOnlyAndFilled: !checkState(approve),
                              isRequired: formVM.isRequiredActualArriDT,
                              onTap: () => formVM.selectDateTime(context,
                                  ctrl: formVM.actualArriveDTCtrl,
                                  initialValue: formVM.selectedDTActualArri,
                                  onSelected: formVM.onChangeDTActualArri)))
                    ]),
                    heith10Space
                    // ============ REQUESTOR ============ Schedule - Actual DT
                  ] else if (notNullSchArri() || notNullActArri()) ...[
                    Flex(direction: Axis.horizontal, children: [
                      if (notNullSchArri()) ...[
                        Expanded(
                            child: CustomSelectDate(
                                ctrl: formVM.scheduleArriveDTCtrl,
                                title: 'Schedule Arrive DT',
                                readOnlyAndFilled: formVM.isReadOnly,
                                onTap: formVM.isReadOnly ? null : () {}))
                      ],
                      if (notNullActArri()) ...[
                        widthSpace,
                        Expanded(
                            child: CustomSelectDate(
                                ctrl: formVM.actualArriveDTCtrl,
                                readOnlyAndFilled: formVM.isReadOnly,
                                title: 'Actual Arrive DT'))
                      ]
                    ]),
                    heith10Space
                  ],
                  // ============ AM-DH ============ DRIVER - VEHICEL
                  if (accessVM.hasAmDh()) ...[
                    Flex(direction: Axis.horizontal, children: [
                      Expanded(
                          child: Consumer<SelectionsViewModel>(
                              builder: (context, vm, _) => CustomDropList(
                                  enabled: checkState(submit),
                                  readOnlyAndFilled: !checkState(submit),
                                  titleHead: 'Driver',
                                  validateText: 'Please select driver',
                                  // isValidate: formVM.isRequiredDriver,
                                  isValidate: formVM.isRequiredDriverVehicle,
                                  selected: formVM.selectedDriver,
                                  items: vm.employees
                                      .where((e) => e.department?.code == 'AM')
                                      .toList(),
                                  itemAsString: (i) => i.name.toString(),
                                  isSearch: true,
                                  onChanged: (v) =>
                                      formVM.onChangeDriver(v, context)))),
                      widthSpace,
                      Expanded(
                          child: Consumer<SelectionsViewModel>(
                              builder: (context, vm, _) => CustomDropList(
                                  enabled: checkState(submit),
                                  readOnlyAndFilled: !checkState(submit),
                                  titleHead: 'Vehicle',
                                  validateText: 'Please select vehicle',
                                  // isValidate: formVM.isRequiredVehicle,
                                  isValidate: formVM.isRequiredDriverVehicle,
                                  selected: formVM.selectedVehicle,
                                  items: vm.fleetVehicle.toList(),
                                  itemAsString: (i) => i.name.toString(),
                                  isSearch: true,
                                  onChanged: (v) {
                                    formVM.onChangeVehicle(v, context);
                                    formVM.autoFillKM();
                                  })))
                    ]),
                    heith10Space
                    // ============ REQUESTOR ============ DRIVER - VEHICEL
                  ] else ...[
                    Flex(direction: Axis.horizontal, children: [
                      if (notNullDriver()) ...[
                        Expanded(
                            child: InputTextField(
                                ctrl: formVM.driverCtrl,
                                title: 'Driver',
                                enableSelectText: false,
                                readOnly: true,
                                readOnlyAndFilled: true)),
                        widthSpace
                      ],
                      if (notNullVehicle()) ...[
                        Expanded(
                            child: InputTextField(
                                ctrl: formVM.vehicleCtrl,
                                title: 'Vehicle',
                                enableSelectText: false,
                                readOnly: true,
                                readOnlyAndFilled: true))
                      ]
                    ]),
                    heith10Space
                  ],

                  // ============ AM-DH ============ KM START - KM END
                  if (accessVM.hasAmDh()) ...[
                    Flex(direction: Axis.horizontal, children: [
                      Expanded(
                          child: InputTextField(
                              ctrl: formVM.kmStartCtrl,
                              title: 'KM Start',
                              suffixText: 'KM',
                              enableSelectText: false,
                              readOnly: !checkState(submit),
                              readOnlyAndFilled: !checkState(submit),
                              isValidate: formVM.isRequiredKmStart,
                              validatedText: formVM.isRequiredKmStart
                                  ? 'Km start must fill & not zero !'
                                  : '',
                              keyboardType: TextInputType.number,
                              onChanged: formVM.onChangeKmStart)),
                      widthSpace,
                      Expanded(
                          child: InputTextField(
                              ctrl: formVM.kmEndCtrl,
                              title: 'KM End',
                              suffixText: 'KM',
                              enableSelectText: false,
                              readOnly: !checkState(approve) ||
                                  formVM.selectedVehicle.id == 0,
                              readOnlyAndFilled: !checkState(approve) ||
                                  formVM.selectedVehicle.id == 0,
                              keyboardType: TextInputType.number,
                              isValidate: formVM.isRequiredKmEnd,
                              validatedText: formVM.isRequiredKmEnd
                                  ? 'Km end must fill & greater than km start !'
                                  : '',
                              onChanged: formVM.onChangeKmEnd))
                    ])
                    // ============ REQUESTOR ============ KM START - KM END
                  ] else if (notNullKmStart() || notNullKmEnd()) ...[
                    Flex(direction: Axis.horizontal, children: [
                      if (notNullKmStart()) ...[
                        Expanded(
                            child: InputTextField(
                                ctrl: formVM.kmStartCtrl,
                                title: 'KM Start',
                                suffixText: 'KM',
                                enableSelectText: false,
                                readOnly: true,
                                readOnlyAndFilled: true))
                      ],
                      if (notNullKmEnd()) ...[
                        widthSpace,
                        Expanded(
                            child: InputTextField(
                                ctrl: formVM.kmEndCtrl,
                                title: 'KM End',
                                suffixText: 'KM',
                                enableSelectText: false,
                                readOnly: true,
                                readOnlyAndFilled: true))
                      ]
                    ]),
                    heith10Space
                  ],
                  // ============ AM-DH ============ TAG - TOTAL KM
                  if (accessVM.hasAmDh()) ...[
                    heith10Space,
                    Flex(direction: Axis.horizontal, children: [
                      Expanded(
                          child: Consumer<SelectionsViewModel>(
                              builder: (context, vm, _) => CustomDropList(
                                  titleHead: 'Tag',
                                  enabled: checkState(submit),
                                  readOnlyAndFilled: !checkState(submit),
                                  selected: formVM.selectedTag,
                                  items: vm.scheduleTruckDriverTag
                                      .where((e) => e.id != 0)
                                      .toList(),
                                  itemAsString: (i) => i.name.toString(),
                                  onChanged: formVM.onTagChanged))),
                      widthSpace,
                      Expanded(
                          child: InputTextField(
                              ctrl: formVM.totalKmCtrl,
                              title: 'Total KM',
                              suffixText: 'KM',
                              enableSelectText: false,
                              readOnly: true,
                              readOnlyAndFilled: true))
                    ]),
                    // ============ REQUESTOR ============ TAG - TOTAL KM
                  ] else if (notNullTag() || notNullTotalKm()) ...[
                    Flex(direction: Axis.horizontal, children: [
                      Expanded(
                          child: Consumer<SelectionsViewModel>(
                              builder: (context, vm, _) => CustomDropList(
                                  titleHead: 'Tag',
                                  readOnlyAndFilled: true,
                                  enabled: false,
                                  selected: formVM.selectedTag,
                                  items: vm.scheduleTruckDriverTag.toList(),
                                  itemAsString: (i) => i.name.toString(),
                                  onChanged: formVM.onTagChanged))),
                      if (notNullTotalKm()) ...[
                        widthSpace,
                        Expanded(
                            child: InputTextField(
                                ctrl: formVM.totalKmCtrl,
                                title: 'Total KM',
                                suffixText: 'KM',
                                enableSelectText: false,
                                readOnly: true,
                                readOnlyAndFilled: true))
                      ]
                    ])
                  ],

                  heith10Space,
                  MutliLineTextField(
                      ctrl: formVM.purposeCtrl,
                      title: 'Purpose',
                      hint: 'Enter purpose . . . ',
                      readOnly: (formVM.isReadOnly && !checkState(draft)),
                      readOnlyAndFilled:
                          (formVM.isReadOnly && !checkState(draft)),
                      enableSelectText: !formVM.isReadOnly,
                      isValidate: formVM.isPurpose,
                      validatedText: formVM.isPurpose ? 'Required field' : '',
                      onChanged: formVM.onChangePurpose),
                  heithSpace,

                  ...multiheithSpace(3),

                  // button
                  buildButtonRow(context),
                  ...multiheithSpace(3),
                ]))
              ]))));

  buildButtonRow(BuildContext context) =>
      Consumer2<ScheduleTruckDriverFormViewModel, AccessLevelViewModel>(
          builder: (context, form, access, _) => Row(children: [
                ...multiWidthSpace(2),
                // requestor - update state
                if (checkState(draft) &&
                    form.isRequestor(context, widget.data!.requestor.id)) ...[
                  button(
                      text: 'Submit',
                      color: submitColor,
                      onTap: () => onSubmit(form)),
                  ...multiWidthSpace(2)
                ],

                // requestor - create & update
                if ((checkState(draft) &&
                        form.isRequestor(context, widget.data!.requestor.id)) ||
                    widget.isForm) ...[
                  button(
                      text: widget.isForm ? 'Create' : 'Update',
                      color: primaryColor,
                      onTap: () =>
                          form.isButtonDisabled ? null : onCreateOrUpdate(form))
                ],

                // AM DH
                if (notNullData() && access.hasAmDh()) ...[
                  if (checkState(submit)) ...[
                    button(
                        text: 'Approve',
                        color: approvedColor,
                        onTap: () => onApprove(form)),
                  ],
                  if (checkState(approve)) ...[
                    button(
                        text: 'Save',
                        color: claimColor,
                        onTap: () => onSaveAndDone(form, null)),
                    widthSpace,
                    button(
                        text: 'Done',
                        color: approvedColor,
                        onTap: () => onSaveAndDone(form, done))
                  ],
                  widthSpace,
                  if (!checkState(done) && !checkState(reject)) ...[
                    button(
                        text: 'Reject',
                        color: rejectedColor,
                        onTap: () => onReject(form))
                  ]
                ],
                ...multiWidthSpace(2)
              ]));

  bool notNullData() => widget.data != null;
  bool checkState(String state) => notNullData() && widget.data?.state == state;
  bool notNullSchDeli() =>
      notNullData() && widget.data?.scheduleDeliveryDatetime != null;
  bool notNullActDeli() =>
      notNullData() && widget.data?.actualDeliveryDatetime != null;
  bool notNullSchArri() =>
      notNullData() && widget.data?.scheduleArriveDatetime != null;
  bool notNullActArri() =>
      notNullData() && widget.data?.actualArriveDatetime != null;
  bool notNullDriver() => notNullData() && widget.data?.driver != null;
  bool notNullVehicle() => notNullData() && widget.data?.vehicle != null;
  bool notNullKmStart() =>
      notNullData() &&
      (widget.data?.kmStart != null && widget.data?.kmStart != 0);
  bool notNullKmEnd() =>
      notNullData() && (widget.data?.kmEnd != null && widget.data?.kmEnd != 0);
  bool notNullTotalKm() =>
      notNullData() &&
      (widget.data?.totalKm != null && widget.data?.totalKm != 0);
  bool notNullTag() => notNullData() && widget.data?.tag != null;

  Widget button(
          {required String text,
          required Color color,
          required Function() onTap}) =>
      ButtonCustom(isExpan: true, text: text, color: color, onTap: onTap);

  onCreateOrUpdate(ScheduleTruckDriverFormViewModel vm) {
    if (!vm.isValidated()) {
      widget.isForm
          ? vm.isButtonDisabled
              ? null
              : vm.insert(context)
          : onUpdate(vm);
    }
  }

  void onSubmit(ScheduleTruckDriverFormViewModel vm) {
    Map<String, dynamic> data = vm.buildMap()
      ..addAll({'id': widget.data?.id, 'state': submit});
    if (!vm.isValidated()) vm.update(context, data);
  }

  void onApprove(ScheduleTruckDriverFormViewModel vm) async {
    Map<String, dynamic> data = {
      'id': widget.data?.id,
      'state': approve,
      if (vm.approveDTCtrl.text.isNotEmpty)
        'approve_datetime': toApiSubtract7Hours(vm.approveDTCtrl.text),
      if (vm.selectedDriver.id != 0) 'driver_id': vm.selectedDriver.id,
      if (vm.selectedVehicle.id != 0) 'fleet_id': vm.selectedVehicle.id,
      if (vm.selectedVehicle.id != 0) 'km_start': vm.kmStartCtrl.text,
      'tag': vm.selectedTag.value,
    };
    if (!vm.isValidatedApprove(context)) vm.update(context, data);
  }

  void onSaveAndDone(ScheduleTruckDriverFormViewModel vm, String? state) async {
    if (state != null && state == done && vm.isValidatedDone(context)) return;
    Map<String, dynamic> data = {
      'id': widget.data?.id,
      if (vm.selectedVehicle.id != 0) 'km_end': vm.kmEndCtrl.text,
      if (vm.selectedVehicle.id != 0) 'total_km': vm.totalKmCtrl.text,
      if (state != null) 'state': state,
      if (vm.selectedDTScheduleDeli != null)
        'schedule_delivery_datetime':
            toApiSubtract7Hours(vm.scheduleDeliDTCtrl.text),
      if (vm.selectedDTActualDeli != null)
        'actual_delivery_datetime':
            toApiSubtract7Hours(vm.actualDeliDTCtrl.text),
      if (vm.selectedDTScheduleArri != null)
        'schedule_arrive_datetime':
            toApiSubtract7Hours(vm.scheduleArriveDTCtrl.text),
      if (vm.selectedDTActualArri != null)
        'actual_arrive_datetime':
            toApiSubtract7Hours(vm.actualArriveDTCtrl.text),
    };
    await vm.update(context, data);
  }

  void onReject(ScheduleTruckDriverFormViewModel vm) {
    Map<String, dynamic> data = vm.buildMap()
      ..addAll({'id': widget.data?.id, 'state': reject});
    vm.update(context, data);
  }

  void onUpdate(ScheduleTruckDriverFormViewModel vm) {
    Map<String, dynamic> data = vm.buildMap()..addAll({'id': widget.data?.id});
    if (!vm.isValidated()) vm.update(context, data);
  }
}
