import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/models/hr/overtime/overtime.dart';
import 'package:umgkh_mobile/utils/odoo_model.dart';
import 'package:umgkh_mobile/utils/show_dialog.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'package:umgkh_mobile/view_models/access_levels_view_model.dart';
import 'package:umgkh_mobile/view_models/approve_employee_overtime_form_view_model.dart';
import 'package:umgkh_mobile/view_models/approve_request_overtime_view_model.dart';
import 'package:umgkh_mobile/view_models/log_note_form_view_model.dart';
import 'package:umgkh_mobile/view_models/log_note_view_model.dart';
import 'package:umgkh_mobile/view_models/overtime_form_view_model.dart';
import 'package:umgkh_mobile/view_models/request_overtime_view_model.dart';
import 'package:umgkh_mobile/views/pages/hr/approve_employee_overtime_dh/widget/pop_up_confirmation.dart';
import 'package:umgkh_mobile/views/pages/hr/overtime/widget/widget_create_multi_form.dart';
import 'package:umgkh_mobile/views/pages/log_note/widget_comment_log_note.dart';
import 'package:umgkh_mobile/widgets/button_custom.dart';
import 'package:umgkh_mobile/widgets/custom_drop_list.dart';
import 'package:umgkh_mobile/widgets/custom_scaffold.dart';
import 'package:umgkh_mobile/widgets/dialog.dart';
import 'package:umgkh_mobile/widgets/textfield.dart';
import '../../../../utils/static_state.dart';

class CreateEmployeeOvertimePage extends StatefulWidget {
  static const routeName = '/create_employee_overtime';
  final Overtime? overtime;

  const CreateEmployeeOvertimePage({Key? key, this.overtime}) : super(key: key);

  @override
  State<CreateEmployeeOvertimePage> createState() =>
      _CreateEmployeeOvertimePageState();
}

