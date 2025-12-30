import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/models/supporthub/marketing/marketing_ticket.dart';
import 'package:umgkh_mobile/utils/odoo_model.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'package:umgkh_mobile/view_models/log_note_form_view_model.dart';
import 'package:umgkh_mobile/view_models/log_note_view_model.dart';
import 'package:umgkh_mobile/view_models/selections_view_model.dart';
import 'package:umgkh_mobile/view_models/supporthub/marketing_team/marketing_ticket_form_view_model.dart';
import 'package:umgkh_mobile/views/pages/log_note/widget_comment_log_note.dart';
import 'package:umgkh_mobile/views/pages/supporthub/marketing_team/widget/widget_image.dart';
import 'package:umgkh_mobile/widgets/button_custom.dart';
import 'package:umgkh_mobile/widgets/custom_drop_list.dart';
import 'package:umgkh_mobile/widgets/custom_scaffold.dart';
import 'package:umgkh_mobile/widgets/custom_selected_date.dart';
import 'package:umgkh_mobile/widgets/custom_state_bar.dart';
import 'package:umgkh_mobile/widgets/textfield.dart';

class RequestMarketingTicketFormAndInfoPage extends StatefulWidget {
  final MarketingTicket? data;
  static const routeName = '/form-request-marketing-ticket';

  const RequestMarketingTicketFormAndInfoPage({super.key, this.data});

  @override
  State<RequestMarketingTicketFormAndInfoPage> createState() =>
      _RequestMarketingTicketFormAndInfoPageState();
}

class _RequestMarketingTicketFormAndInfoPageState
    extends State<RequestMarketingTicketFormAndInfoPage> {
  @override
  void initState() {
    final vm =
        Provider.of<MarketingTicketFormViewModel>(context, listen: false);
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
  Widget build(BuildContext context) => Consumer<MarketingTicketFormViewModel>(
      builder: (context, viewModel, _) => CustomScaffold(
          title: 'Request Marketing Ticket',
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
                  Consumer<SelectionsViewModel>(
                      builder: (context, vm, _) => CustomDropList(
                          titleHead: 'Type',
                          enabled: !viewModel.isReadOnly,
                          readOnlyAndFilled: viewModel.isReadOnly,
                          selected: viewModel.type,
                          isValidate: viewModel.isTypeEmpty,
                          items: vm.marketingProductType.toList(),
                          itemAsString: (i) => i.name.toString(),
                          onChanged: viewModel.onChangedType)),
                  if (viewModel.type.name.toLowerCase() == "catalog")
                    heithSpace,
                  if (viewModel.type.name.toLowerCase() == "catalog")
                    Consumer<SelectionsViewModel>(
                      builder: (context, vm, _) => CustomDropList(
                        titleHead: 'Model',
                        enabled: !viewModel.isReadOnly,
                        isSearch: true,
                        isSearchCreate: true,
                        isValidate: viewModel.isProductModelEmpty,
                        readOnlyAndFilled: viewModel.isReadOnly,
                        selected: viewModel.productModel,
                        items: vm.productModel.toList(),
                        itemAsString: (i) => i.name.toString(),
                        onChanged: viewModel.onChangedProductModel,
                        onCreate: (newName) =>
                            viewModel.onCreateProductModel(newName),
                      ),
                    ),
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
                              ctrl: viewModel.doneDTCtrl,
                              readOnlyAndFilled: true,
                              title: 'Done Ticket DT'))
                    ]
                  ]),
                  if (hasAssignDT() || hasCloseTicketDT()) heithSpace,

                  MutliLineTextField(
                      ctrl: viewModel.remarkCtrl,
                      title: 'Remark',
                      hint: 'Enter remark',
                      readOnly: viewModel.isReadOnly,
                      readOnlyAndFilled: viewModel.isReadOnly,
                      enableSelectText: !viewModel.isReadOnly,
                      isValidate: viewModel.isDesc,
                      validatedText: viewModel.isDesc ? 'Required field' : '',
                      onChanged: viewModel.onChangeDesc),
                  heith10Space,

                  // images picker and show image
                  BuildWidgetMarketingSupportHubImage(
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
  bool hasCloseTicketDT() => hasData() && widget.data!.doneDt != null;

  onCreateOrUpdate(MarketingTicketFormViewModel vm) {
    if (!vm.isValidated()) {
      hasData()
          ? vm.updateData(
              context, widget.data!.id, widget.data!.state.toLowerCase())
          : vm.insertData(context);
    }
  }
}
