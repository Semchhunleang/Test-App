import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/models/am/small_paper/small_paper.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'package:umgkh_mobile/view_models/access_levels_view_model.dart';
import 'package:umgkh_mobile/view_models/small_paper_form_view_model.dart';
import 'package:umgkh_mobile/views/pages/am/small_paper/widget/utils_widget.dart';
import 'package:umgkh_mobile/views/pages/am/small_paper/widget/widget_view_image.dart';
import 'package:umgkh_mobile/widgets/button_custom.dart';
import 'package:umgkh_mobile/widgets/custom_scaffold.dart';
import 'package:umgkh_mobile/widgets/custom_selected_date.dart';
import 'package:umgkh_mobile/widgets/textfield.dart';
import '../../../../utils/static_state.dart';

class SmallPaperFormAndInfoPage extends StatefulWidget {
  final bool isForm;
  final SmallPaper? data;

  const SmallPaperFormAndInfoPage({super.key, this.isForm = true, this.data});

  @override
  State<SmallPaperFormAndInfoPage> createState() =>
      _SmallPaperFormAndInfoPageState();
}

class _SmallPaperFormAndInfoPageState extends State<SmallPaperFormAndInfoPage> {
  late String title;
  @override
  void initState() {
    final p = Provider.of<SmallPaperFormViewModel>(context, listen: false);
    if (notNullData()) {
      p.checkReadOnly(widget.data!.state, context, widget.data!.requestor.id);
    }
    p.resetValidate();
    p.resetForm(context);
    if (widget.isForm) p.resetReadOnly();
    if (!widget.isForm && widget.data != null) p.setInfo(widget.data!);

    title = widget.isForm ? 'Small Paper Form' : 'Small Paper Info';
    super.initState();
  }

  @override
  Widget build(BuildContext context) =>
      Consumer2<SmallPaperFormViewModel, AccessLevelViewModel>(
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
                                ctrl: formVM.plannedDTCtrl,
                                title: 'Planned DT',
                                onTap: formVM.isReadOnly
                                    ? null
                                    : () => formVM.selectDateTime(context))),
                        widthSpace,
                        widget.data != null &&
                                widget.data!.actualDatetime != null
                            ? Expanded(
                                child: CustomSelectDate(
                                    ctrl: formVM.actualDTCtrl,
                                    title: 'Actual DT'))
                            : sizedBoxShrink
                      ]),
                      heith10Space,

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
                                ctrl: formVM.approverCtrl,
                                title: 'Approver',
                                enableSelectText: false,
                                readOnly: true,
                                readOnlyAndFilled: true))
                      ]),
                      heith10Space,

                      selectTransportation(
                          enable: !formVM.isReadOnly,
                          isValidate: formVM.isType,
                          selected: formVM.selectedTransportation,
                          onValue: formVM.onChangeTransportation),
                      heith10Space,

                      MutliLineTextField(
                          ctrl: formVM.descCtrl,
                          title: 'Description',
                          hint: 'Enter description',
                          readOnly: formVM.isReadOnly,
                          enableSelectText: !formVM.isReadOnly,
                          isValidate: formVM.isDesc,
                          validatedText: formVM.isDesc ? 'Required field' : '',
                          onChanged: formVM.onChangeDesc),
                      heithSpace,

                      // images picker and show image
                      // if ((checkState(approve) &&
                      //         accessVM.hasScanSamllPaper()) ||
                      //     checkState(done))
                      ...[
                        WidgetPickImages(
                            onGallery: () => formVM.imagePicker(false),
                            onCamera: () => formVM.imagePicker(true),
                            isPictures: formVM.isPictures,
                            localPictures: formVM.selectedPictures,
                            isDone: checkState(done),
                            isApproved: checkState(approve),
                            isSubmitted: checkState(submit),
                            smallPaperId:
                                widget.data != null ? widget.data!.id : 0,
                            requestImages: widget.data != null
                                ? widget.data!.requestImages
                                : [],
                            checkingImages:
                                widget.data != null ? widget.data!.images : [])
                      ],
                      ...multiheithSpace(3),

                      // button
                      buildButtonRow(formVM, accessVM, context),
                      ...multiheithSpace(3),
                    ]))
                  ]))));

  buildButtonRow(SmallPaperFormViewModel p1, AccessLevelViewModel p2,
          BuildContext context) =>
      Row(children: [
        ...multiWidthSpace(2),
        // for requestor
        if (checkState(draft) &&
            p1.isRequestor(context, widget.data!.requestor.id)) ...[
          button(
              text: 'Submit',
              color: submitColor,
              onTap: () => onUpdate(p1, submit)),
          ...multiWidthSpace(2)
        ],

        // for requestor - create & update
        if ((checkState(draft) &&
                p1.isRequestor(context, widget.data!.requestor.id)) ||
            widget.isForm) ...[
          button(
              text: widget.isForm ? 'Create' : 'Update',
              color: primaryColor,
              onTap: () => p1.isButtonDisabled ? null : onCreateOrUpdate(p1))
        ],

        // for DH of requestor
        if (checkState(submit) &&
            (p1.isDHOfRequestor(context, widget.data!.approver.id) ||
                p2.hasASGM() ||
                p2.hasAH())) ...[
          button(
              text: 'Approve',
              color: approvedColor,
              onTap: () => onUpdate(p1, approve))
        ],

        // for requestor
        if (checkState(approve) &&
            p1.isRequestor(context, widget.data!.requestor.id)) ...[
          button(
              text: 'Show QR',
              color: primaryColor,
              onTap: () => showQRCode(context, widget.data!.id,
                  widget.data!.requestor.name, 'small_paper')),
          //add space if user is scaner and requestor
          p1.isRequestor(context, widget.data!.requestor.id) &&
                  p2.hasScanSamllPaper()
              ? widthSpace
              : sizedBoxShrink
        ],

        // for security
        if (checkState(approve) && p2.hasScanSamllPaper()) ...[
          button(
              text: 'Done',
              color: greenColor,
              onTap: () => p1.isValidatImage() || p1.isButtonDisabled
                  ? null
                  : p1.updateDone(context, widget.data!.id))
        ],

        // for AM DH
        if ((checkState(submit) || checkState(approve)) && p2.hasAmDh()) ...[
          widthSpace,
          button(
              text: 'Reject',
              color: redColor,
              onTap: () => onUpdate(p1, reject))
        ],
        ...multiWidthSpace(2)
      ]);

  bool notNullData() => widget.data != null;
  bool checkState(String state) => notNullData() && widget.data?.state == state;

  Widget button(
          {required String text,
          required Color color,
          required Function() onTap}) =>
      ButtonCustom(isExpan: true, text: text, color: color, onTap: onTap);

  onCreateOrUpdate(SmallPaperFormViewModel p) {
    if (!p.isValidated()) {
      widget.isForm
          ? p.isValidatImage() || p.isButtonDisabled
              ? null
              : p.insertData(context)
          : onUpdate(p, draft);
    }
  }

  onUpdate(SmallPaperFormViewModel p, String state) {
    if (!p.isValidated()) p.updateData(context, widget.data!.id, state);
  }
}
