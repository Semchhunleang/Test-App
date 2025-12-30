import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/models/supporthub/erp/erp_ticket.dart';
import 'package:umgkh_mobile/utils/odoo_model.dart';
import 'package:umgkh_mobile/utils/static_state.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'package:umgkh_mobile/view_models/log_note_form_view_model.dart';
import 'package:umgkh_mobile/view_models/log_note_view_model.dart';
import 'package:umgkh_mobile/view_models/supporthub/erp_team/request_contact_form_view_model.dart';
import 'package:umgkh_mobile/view_models/selections_view_model.dart';
import 'package:umgkh_mobile/views/pages/supporthub/erp_team/widget/widget_image.dart';
import 'package:umgkh_mobile/views/pages/log_note/widget_comment_log_note.dart';
import 'package:umgkh_mobile/widgets/button_custom.dart';
import 'package:umgkh_mobile/widgets/custom_drop_list.dart';
import 'package:umgkh_mobile/widgets/custom_scaffold.dart';
import 'package:umgkh_mobile/widgets/custom_state_bar.dart';
import 'package:umgkh_mobile/widgets/textfield.dart';

class ERPRequestContactFormAndInfoPage extends StatefulWidget {
  final ERPTicket? data;
  static const routeName = '/form-request-contact';

  const ERPRequestContactFormAndInfoPage({super.key, this.data});

  @override
  State<ERPRequestContactFormAndInfoPage> createState() =>
      _ERPRequestContactFormAndInfoPageState();
}

class _ERPRequestContactFormAndInfoPageState
    extends State<ERPRequestContactFormAndInfoPage> {
  @override
  void initState() {
    final vm = Provider.of<RequestContactFormViewModel>(context, listen: false);
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
    if (hasData()) vmLN.fetchData(widget.data!.id, supportHubTicket);
    if (hasData()) vmLNF.resetForm();
  }

  @override
  Widget build(BuildContext context) => Consumer<RequestContactFormViewModel>(
      builder: (context, viewModel, _) => CustomScaffold(
          title: 'ERP Request Contact',
          resizeToAvoidBottomInset: true,
          isLoading: viewModel.isLoading,
          body: Column(children: [
            if (hasData()) ...[
              CustomStateBar(
                  text: widget.data!.state.toUpperCase(),
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
                      title: 'Name',
                      hint: 'Enter name',
                      readOnly: viewModel.isReadOnly,
                      readOnlyAndFilled: viewModel.isReadOnly,
                      enableSelectText: !viewModel.isReadOnly,
                      isValidate: viewModel.isName,
                      validatedText: viewModel.isName ? 'Required field' : '',
                      onChanged: viewModel.onChangeName),
                  heithSpace,
                  Row(children: [
                    Expanded(
                        flex: 5,
                        child: InputTextField(
                            ctrl: viewModel.contactCtrl,
                            title: 'Contact',
                            hint: 'Enter contact',
                            readOnly: viewModel.isReadOnly,
                            readOnlyAndFilled: viewModel.isReadOnly,
                            enableSelectText: !viewModel.isReadOnly,
                            isValidate: viewModel.isContact,
                            validatedText:
                                viewModel.isContact ? 'Required field' : '',
                            onChanged: viewModel.onChangeContact)),
                    widthSpace,
                    Expanded(
                        flex: 4,
                        child: Consumer<SelectionsViewModel>(
                            builder: (context, vm, _) => CustomDropList(
                                titleHead: 'Type',
                                selected: viewModel.selectType,
                                readOnlyAndFilled: viewModel.isReadOnly,
                                enabled: !viewModel.isReadOnly,
                                items: vm.contactType.toList(),
                                itemAsString: (i) => i.name.toString(),
                                onChanged: viewModel.onChangeType)))
                  ]),
                  heithSpace,

                  Row(children: [
                    Expanded(
                        flex: 5,
                        child: Consumer<SelectionsViewModel>(
                            builder: (context, vm, _) => CustomDropList(
                                titleHead: 'Salesperson',
                                selected: viewModel.selectSalesperson,
                                readOnlyAndFilled: viewModel.isReadOnly,
                                enabled: !viewModel.isReadOnly,
                                isSearch: true,
                                items: vm.employees.toList(),
                                itemAsString: (i) => i.name.toString(),
                                onChanged: viewModel.onChangeSalePerson))),
                    if (hasAssignee()) ...[
                      widthSpace,
                      Expanded(
                          flex: 4,
                          child: InputTextField(
                              ctrl: viewModel.assigneeCtrl,
                              title: 'Assignee',
                              readOnly: true,
                              readOnlyAndFilled: true,
                              enableSelectText: false))
                    ]
                  ]),
                  heithSpace,

                  if (hasRejectReason()) ...[
                    MutliLineTextField(
                        ctrl: viewModel.rejectReasonCtrl,
                        title: 'Reject Reason',
                        maxLine: null,
                        readOnly: true,
                        readOnlyAndFilled: viewModel.isReadOnly,
                        enableSelectText: false),
                    heithSpace
                  ],

                  MutliLineTextField(
                      ctrl: viewModel.descCtrl,
                      title: 'Description',
                      hint: 'Enter description',
                      readOnly: viewModel.isReadOnly,
                      readOnlyAndFilled: viewModel.isReadOnly,
                      enableSelectText: !viewModel.isReadOnly,
                      isValidate: viewModel.isDesc,
                      validatedText: viewModel.isDesc ? 'Required field' : '',
                      onChanged: viewModel.onChangeDesc),
                  heithSpace,

                  // images picker and show image
                  BuildWidgetERPSupportHubImage(
                      onFile: () => viewModel.filePicker(),
                      onGallery: () => viewModel.imagePicker(false),
                      onCamera: () => viewModel.imagePicker(true),
                      files: viewModel.selectedFiles,
                      isPictures: viewModel.isFiles,
                      pictures: viewModel.selectedPictures,
                      data: widget.data),

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
  bool hasAssignee() => (hasData() && widget.data!.assignee != null);
  bool hasRejectReason() => (hasData() &&
      (widget.data!.rejectReason != null && widget.data!.state == reject));

  onCreateOrUpdate(RequestContactFormViewModel p) {
    if (!p.isValidated()) {
      hasData()
          ? p.updateData(context, widget.data!.id)
          : p.insertData(context);
    }
  }
}
