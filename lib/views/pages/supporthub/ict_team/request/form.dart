import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/models/supporthub/ict/ict_ticket.dart';
import 'package:umgkh_mobile/utils/odoo_model.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'package:umgkh_mobile/view_models/supporthub/ict_team/ict_ticket_form_view_model.dart';
import 'package:umgkh_mobile/view_models/log_note_form_view_model.dart';
import 'package:umgkh_mobile/view_models/log_note_view_model.dart';
import 'package:umgkh_mobile/view_models/selections_view_model.dart';
import 'package:umgkh_mobile/views/pages/supporthub/ict_team/widget/widget_image.dart';
import 'package:umgkh_mobile/views/pages/log_note/widget_comment_log_note.dart';
import 'package:umgkh_mobile/widgets/button_custom.dart';
import 'package:umgkh_mobile/widgets/custom_drop_list.dart';
import 'package:umgkh_mobile/widgets/custom_scaffold.dart';
import 'package:umgkh_mobile/widgets/custom_selected_date.dart';
import 'package:umgkh_mobile/widgets/custom_state_bar.dart';
import 'package:umgkh_mobile/widgets/textfield.dart';

class RequestICTTicketFormAndInfoPage extends StatefulWidget {
  final ICTTicket? data;
  static const routeName = '/form-request-ict-ticket';

  const RequestICTTicketFormAndInfoPage({super.key, this.data});

  @override
  State<RequestICTTicketFormAndInfoPage> createState() =>
      _RequestICTTicketFormAndInfoPageState();
}

