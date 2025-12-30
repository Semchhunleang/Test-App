import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'package:umgkh_mobile/view_models/call_cus_form_view_model.dart';
import 'package:umgkh_mobile/widgets/button_custom.dart';
import 'package:umgkh_mobile/widgets/custom_scaffold.dart';
import 'package:umgkh_mobile/widgets/textfield.dart';

class CallCustomerFormPage extends StatefulWidget {
  final int id;
  const CallCustomerFormPage({super.key, required this.id});

  @override
  State<CallCustomerFormPage> createState() => _CallCustomerFormPageState();
}

class _CallCustomerFormPageState extends State<CallCustomerFormPage> {
  @override
  void initState() {
    final p = Provider.of<CallCustomerFormViewModel>(context, listen: false);
    p.resetValidate();
    p.resetForm();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Consumer<CallCustomerFormViewModel>(
      builder: (context, viewModel, _) => CustomScaffold(
          resizeToAvoidBottomInset: true,
          title: 'Create Call Customer',
          body: ListView(
              physics: kBounce,
              padding: EdgeInsets.symmetric(horizontal: mainPadding),
              children: [
                InputTextField(
                    ctrl: viewModel.durationCtrl,
                    title: 'Duration',
                    hint: 'Enter duration',
                    keyboardType: TextInputType.number,
                    isValidate: viewModel.isDuration,
                    validatedText: viewModel.isDuration ? 'Field required' : '',
                    onChanged: viewModel.onChangeDuration),
                heithSpace,

                // note
                MutliLineTextField(
                    ctrl: viewModel.noteCtrl,
                    title: 'Note',
                    hint: 'Enter note',
                    isValidate: viewModel.isNote,
                    validatedText: viewModel.validateText,
                    minLine: 5,
                    maxLine: 20,
                    onChanged: viewModel.onChangeNote),
                ...multiheithSpace(2),

                // picture
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    ButtonCustom(
                        text: 'Gallery',
                        color: primaryColor,
                        onTap: () => viewModel.imagePicker(false),),
                    widthSpace,
                    ButtonCustom(
                        text: 'Camera',
                        color: primaryColor,
                        onTap: () => viewModel.imagePicker(true),)
                  ]),
                  viewModel.isEvidence
                      ? Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: mainPadding),
                          child: Text('please upload picture',
                              style: hintStyle.copyWith(
                                  color: redColor, fontSize: 10),),)
                      : sizedBoxShrink
                ]),
                viewModel.selectedPicture != null
                    ? Padding(
                        padding: EdgeInsets.only(top: mainPadding),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(mainRadius),
                            child: Stack(children: [
                              Image(image: FileImage(viewModel.picture!),),
                              Positioned(
                                  right: 5,
                                  top: 5,
                                  child: IconButton(
                                      onPressed: () => viewModel.onRemovePic(),
                                      icon: Icon(Icons.close, color: redColor),),)
                            ]),),)
                    : sizedBoxShrink,
                ...multiheithSpace(4),

                // button
                SizedBox(
                    width: double.infinity,
                    child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: mainPadding * 3),
                        child: ButtonCustom(
                            text: 'Submit',
                            color: greenColor,
                            onTap: () => viewModel.isValidated()
                                ? null
                                : viewModel.insertCallToCustomer(
                                    context, widget.id, "workshop"),),),),
                ...multiheithSpace(2)
              ]),),);
}
