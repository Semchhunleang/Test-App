import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/models/hr/leave/leave.dart';
import 'package:umgkh_mobile/models/hr/leave/leave_type.dart';
import 'package:umgkh_mobile/utils/odoo_model.dart';
import 'package:umgkh_mobile/utils/static_state.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'package:umgkh_mobile/view_models/access_levels_view_model.dart';
import 'package:umgkh_mobile/view_models/log_note_form_view_model.dart';
import 'package:umgkh_mobile/view_models/log_note_view_model.dart';
import 'package:umgkh_mobile/view_models/profile_view_model.dart';
import 'package:umgkh_mobile/view_models/share_widget_view_model.dart';
import 'package:umgkh_mobile/view_models/take_leave_form_view_model.dart';
import 'package:umgkh_mobile/views/pages/hr/approve_leave/widget/dialog_detail_approval.dart';
import 'package:umgkh_mobile/views/pages/hr/take_leave/widget/approval_leave_summary_dept_widget.dart';
import 'package:umgkh_mobile/views/pages/hr/take_leave/widget/approval_leave_summary_emp_widget.dart';
import 'package:umgkh_mobile/views/pages/hr/take_leave/widget/checkbox_day.dart';
import 'package:umgkh_mobile/views/pages/hr/take_leave/widget/custom_drop_leave_type.dart';
import 'package:umgkh_mobile/views/pages/hr/take_leave/widget/custom_drop_period.dart';
import 'package:umgkh_mobile/views/pages/hr/take_leave/widget/widget_button_share.dart';
import 'package:umgkh_mobile/views/pages/log_note/widget_comment_log_note.dart';
import 'package:umgkh_mobile/widgets/button_custom.dart';
import 'package:umgkh_mobile/widgets/custom_scaffold.dart';
import 'package:umgkh_mobile/widgets/custom_selected_date.dart';
import 'package:umgkh_mobile/widgets/custom_state_bar.dart';
import 'package:umgkh_mobile/widgets/textfield.dart';

class TakeLeaveFormPage extends StatefulWidget {
  static const routeName = '/form-take-leave';
  static const pageName = 'Take Leave';
  final Leave? leave;
  const TakeLeaveFormPage({super.key, this.leave});

  @override
  State<TakeLeaveFormPage> createState() => _TakeLeaveFormPageState();
}

class _TakeLeaveFormPageState extends State<TakeLeaveFormPage> {
  final Map<String, bool?> validator = {
    "date": false,
    "type": false,
    "description": false,
  };

  @override
  void initState() {
    super.initState();
    _fetchData();
    // set leave info
    _fetchLogNote();
    _initCaptureWidget();
  }

  Future<void> _fetchData() async {
    if (mounted) {
      await Provider.of<TakeLeaveFormViewModel>(context, listen: false)
          .resetVariable();
      // await Provider.of<TakeLeaveFormViewModel>(context, listen: false)
      //     .fetchLeaveTypes();
    }
    if (mounted) {
      await Provider.of<TakeLeaveFormViewModel>(context, listen: false)
          .fetchPublicHoliday();
    }
  }

