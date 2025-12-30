import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/models/supporthub/erp/erp_ticket.dart';
import 'package:umgkh_mobile/utils/constants.dart';
import 'package:umgkh_mobile/utils/image_picker.dart';
import 'package:umgkh_mobile/utils/odoo_model.dart';
import 'package:umgkh_mobile/utils/static_state.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'package:umgkh_mobile/view_models/log_note_form_view_model.dart';
import 'package:umgkh_mobile/view_models/log_note_view_model.dart';
import 'package:umgkh_mobile/view_models/supporthub/erp_team/request_contact_product_form_view_model.dart';
import 'package:umgkh_mobile/views/pages/image/widget/widget_network_image.dart';
import 'package:umgkh_mobile/views/pages/log_note/widget_comment_log_note.dart';
import 'package:umgkh_mobile/widgets/custom_scaffold.dart';
import 'package:umgkh_mobile/widgets/custom_state_bar.dart';
import 'package:umgkh_mobile/widgets/textfield.dart';

class RequestContactAndProductFormAndInfoPage extends StatefulWidget {
  final ERPTicket data;
  final String type;

  const RequestContactAndProductFormAndInfoPage(
      {super.key, required this.data, required this.type});

  @override
  State<RequestContactAndProductFormAndInfoPage> createState() =>
      _RequestContactAndProductFormAndInfoPageState();
}