class _RequestICTTicketFormAndInfoPageState
    extends State<RequestICTTicketFormAndInfoPage> {
  @override
  void initState() {
    final vm = Provider.of<ICTTicketFormViewModel>(context, listen: false);
    if (hasData()) vm.checkReadOnly(widget.data!.state);
    vm.resetValidate();
    vm.resetForm();
    if (!hasData()) vm.resetReadOnly();
    if (hasData()) vm.setInfo(widget.data!);
    if (hasData()) vm.downloadFile(widget.data!.files);
    fetchLogNote();

    super.initState();
  }

  Future<void> fetchLogNote() async {
    final vmLN = Provider.of<LogNoteViewModel>(context, listen: false);
    final vmLNF = Provider.of<LogNoteFormViewModel>(context, listen: false);
    if (widget.data != null) {
      vmLN.fetchData(widget.data!.id, supportHubTicket);
      vmLNF.resetForm();
    }
  }

  @override
  Widget build(BuildContext context) => Consumer<ICTTicketFormViewModel>(
      builder: (context, viewModel, _) => CustomScaffold(
          title: 'Request ICT Ticket',
          resizeToAvoidBottomInset: true,
          isLoading: viewModel.isLoading,
          body: Column(children: [
            if (hasData()) ...[
              CustomStateBar(
                  text: stateTitle(widget.data!.state.toLowerCase()),
                  color: stateColor(widget.data!.state)),
              heithSpace
            ],

            // info as form
            Expanded(
                child: ListView(
                    physics: kBounce,
                    padding: EdgeInsets.symmetric(horizontal: mainPadding),
                    children: [
                  InputTextField(
                      ctrl: viewModel.nameCtrl,
                      title: 'Problem',
                      hint: 'Enter problem',
                      readOnly: viewModel.isReadOnly,
                      readOnlyAndFilled: viewModel.isReadOnly,
                      enableSelectText: !viewModel.isReadOnly,
                      isValidate: viewModel.isName,
                      validatedText: viewModel.isName ? 'Required field' : '',
                      onChanged: viewModel.onChangeName),
                  heithSpace,
                  Row(children: [
                    // priority
                    Consumer<SelectionsViewModel>(
                        builder: (context, vm, _) => Expanded(
                            flex: 4,
                            child: CustomDropList(
                                titleHead: 'Priority',
                                enabled: !viewModel.isReadOnly,
                                readOnlyAndFilled: viewModel.isReadOnly,
                                selected: viewModel.selectPriority,
                                items: vm.supportHubPriority.toList(),
                                itemAsString: (i) => i.name.toString(),
                                onChanged: viewModel.onChangedPriority))),
                    widthSpace,
                    // category
                    Consumer<SelectionsViewModel>(
                        builder: (context, vm, _) => Expanded(
                            flex: 5,
                            child: CustomDropList(
                                titleHead: 'Category',
                                enabled: !viewModel.isReadOnly,
                                readOnlyAndFilled: viewModel.isReadOnly,
                                selected: viewModel.selectCategory,
                                items: vm.ictRequestCategory.toList(),
                                itemAsString: (i) => i.name.toString(),
                                onChanged: viewModel.onChangedCategory)))
                  ]),
                  heithSpace,
                  // device as multi
                  Row(children: [
                    Consumer<SelectionsViewModel>(
                        builder: (context, vm, _) => Expanded(
                                child: CustomMultiDropList(
                              titleHead: 'ICT Devices',
                              enabled: !viewModel.isReadOnly,
                              readOnlyAndFilled: viewModel.isReadOnly,
                              selected: viewModel.selectDevices,
                              items: vm.ictDevice
                                  .where((e) => !viewModel.selectDevices
                                      .any((selected) => selected.id == e.id))
                                  .toList(),
                              itemAsString: (i) => i.name.toString(),
                              onChanged: viewModel.onChangedDevices,
                              onRemove: viewModel.onRemoveDevices,
                            )))
                  ]),
                  heithSpace,

                  if (hasAssignee()) ...[
                    InputTextField(
                        ctrl: viewModel.assigneeCtrl,
                        title: 'Assignee',
                        readOnly: true,
                        readOnlyAndFilled: true,
                        enableSelectText: false),
                    heithSpace
                  ],
                  Row(children: [
                    if (hasAssignDT()) ...[
                      Expanded(
                          child: CustomSelectDate(
                              ctrl: viewModel.assignedDTCtrl,
                              readOnlyAndFilled: true,
                              title: 'Assigned DT'))
                    ],
                    if (hasAssignDT() && hasCloseTicketDT()) widthSpace,
                    if (hasCloseTicketDT()) ...[
                      Expanded(
                          child: CustomSelectDate(
                              ctrl: viewModel.closeTicketDTCtrl,
                              readOnlyAndFilled: true,
                              title: 'Close Ticket DT'))
                    ]
                  ]),
                  if (hasAssignDT() || hasCloseTicketDT()) heithSpace,

                  MutliLineTextField(
                      ctrl: viewModel.summaryCtrl,
                      title: 'Summary',
                      hint: 'Enter summary',
                      readOnly: viewModel.isReadOnly,
                      readOnlyAndFilled: viewModel.isReadOnly,
                      enableSelectText: !viewModel.isReadOnly,
                      isValidate: viewModel.isDesc,
                      validatedText: viewModel.isDesc ? 'Required field' : '',
                      onChanged: viewModel.onChangeDesc),
                  heith10Space,

                  // images picker and show image
                  BuildWidgetICTSupportHubImage(
                    files: viewModel.files,
                    pictures: viewModel.pictures,
                    onGallery: () => viewModel.imagePicker(context, false),
                    onCamera: () => viewModel.imagePicker(context, true),
                    onFile: () => viewModel.filePicker(context),
                    data: widget.data,
                    isPictures: false, // for img is require
                  ),

                  viewModel.isReadOnly
                      ? Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: mainPadding * 2,
                              horizontal: mainPadding * 3),
                          child: Divider(
                              color: greyColor.withOpacity(0.5), height: 5))
                      : Padding(
                          padding: EdgeInsets.all(mainPadding * 3),
                          child: ButtonCustom(
                              text: hasData() ? 'Update' : 'Submit',
                              color: greenColor,
                              onTap: () => onCreateOrUpdate(viewModel))),

                  if (hasData()) ...[
                    WidgetCommentLogNote(
                        resId: widget.data!.id, model: supportHubTicket),
                    heithSpace
                  ]
                ]))
          ])));

  bool hasData() => widget.data != null;
  bool hasAssignee() => hasData() && widget.data!.assignee != null;
  bool hasAssignDT() => hasData() && widget.data!.assignedDT != null;
  bool hasCloseTicketDT() => hasData() && widget.data!.closeTicketDT != null;

  onCreateOrUpdate(ICTTicketFormViewModel vm) {
    if (!vm.isValidated()) {
      hasData()
          ? vm.updateData(
              context, widget.data!.id, widget.data!.state.toLowerCase())
          : vm.insertData(context);
    }
  }
}
