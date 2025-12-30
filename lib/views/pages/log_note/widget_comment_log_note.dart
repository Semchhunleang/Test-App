import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/view_models/log_note_form_view_model.dart';
import 'package:umgkh_mobile/view_models/log_note_view_model.dart';
import 'package:umgkh_mobile/views/pages/log_note/widget/widget_image_local.dart';
import 'package:umgkh_mobile/views/pages/log_note/widget/widget_item_comment.dart';
import 'package:umgkh_mobile/widgets/dialog.dart';
import 'package:umgkh_mobile/widgets/textfield.dart';

class WidgetCommentLogNote extends StatefulWidget {
  final int resId;
  final String model;
  final EdgeInsetsGeometry? padding;
  const WidgetCommentLogNote(
      {super.key, required this.resId, required this.model, this.padding});

  @override
  State<WidgetCommentLogNote> createState() => _WidgetCommentLogNoteState();
}

class _WidgetCommentLogNoteState extends State<WidgetCommentLogNote> {
  @override
  void initState() {
    final p = Provider.of<LogNoteFormViewModel>(context, listen: false);
    p.resetForm();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Consumer2<LogNoteViewModel,
          LogNoteFormViewModel>(
      builder: (context, listVM, formVM, _) => Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(mainRadius / 2)),
          color: greyColor.withOpacity(0.1),
          margin: widget.padding,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // title
            Padding(
                padding: EdgeInsets.only(
                    left: mainPadding / 2,
                    bottom: mainPadding,
                    top: mainPadding / 2),
                child: Text(
                    listVM.showedData.isNotEmpty
                        ? '${listVM.showedData.length} Comment${listVM.showedData.length > 1 ? 's' : ''}'
                        : 'Comment',
                    style: primary15Bold.copyWith(color: blackColor))),

            // send comment
            Padding(
                padding: EdgeInsets.fromLTRB(mainPadding / 2, mainPadding / 5,
                    mainPadding / 5, mainPadding / 2),
                child:
                    Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Expanded(
                      child: CommentTextField(
                          ctrl: formVM.bodyCtrl,
                          maxLine: null,
                          onChanged: formVM.onChangedText,
                          onFile: () => showBottomRightDialog(context,
                              onGallery: () =>
                                  formVM.imagePicker(context, false),
                              onCapture: () =>
                                  formVM.imagePicker(context, true)))),
                  width5Space,
                  InkWell(
                      onTap: formVM.isTextNotEmpty
                          ? () => formVM.insertData(
                              context, widget.resId, widget.model)
                          : null,
                      borderRadius: BorderRadius.circular(mainRadius * 2),
                      splashColor: primaryColor.withOpacity(0.1),
                      highlightColor: primaryColor.withOpacity(0.1),
                      child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Icon(Icons.send_rounded,
                              size: 23,
                              color: formVM.isTextNotEmpty
                                  ? primaryColor
                                  : greyColor)))
                ])),

            // image local
            formVM.pictures.isNotEmpty
                ? const WidgetImageLocalLogNote()
                : sizedBoxShrink,

            if (listVM.showedData.isNotEmpty) ...[
              // divide
              Padding(
                  padding: EdgeInsets.symmetric(vertical: mainPadding),
                  child: Divider(color: greyColor.withOpacity(0.5), height: 5)),
              // list comment
              Padding(
                  padding: EdgeInsets.all(mainPadding / 2),
                  child: Column(
                      children: List.generate(
                          listVM.showedData.length,
                          (i) => WidgetItemComment(
                              data: listVM.showedData[i],
                              isLast: i == listVM.showedData.length - 1))))
            ] else ...[
              Padding(
                  padding: EdgeInsets.all(mainPadding * 2),
                  child: Center(
                      child: Text("There are no messages in this conversation.",
                          style: hintStyle.copyWith(
                              fontStyle: FontStyle.italic, fontSize: 11))))
            ]
          ])));
}
