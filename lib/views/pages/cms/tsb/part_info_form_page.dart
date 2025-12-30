import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/models/cms/tsb/tsb_line.dart';
import 'package:umgkh_mobile/utils/static_state.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/view_models/selections_view_model.dart';
import 'package:umgkh_mobile/view_models/tsb_form_view_model.dart';
import 'package:umgkh_mobile/views/pages/cms/tsb/widget/utils_widget.dart';
import 'package:umgkh_mobile/widgets/button_custom.dart';
import 'package:umgkh_mobile/widgets/custom_scaffold.dart';
import 'package:umgkh_mobile/widgets/textfield.dart';

class PartsInfoFormPage extends StatefulWidget {
  final bool isForm;
  final TsbLine? tsbLine;
  final int? id;
  final String state;
  const PartsInfoFormPage(
      {super.key, this.isForm = true, this.tsbLine, this.id, this.state = ""});

  @override
  State<PartsInfoFormPage> createState() => _PartsInfoFormPageState();
}

class _PartsInfoFormPageState extends State<PartsInfoFormPage> {
  @override
  void initState() {
    super.initState();
    final viewModel = Provider.of<TsbFormViewModel>(context, listen: false);
    viewModel.resetFormLine();
    if (!widget.isForm) viewModel.setInfoLine(widget.tsbLine!);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<TsbFormViewModel, SelectionsViewModel>(
        builder: (context, viewModel, viewModel1, _) {
      return CustomScaffold(
        title: widget.isForm ? "Parts Form" : "Parts Detail",
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: mainPadding, vertical: mainPadding),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      heith10Space,
                      Row(
                        children: [
                          Expanded(
                            child: selectTypePart(
                                selected: viewModel.typePart,
                                validate: viewModel.isTypePart,
                                isReadOnly:
                                    !widget.isForm && widget.state != draft,
                                onChanged: viewModel.onChangeTypePart),
                          ),
                          widthSpace,
                          Expanded(
                            child: InputTextField(
                              ctrl: viewModel.qtyCtrl,
                              title: 'Qty',
                              hint: 'Enter qty',
                              readOnly: !widget.isForm && widget.state != draft,
                              readOnlyAndFilled:
                                  !widget.isForm && widget.state != draft,
                            ),
                          ),
                        ],
                      ),
                      heith10Space,
                      selectProduct(
                          selected: viewModel.product,
                          validate: viewModel.isProduct,
                          isReadOnly: !widget.isForm && widget.state != draft,
                          onChanged: viewModel.onChangeProduct),
                      heith10Space,
                      MutliLineTextField(
                        maxLine: null,
                        ctrl: viewModel.descriptionCtrl,
                        title: 'Description',
                        hint: 'Enter description',
                        readOnly: !widget.isForm && widget.state != draft,
                        readOnlyAndFilled:
                            !widget.isForm && widget.state != draft,
                      ),
                      ...multiheithSpace(4),
                    ],
                  ),
                ),
              ),
            ),
            widget.isForm
                ? Container(
                    margin: EdgeInsets.only(
                        left: mainPadding,
                        right: mainPadding,
                        bottom: mainPadding),
                    width: double.infinity,
                    child: ButtonCustom(
                        text: 'Save',
                        onTap: () {
                          final parentContext = Navigator.of(context).context;

                          if (!viewModel.isValidatedPart()) {
                            Navigator.pop(context);
                            viewModel.insertTsbLine(parentContext, widget.id!);
                          }
                        }),
                  )
                : widget.state == draft
                    ? Container(
                        margin: EdgeInsets.only(
                            left: mainPadding,
                            right: mainPadding,
                            bottom: mainPadding),
                        width: double.infinity,
                        child: ButtonCustom(
                            text: 'Update',
                            onTap: () {
                              final parentContext =
                                  Navigator.of(context).context;
                              if (!viewModel.isValidatedPart()) {
                                Navigator.pop(context);
                                viewModel.updateTsbLine(
                                    parentContext, widget.tsbLine!.id!);
                              }
                            }),
                      )
                    : Container()
          ],
        ),
      );
    });
  }
}
