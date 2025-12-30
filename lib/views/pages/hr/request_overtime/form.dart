import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/models/hr/request_overtime/request_overtime.dart';
import 'package:umgkh_mobile/utils/odoo_model.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'package:umgkh_mobile/view_models/access_levels_view_model.dart';
import 'package:umgkh_mobile/view_models/log_note_form_view_model.dart';
import 'package:umgkh_mobile/view_models/log_note_view_model.dart';
import 'package:umgkh_mobile/view_models/request_overtime_form_view_model.dart';
import 'package:umgkh_mobile/view_models/selections_view_model.dart';
import 'package:umgkh_mobile/views/pages/hr/request_overtime/widget/widget_create_multi_form.dart';
import 'package:umgkh_mobile/views/pages/log_note/widget_comment_log_note.dart';
import 'package:umgkh_mobile/widgets/button_custom.dart';
import 'package:umgkh_mobile/widgets/custom_drop_list.dart';
import 'package:umgkh_mobile/widgets/custom_selected_date.dart';
import 'package:umgkh_mobile/widgets/textfield.dart';
import 'package:umgkh_mobile/view_models/profile_view_model.dart';
import 'package:umgkh_mobile/widgets/custom_scaffold.dart';

class CreateRequestOvertimePage extends StatefulWidget {
  static const namePage = 'Create Request Overtime';
  static const infoPage = 'Info Request Overtime';
  final RequestOvertime? overtime;

  const CreateRequestOvertimePage({Key? key, this.overtime}) : super(key: key);

  @override
  State<CreateRequestOvertimePage> createState() =>
      _CreateRequestOvertimePageState();
}