class _RequestContactAndProductFormAndInfoPageState
    extends State<RequestContactAndProductFormAndInfoPage> {
  @override
  void initState() {
    final vm =
        Provider.of<RequestContactProductFormViewModel>(context, listen: false);
    vm.resetForm();
    vm.setInfo(widget.data);
    vm.downloadFile(widget.data.files);
    fetchLogNote();
    super.initState();
  }

  Future<void> fetchLogNote() async {
    final vmLN = Provider.of<LogNoteViewModel>(context, listen: false);
    final vmLNF = Provider.of<LogNoteFormViewModel>(context, listen: false);
    vmLN.fetchData(widget.data.id, supportHubTicket);
    vmLNF.resetForm();
  }

  bool hasContact() => widget.data.contact.isNotEmpty;
  bool hasContactType() => widget.data.contactType != null;
  bool hasAssignee() => widget.data.assignee != null;
  bool hasSalesperson() => widget.data.salesperson != null;
  bool hasRejectReason() =>
      widget.data.rejectReason != null && widget.data.state == reject;

  @override
  Widget build(BuildContext context) =>
      Consumer<RequestContactProductFormViewModel>(
          builder: (context, viewModel, _) => CustomScaffold(
              title: 'Request ${toTitleCase(widget.type)} Information',
              resizeToAvoidBottomInset: true,
              isLoading: viewModel.isLoading,
              body: Column(children: [
                CustomStateBar(
                    text: widget.data.state.toUpperCase(),
                    color: stateColor(widget.data.state)),
                heithSpace,

                // info as form
                Expanded(
                    child: ListView(
                        physics: kBounce,
                        padding: EdgeInsets.symmetric(horizontal: mainPadding),
                        children: [
                      InputTextField(
                          ctrl: viewModel.nameCtrl,
                          title: 'Name',
                          readOnly: true,
                          readOnlyAndFilled: true,
                          enableSelectText: false),
                      heithSpace,
                      InputTextField(
                          ctrl: viewModel.requestorCtrl,
                          title: 'Requestor',
                          readOnly: true,
                          readOnlyAndFilled: true,
                          enableSelectText: false),
                      heithSpace,
                      Row(children: [
                        if (hasContact()) ...[
                          Expanded(
                              child: InputTextField(
                                  ctrl: viewModel.contactCtrl,
                                  title: 'Contact',
                                  readOnly: true,
                                  readOnlyAndFilled: true,
                                  enableSelectText: false))
                        ],
                        if (hasContactType()) widthSpace,
                        if (hasContactType()) ...[
                          Expanded(
                              child: InputTextField(
                                  ctrl: viewModel.contactTypeCtrl,
                                  title: 'Type',
                                  readOnly: true,
                                  readOnlyAndFilled: true,
                                  enableSelectText: false))
                        ]
                      ]),
                      if (hasContact() || hasContactType()) heithSpace,
                      Row(children: [
                        if (hasSalesperson()) ...[
                          Expanded(
                              child: InputTextField(
                                  ctrl: viewModel.salespersonCtrl,
                                  title: 'Salesperson',
                                  readOnly: true,
                                  readOnlyAndFilled: true,
                                  enableSelectText: false))
                        ],
                        if (hasSalesperson() && hasAssignee()) widthSpace,
                        if (hasAssignee()) ...[
                          Expanded(
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
                            readOnlyAndFilled: true,
                            enableSelectText: false),
                        heithSpace
                      ],

                      MutliLineTextField(
                          ctrl: viewModel.descCtrl,
                          title: 'Description',
                          maxLine: null,
                          readOnly: true,
                          readOnlyAndFilled: true,
                          enableSelectText: false),
                      ...multiheithSpace(2),

                      // images picker and show image
                      if (viewModel.hasAttach) ...[buildImageApi(widget.data)],

                      // button
                      // Padding(
                      //     padding: EdgeInsets.all(mainPadding * 2),
                      //     child: Row(children: [
                      //       ButtonCustom(
                      //           isExpan: true,
                      //           text: 'DONE',
                      //           color: greenColor,
                      //           onTap: () {}),
                      //       width10Space,
                      //       ButtonCustom(
                      //           isExpan: true,
                      //           text: 'REJECT',
                      //           color: redColor,
                      //           onTap: () {})
                      //     ])),

                      Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: mainPadding * 2,
                              horizontal: mainPadding * 3),
                          child: Divider(
                              color: greyColor.withOpacity(0.5), height: 5)),
                      WidgetCommentLogNote(
                          resId: widget.data.id, model: supportHubTicket),

                      ...multiheithSpace(3)
                    ]))
              ])));

  Widget buildImageApi(ERPTicket data) =>
      Consumer<RequestContactProductFormViewModel>(
          builder: (context, viewModel, _) => Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(mainRadius)),
              color: primaryColor.withOpacity(0.1),
              child: Column(children: [
                // files as list
                ListView.builder(
                    shrinkWrap: true,
                    physics: neverScroll,
                    itemCount: data.files.length,
                    padding: EdgeInsets.fromLTRB(
                        mainPadding, mainPadding, mainPadding, 0),
                    itemBuilder: (context, i) => Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(mainRadius / 2)),
                        child: InkWell(
                            onTap: () {
                              final file = viewModel.downloadedFiles
                                  .firstWhere((d) => d.id == data.files[i].id);
                              openFiles(file.downloadedFile);
                            },
                            borderRadius: BorderRadius.circular(mainRadius / 2),
                            highlightColor: primaryColor.withOpacity(0.1),
                            splashColor: primaryColor.withOpacity(0.1),
                            child: Row(children: [
                              width5Space,
                              Icon(getIconExt(data.files[i].extension),
                                  color: primaryColor, size: 20),
                              width5Space,
                              Expanded(
                                  child: Text(data.files[i].name,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: titleStyle13)),
                              const IconButton(
                                  icon: Icon(null, size: 20), onPressed: null)
                            ])))),

                data.files.isNotEmpty && data.images.isNotEmpty
                    ? heith10Space
                    : sizedBoxShrink,

                // image as grid
                GridView.builder(
                    shrinkWrap: true,
                    physics: neverScroll,
                    padding: EdgeInsets.fromLTRB(
                        mainPadding, 0, mainPadding, mainPadding),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: mainPadding,
                        mainAxisSpacing: mainPadding),
                    itemCount: data.images.length,
                    itemBuilder: (context, i) => WidgetNetworkImage(
                        firstImg: Constants.attachmentById(data.images[i]),
                        index: i,
                        fullImage: data.images
                            .map((e) => Constants.attachmentById(e))
                            .toList(),
                        onDelete: null))
              ])));
}