class _CreateEmployeeOvertimePageState
    extends State<CreateEmployeeOvertimePage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Provider.of<RequestOvertimeViewModel>(context, listen: false)
      //     .fetchRequestOvertimes();
      final vm1 =
          Provider.of<ApproveRequestOvertimeViewModel>(context, listen: false);
      final vm2 = Provider.of<OvertimeFormViewModel>(context, listen: false);
      final vm3 = Provider.of<ApproveEmployeeOvertimeFormViewModel>(context,
          listen: false);
      vm1.fetchApproveRequestOT();
      vm2.resetForm();
      vm2.resetMulti();
      if (hasData()) vm2.setInfo(context, widget.overtime!);
      if (hasData()) fetchLogNote();
      // approve
      vm3.resetForm();
      if (hasData()) vm3.setInfo(widget.overtime!);
    });
    super.initState();
  }

  bool hasData() => widget.overtime != null;
  Future<void> fetchLogNote() async {
    final vmLN = Provider.of<LogNoteViewModel>(context, listen: false);
    final vmLNF = Provider.of<LogNoteFormViewModel>(context, listen: false);
    if (hasData()) vmLN.fetchData(widget.overtime!.id!, employeeOvertime);
    if (hasData()) vmLNF.resetForm();
  }

  @override
  Widget build(BuildContext context) => Consumer5<
          RequestOvertimeViewModel,
          OvertimeFormViewModel,
          ApproveRequestOvertimeViewModel,
          AccessLevelViewModel,
          ApproveEmployeeOvertimeFormViewModel>(
        builder: (context, __, formVM, viewModel, accessVM, approveVM, _) {
          return CustomScaffold(
              title: hasData() ? 'Info Overtime' : 'Create Overtime',
              resizeToAvoidBottomInset: true,
              body: formVM.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : viewModel.apiResponse.error != null && !accessVM.hasReadOT()
                      ? Center(
                          child: Text(viewModel.apiResponse.error ?? '',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)))
                      : ListView(physics: kBounce, children: [
                          Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              color: primaryColor.withOpacity(0.1),
                              margin: EdgeInsets.only(
                                  top: mainPadding / 1.5,
                                  left: mainPadding,
                                  right: mainPadding),
                              child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: mainPadding / 1.5,
                                      horizontal: mainPadding),
                                  child: Column(children: [
                                    heithSpace,

                                    // employee
                                    CustomDropList(
                                      selected: formVM.selectedRequest,
                                      isValidate: formVM.validate,
                                      readOnlyAndFilled: formVM.isReadOnly,
                                      enabled: !formVM.isReadOnly,
                                      items: viewModel.filterRequestOvertimeList
                                          .where((e) =>
                                              (e.overtimeId == null ||
                                                  e.overtimeId == 0) &&
                                              e.state == approveDH)
                                          .toList(),
                                      itemAsString: (i) => i.name.toString(),
                                      onChanged: (v) {
                                        formVM.onChangeSelectedRequest(v);
                                        formVM.onValidateReason(
                                            formVM.reasonCtrl.text);
                                        formVM.validate =
                                            formVM.selectedRequest.id == 0;
                                      },
                                    ),
                                    heithSpace,

                                    // distance
                                    InputTextField(
                                        ctrl: formVM.distanceCtrl,
                                        title: 'Distance',
                                        hint: 'Distance',
                                        suffixText: "KM",
                                        keyboardType: TextInputType.number,
                                        focusNode: formVM.focusNode,
                                        readOnly: formVM.isReadOnly,
                                        readOnlyAndFilled: formVM.isReadOnly,
                                        onChanged: (v) =>
                                            formVM.fetchAttendance()),
                                    heithSpace,

                                    _rowText(
                                        title: 'Actual Check In',
                                        data:
                                            formVM.overtimeAttendance.checkIn !=
                                                    null
                                                ? formatDateTime(formVM
                                                    .overtimeAttendance
                                                    .checkIn!)
                                                : ''),
                                    _rowText(
                                        title: 'Actual Check Out',
                                        data: formVM.overtimeAttendance
                                                    .checkOut !=
                                                null
                                            ? formatDateTime(formVM
                                                .overtimeAttendance.checkOut!)
                                            : ''),
                                    _rowText(
                                        title: 'Worked duration',
                                        data:
                                            '${formVM.overtimeAttendance.workedDurationHour ?? nullNum} hours ${formVM.overtimeAttendance.workedDurationMinute ?? nullNum} mins'),
                                    _rowText(
                                        title: 'Approved duration',
                                        data:
                                            '${formVM.overtimeAttendance.durationHour ?? nullNum} hours ${formVM.overtimeAttendance.durationMinute ?? nullNum} mins'),
                                    if (hasData() &&
                                        (widget.overtime!
                                                    .standardResolutionHour !=
                                                null &&
                                            widget.overtime!
                                                    .standardResolutionHour !=
                                                0)) ...[
                                      _rowText(
                                          title: 'Standard Lead Time',
                                          data:
                                              '${widget.overtime!.standardResolutionHour} hours')
                                    ],

                                    // approve hour - minute
                                    if ((accessVM.hasSubmitOT() ||
                                            accessVM.hasApproveOT()) &&
                                        (hasData() &&
                                            widget.overtime!.state ==
                                                submit)) ...[
                                      heithSpace,
                                      Row(children: [
                                        Flexible(
                                            child: InputTextField(
                                                ctrl: approveVM.hourCtrl,
                                                title: 'Hour',
                                                hint: 'Approve Hour',
                                                suffixText: "Hour",
                                                keyboardType:
                                                    TextInputType.number,
                                                maxLength: 2,
                                                isValidate:
                                                    approveVM.validateHour,
                                                validatedText:
                                                    approveVM.validateHourText,
                                                onChanged: (hour) {
                                                  approveVM
                                                      .onValidateHour(hour);
                                                  //check required reason
                                                  approveVM.checkReasonRequired(
                                                      hour,
                                                      approveVM.minuteCtrl.text,
                                                      widget.overtime!
                                                              .standardResolutionHour ??
                                                          0);
                                                })),
                                        widthSpace,
                                        Flexible(
                                            child: InputTextField(
                                                ctrl: approveVM.minuteCtrl,
                                                focusNode:
                                                    approveVM.minuteFocusNode,
                                                title: 'Minute',
                                                maxLength: 2,
                                                hint: 'Approve Minute',
                                                suffixText: 'Minute',
                                                keyboardType:
                                                    TextInputType.number,
                                                onChanged: (min) {
                                                  //check required reason
                                                  approveVM.checkReasonRequired(
                                                      approveVM.hourCtrl.text,
                                                      min,
                                                      widget.overtime!
                                                              .standardResolutionHour ??
                                                          0);
                                                }))
                                      ])
                                    ],
                                    // create
                                    if (hasData() &&
                                        widget
                                            .overtime!.createBy.isNotEmpty) ...[
                                      heithSpace,
                                      InputTextField(
                                          ctrl: formVM.createByCtrl,
                                          title: 'Create By',
                                          enableSelectText: false,
                                          readOnly: true,
                                          readOnlyAndFilled: true)
                                    ],

                                    // reason dh approve overtime
                                    if (hasData() &&
                                        (approveVM.isShowReason ||
                                            widget.overtime!.dhApprovedReason !=
                                                null)) ...[
                                      heith10Space,
                                      MutliLineTextField(
                                          ctrl: approveVM.dhApproveReasonCtrl,
                                          title: 'DH Approved Reason',
                                          maxLine: null,
                                          readOnly: widget
                                                  .overtime!.dhApprovedReason !=
                                              null,
                                          readOnlyAndFilled: widget
                                                  .overtime!.dhApprovedReason !=
                                              null,
                                          isValidate:
                                              approveVM.isRequiredReason,
                                          validatedText: approveVM
                                                  .isRequiredReason
                                              ? 'Your approved hour/min is out of range Standard Lead Time (${widget.overtime!.standardResolutionHour})'
                                              : '',
                                          onChanged: (v) {
                                            approveVM.checkReasonRequired(
                                                approveVM.hourCtrl.text,
                                                approveVM.minuteCtrl.text,
                                                widget.overtime!
                                                        .standardResolutionHour ??
                                                    0);
                                          })
                                    ],
                                    heithSpace,

                                    // reason overtime
                                    MutliLineTextField(
                                        ctrl: formVM.reasonCtrl,
                                        title: 'Overtime Reason',
                                        maxLine: null,
                                        readOnly: formVM.isReadOnly,
                                        readOnlyAndFilled: formVM.isReadOnly,
                                        isValidate: formVM.validateReason,
                                        validatedText: formVM.validateText,
                                        onChanged: formVM.onValidateReason),
                                    heithSpace,

                                    // amount
                                    Material(
                                        color: greenColor,
                                        borderRadius:
                                            BorderRadius.circular(mainRadius),
                                        child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: mainPadding,
                                                vertical: mainPadding / 3),
                                            child: Text(
                                                '\$ ${formVM.overtimeAttendance.amount?.toStringAsFixed(2) ?? '0'}',
                                                textAlign: TextAlign.center,
                                                style: primary15Bold.copyWith(
                                                    color: whiteColor))))
                                  ]))),

                          // multi
                          if (formVM.localMultiSubmitOT.isNotEmpty) ...[
                            heithSpace,
                            Divider(color: blackColor, thickness: 0.5),
                            const WidgetSumbitOTCreateMultiForm()
                          ],

                          // bt has submit - approve OT
                          if ((accessVM.hasSubmitOT() ||
                                  accessVM.hasApproveOT()) &&
                              !hasData()) ...[
                            Padding(
                                padding: EdgeInsets.all(mainPadding),
                                child: Row(children: [
                                  ButtonCustom(
                                      isExpan: true,
                                      text: 'Submit',
                                      onTap: () => formVM
                                              .localMultiSubmitOT.isNotEmpty
                                          ? formVM.insertMultiOvertime(context)
                                          : formVM
                                              .onValidateInsertSingle(context)),
                                  widthSpace,
                                  ButtonCustom(
                                      isExpan: true,
                                      icon: Icons.add_rounded,
                                      text: 'Add Line',
                                      color: amberColor,
                                      onTap: () =>
                                          formVM.onValidateStoreLocal(context)),
                                ]))
                          ],

                          // bt Appprove - Reject
                          if ((accessVM.hasSubmitOT() ||
                                  accessVM.hasApproveOT()) &&
                              (hasData() &&
                                  widget.overtime!.state == submit)) ...[
                            Padding(
                                padding: EdgeInsets.all(mainPadding),
                                child: Row(children: [
                                  ButtonCustom(
                                      isExpan: true,
                                      text: 'Approve',
                                      onTap: () async {
                                        approveVM.checkReasonRequired(
                                            approveVM.hourCtrl.text,
                                            approveVM.minuteCtrl.text,
                                            widget.overtime!
                                                    .standardResolutionHour ??
                                                0);
                                        if (approveVM.isRequiredReason) return;
                                        await approveVM
                                            .updateApproveRequestOvertime(
                                                context: context,
                                                widget.overtime!.id ?? 0,
                                                approveDH);
                                      }),
                                  widthSpace,
                                  ButtonCustom(
                                      isExpan: true,
                                      text: 'Reject',
                                      color: rejectedColor,
                                      onTap: () => showCustomConfirmDialog(
                                              context,
                                              title: 'Confirm Rejection !',
                                              message:
                                                  'You are about to reject the Overtime: (${widget.overtime!.name}). Are you sure ?',
                                              confirmTitle: 'Reject',
                                              onConfirm: () async {
                                            await approveVM
                                                .updateApproveRequestOvertime(
                                                    context: context,
                                                    widget.overtime!.id ?? 0,
                                                    reject);
                                          }))
                                ]))
                          ],
                          if (hasData()) ...[
                            Padding(
                                padding: EdgeInsets.all(mainPadding),
                                child: WidgetCommentLogNote(
                                    resId: widget.overtime!.id!,
                                    model: employeeOvertime)),
                            heithSpace
                          ]
                        ]));
        },
      );

  Widget _rowText({required String title, required String data}) => Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 0, 5),
      child: Row(children: [
        Expanded(child: Text('$title:', style: titleStyle13)),
        Expanded(child: Text(data, style: primary13Bold))
      ]));
}