class _CreateRequestOvertimePageState extends State<CreateRequestOvertimePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm =
          Provider.of<RequestOvertimeFormViewModel>(context, listen: false);
      vm.clearValidationErrors();
      vm.resetForm();
      vm.resetMulti();
      if (hasData()) vm.setInfo(context, widget.overtime!);
      fetchLogNote();
    });
  }

  Future<void> fetchLogNote() async {
    final vmLN = Provider.of<LogNoteViewModel>(context, listen: false);
    final vmLNF = Provider.of<LogNoteFormViewModel>(context, listen: false);
    if (hasData()) vmLN.fetchData(widget.overtime!.id, requestEmployeeOvertime);
    if (hasData()) vmLNF.resetForm();
  }

  bool hasData() => widget.overtime != null;

  @override
  Widget build(BuildContext context) {
    return Consumer3<RequestOvertimeFormViewModel, ProfileViewModel,
        AccessLevelViewModel>(builder: (context, formVM, userVM, accessVM, _) {
      return CustomScaffold(
          resizeToAvoidBottomInset: true,
          title: hasData()
              ? CreateRequestOvertimePage.infoPage
              : CreateRequestOvertimePage.namePage,
          body: formVM.isLoading == true
              ? const Center(child: CircularProgressIndicator())
              : Stack(children: [
                  GestureDetector(
                      onTap: () =>
                          FocusScope.of(context).requestFocus(FocusNode()),
                      behavior: HitTestBehavior.translucent,
                      child: ListView(
                          shrinkWrap: true,
                          physics: kBounce,
                          children: [
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
                                child: Column(
                                  children: [
                                    // employee
                                    Consumer<SelectionsViewModel>(
                                        builder: (context, vm, _) =>
                                            CustomDropList(
                                                titleHead: 'Employee',
                                                selected: formVM.selectEmployee,
                                                readOnlyAndFilled: formVM
                                                    .isReadOnly,
                                                enabled: !formVM.isReadOnly,
                                                isSearch: true,
                                                isValidate: formVM
                                                    .validEmployee,
                                                items: vm.employees
                                                    .where((e) =>
                                                        e
                                                            .manager?.id ==
                                                        userVM.user.id)
                                                    .toList(),
                                                itemAsString: (i) =>
                                                    i.name.toString(),
                                                onChanged:
                                                    formVM.onChangeEmployee)),
                                    heithSpace,

                                    // overtime date
                                    CustomSelectDate(
                                        ctrl: formVM.dateCtrl,
                                        title: 'Overtime Date',
                                        readOnlyAndFilled: formVM.isReadOnly,
                                        onTap: () =>
                                            formVM.selectDate(context)),

                                    if (hasData() &&
                                        widget.overtime?.createBy != null) ...[
                                      heithSpace,
                                      InputTextField(
                                          ctrl: formVM.createByCtrl,
                                          title: 'Create By',
                                          enableSelectText: false,
                                          readOnly: true,
                                          readOnlyAndFilled: true)
                                    ],
                                    if (hasData() &&
                                        widget.overtime?.approveDhDatetime !=
                                            null) ...[
                                      heithSpace,
                                      InputTextField(
                                          ctrl: formVM.approveDTCtrl,
                                          title: 'Approve DT',
                                          enableSelectText: false,
                                          readOnly: true,
                                          readOnlyAndFilled: true)
                                    ],
                                    if (hasData() &&
                                        widget.overtime?.rejectDatetime !=
                                            null &&
                                        widget.overtime?.rejectDatetime !=
                                            nullDt) ...[
                                      heithSpace,
                                      InputTextField(
                                          ctrl: formVM.rejectDTCtrl,
                                          title: 'Reject DT',
                                          enableSelectText: false,
                                          readOnly: true,
                                          readOnlyAndFilled: true)
                                    ],
                                    heithSpace,

                                    /// duration
                                    Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // hour
                                          Expanded(
                                              flex: 3,
                                              child: InputTextField(
                                                  ctrl: formVM.hourCtrl,
                                                  title: 'Duration',
                                                  hint: 'Hour',
                                                  suffixText: "Hour",
                                                  keyboardType:
                                                      TextInputType.number,
                                                  maxLength: 2,
                                                  isValidate:
                                                      formVM.validateHour,
                                                  validatedText:
                                                      formVM.validateHourText,
                                                  readOnly: formVM.isReadOnly,
                                                  readOnlyAndFilled:
                                                      formVM.isReadOnly,
                                                  enableSelectText:
                                                      !formVM.isReadOnly,
                                                  onChanged: (hour) => formVM
                                                      .onValidateHour(hour))),
                                          widthSpace,

                                          // minutes
                                          Expanded(
                                              flex: 3,
                                              child: InputTextField(
                                                  ctrl: formVM.minuteCtrl,
                                                  focusNode:
                                                      formVM.minuteFocusNode,
                                                  title: '',
                                                  maxLength: 2,
                                                  hint: 'Minute',
                                                  suffixText: 'Minute',
                                                  keyboardType:
                                                      TextInputType.number,
                                                  readOnly: formVM.isReadOnly,
                                                  readOnlyAndFilled:
                                                      formVM.isReadOnly,
                                                  enableSelectText:
                                                      !formVM.isReadOnly))
                                        ]),
                                    heithSpace,

                                    /// reason
                                    MutliLineTextField(
                                        ctrl: formVM.textarea,
                                        title: 'Reason',
                                        maxLine: null,
                                        isValidate: formVM.validateReason,
                                        validatedText: formVM.validateText,
                                        readOnly: formVM.isReadOnly,
                                        readOnlyAndFilled: formVM.isReadOnly,
                                        enableSelectText: !formVM.isReadOnly,
                                        onChanged: (reason) =>
                                            formVM.onValidateReason(reason)),
                                    heith5Space
                                  ],
                                ),
                              ),
                            ),

                            if (formVM.localMultiReqOT.isNotEmpty) ...[
                              heithSpace,
                              Divider(color: blackColor, thickness: 0.5),
                              const WidgetRequestOTCreateMultiForm()
                            ],

                            // submit bt for DH only
                            if (accessVM.hasSubmitReqOT()) ...[
                              heithSpace,
                              formVM.isReadOnly
                                  ? sizedBoxShrink
                                  : hasData()
                                      ? sizedBoxShrink
                                      : Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: mainPadding),
                                          child: Row(children: [
                                            ButtonCustom(
                                                text: 'Submit',
                                                isExpan: true,
                                                onTap: () {
                                                  if (formVM.localMultiReqOT
                                                      .isNotEmpty) {
                                                    // multi req
                                                    formVM
                                                        .createMultiOvertimeRequest(
                                                            context: context);
                                                  } else {
                                                    // single req
                                                    formVM
                                                        .onValidation(context);
                                                    if (!formVM
                                                            .validateReason &&
                                                        !formVM.validateHour &&
                                                        !formVM.validEmployee) {
                                                      formVM
                                                          .createOvertimeRequest(
                                                              context: context);
                                                    }
                                                  }
                                                }),
                                            widthSpace,
                                            ButtonCustom(
                                                isExpan: true,
                                                icon: Icons.add_rounded,
                                                text: 'Add Line',
                                                color: amberColor,
                                                onTap: () {
                                                  formVM.onValidation(context);
                                                  if (!formVM.validateReason &&
                                                      !formVM.validateHour &&
                                                      !formVM.validEmployee) {
                                                    formVM.onStoreLocalMutli();
                                                  }
                                                })
                                          ])),
                              ...multiheithSpace(3)
                            ],

                            if (hasData()) ...[
                              Padding(
                                  padding: EdgeInsets.all(mainPadding),
                                  child: WidgetCommentLogNote(
                                      resId: widget.overtime!.id,
                                      model: requestEmployeeOvertime)),
                              heithSpace
                            ]
                          ])),
                  if (formVM.isLoading) ...[
                    Container(
                        color: Colors.black.withOpacity(0.5), // Glass effect
                        child: const Center(child: CircularProgressIndicator()))
                  ]
                ]));
    });
  }
}