  _initCaptureWidget() {
    if (widget.leave != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final vm = Provider.of<ShareWidgetViewModel>(context, listen: false);
        vm.resetForm();
        vm.captureWidget(context, widget.leave!);
      });
    }
  }

  Future<void> _fetchLogNote() async {
    final vm = Provider.of<TakeLeaveFormViewModel>(context, listen: false);
    final vmLN = Provider.of<LogNoteViewModel>(context, listen: false);
    final vmLNF = Provider.of<LogNoteFormViewModel>(context, listen: false);
    if (widget.leave != null) {
      vm.setInfo(widget.leave!);
      vmLN.fetchData(widget.leave!.id, hrLeave);
      vmLNF.resetForm();
    } else {
      vm.resetVariable();
    }
  }

  Future<void> _selectDate(BuildContext context,
      TakeLeaveFormViewModel viewModel, bool isStart) async {
    DateTime initialDate = isStart
        ? DateTime.parse(viewModel.startDateInput.text)
        : DateTime.parse(viewModel.endDateInput.text);

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      viewModel.setDate(formattedDate, isStart);
    }
  }

  void _submitForm(TakeLeaveFormViewModel viewModel) async {
    setState(() {
      validator["date"] = viewModel.startDateInput.text.isEmpty;
      //  ||  viewModel.endDateInput.text?.isEmpty ?? true;
      validator["type"] = viewModel.selectedLeaveType == null;
      validator["description"] = viewModel.descriptionCtrl.text.isEmpty;
    });

    if (validator["date"] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Please select both start and end dates.")),
      );
    } else if (validator["type"] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a leave type.")),
      );
    } else if (validator["description"] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill the Description.")),
      );
    } else {
      if (viewModel.isLoading == false) {
        await Provider.of<TakeLeaveFormViewModel>(context, listen: false)
            .insert(context);
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // precacheImage(const AssetImage('assets/icons/social/umg.jpg'), context);
    precacheImage(const AssetImage('assets/icons/social/nenam.png'), context);
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      resizeToAvoidBottomInset: true,
      title: TakeLeaveFormPage.pageName,
      action: [
        // leave !null & login user is the owner leave
        if (widget.leave != null &&
            widget.leave!.user.id ==
                Provider.of<ProfileViewModel>(context, listen: false)
                    .user
                    .id) ...[buildTextShare(context, widget.leave!)]
      ],
      body: Consumer3<TakeLeaveFormViewModel, AccessLevelViewModel,
          ProfileViewModel>(
        builder:
            (context, viewModel, accessLevelViewModel, userViewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (viewModel.apiResponse.error != null) {
            return Center(
                child: Text(viewModel.apiResponse.error ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold)));
          }

          return SingleChildScrollView(
            physics: kBounce,
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                if (viewModel.isReadOnly) ...[
                  CustomStateBar(
                      text: titleLeaveStatus(widget.leave!.state),
                      color: colorLeaveStatus(widget.leave!.state)),
                  heithSpace
                ],
                if (widget.leave != null &&
                    widget.leave!.user.id != userViewModel.user.id) ...[
                  ApprovalLeaveSummaryEmpWidget(
                      employeeId: widget.leave!.user.id,
                      employeeName: widget.leave!.user.name)
                ],
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      mainPadding, 0, mainPadding, mainPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Expanded(
                            child: CustomSelectDate(
                                ctrl: viewModel.startDateInput,
                                title: 'Start Date',
                                readOnlyAndFilled: viewModel.isReadOnly,
                                onTap: () async => await _selectDate(
                                    context, viewModel, true))),
                        width10Space,
                        viewModel.isHalfDay
                            ? CustomDropPeriod(
                                readOnly: viewModel.isReadOnly,
                                dropValue: viewModel.requestDateFromPeriod,
                                onChanged: (v) =>
                                    viewModel.setRequestDateFromPeriod(v))
                            : Expanded(
                                child: CustomSelectDate(
                                    ctrl: viewModel.endDateInput,
                                    title: 'End Date',
                                    readOnlyAndFilled: viewModel.isReadOnly,
                                    onTap: () async => await _selectDate(
                                        context, viewModel, false)))
                      ]),
                      if (validator['date'] == true)
                        const Text("Start date cannot be after end date",
                            style: TextStyle(color: Colors.red)),
                      if (!viewModel.isSaturday) ...[
                        const SizedBox(height: 10),
                        viewModel.isReadOnly && !viewModel.isHalfDay
                            ? sizedBoxShrink
                            : CheckBoxDay(
                                isCheck: viewModel.isHalfDay,
                                onChanged: (v) => viewModel.isReadOnly
                                    ? null
                                    : viewModel.toggleIsHalfDay())
                      ],
                      if (viewModel.isSaturday) const Divider(),
                      if (viewModel.listLeaveType!.isNotEmpty) ...[
                        viewModel.isReadOnly // leave type: read only for info
                            ? CustomDropLeaveType(
                                readOnly: viewModel.isReadOnly,
                                dropdownvalue: widget.leave!.leaveType,
                                items: [widget.leave!.leaveType],
                                onChanged: (LeaveType? value) {})
                            : CustomDropLeaveType(
                                dropdownvalue: viewModel.selectedLeaveType,
                                items: viewModel.listLeaveType!,
                                onChanged: (LeaveType? newValue) =>
                                    viewModel.setSelectedLeaveType(newValue))
                      ],
                      if (validator['type'] == true)
                        Text("\t\tPlease select a leave type",
                            style: hintStyle.copyWith(color: redColor)),
                      const SizedBox(height: 10),
                      Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Row(children: [
                            Text("Duration: ", style: titleStyle13),
                            Text("${viewModel.duration} Day",
                                style: primary13Bold)
                          ])),
                      const SizedBox(height: 10),
                      MutliLineTextField(
                          ctrl: viewModel.descriptionCtrl,
                          title: 'Description',
                          readOnly: viewModel.isReadOnly,
                          readOnlyAndFilled: viewModel.isReadOnly),
                      if (validator['description'] == true)
                        Text("\tPlease fill description",
                            style: hintStyle.copyWith(color: redColor)),
                      const SizedBox(height: 20),
                      viewModel.isReadOnly
                          ? sizedBoxShrink
                          : Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: mainPadding * 2),
                              child: Row(children: [
                                ButtonCustom(
                                    isExpan: true,
                                    text: 'Submit',
                                    onTap: () => _submitForm(viewModel))
                              ])),

                      // comments log note section
                      if (viewModel.isReadOnly) ...[
                        if ((accessLevelViewModel.accessLevel.isDh == 1 &&
                                userViewModel.user.id !=
                                    widget.leave!.user.id) &&
                            widget.leave!.state == confirm) ...[
                          WidgetApprovalLeaveButton(leave: widget.leave!),
                          heithSpace
                        ],
                        if (widget.leave != null &&
                            widget.leave!.user.id != userViewModel.user.id) ...[
                          ApprovalLeaveSummaryDeptWidget(
                            deptId: widget.leave!.user.department != null
                                ? widget.leave!.user.department!.id
                                : 0,
                            deptName: widget.leave!.user.department != null
                                ? widget.leave!.user.department!.name
                                : '',
                          )
                        ],
                        WidgetCommentLogNote(
                            resId: widget.leave!.id, model: hrLeave)
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
