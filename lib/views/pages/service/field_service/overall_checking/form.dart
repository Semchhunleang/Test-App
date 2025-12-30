import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'package:umgkh_mobile/view_models/field_service_view_model.dart';
import 'package:umgkh_mobile/view_models/overall_checking_form_view_model.dart';
import 'package:umgkh_mobile/widgets/button_custom.dart';
import 'package:umgkh_mobile/widgets/custom_scaffold.dart';
import 'package:umgkh_mobile/widgets/textfield.dart';

class OverallCheckingFormPage extends StatefulWidget {
  final int id;
  const OverallCheckingFormPage({super.key, required this.id});

  @override
  State<OverallCheckingFormPage> createState() =>
      _OverallCheckingFormPageState();
}

class _OverallCheckingFormPageState extends State<OverallCheckingFormPage> {
  @override
  void initState() {
    final p = Provider.of<OverallCheckingFormViewModel>(context, listen: false);
    p.resetValidate();
    p.resetForm();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<OverallCheckingFormViewModel, FieldServiceViewModel>(
      builder: (context, viewModel, viewModelFS, _) {
        return CustomScaffold(
          resizeToAvoidBottomInset: true,
          isLoading: viewModel.isLoading,
          title: 'Create Overall Checking',
          body: ListView(
            physics: kBounce,
            padding: EdgeInsets.symmetric(horizontal: mainPadding),
            children: [
              Row(children: [
                Expanded(
                  child: InputTextField(
                      ctrl: viewModel.machineHrCtrl,
                      title: 'Machine Hour',
                      hint: 'Currenct machine hr',
                      keyboardType: TextInputType.number,
                      isValidate: viewModel.isHr,
                      validatedText: viewModel.isHr ? 'Field required' : '',
                      onChanged: viewModel.onChangeHr),
                ),
                widthSpace,
                Expanded(
                  child: InputTextField(
                      ctrl: viewModel.machineKmCtrl,
                      title: 'Machine Km',
                      hint: 'Current machine km',
                      keyboardType: TextInputType.number,
                      isValidate: viewModel.isKm,
                      validatedText: viewModel.isKm ? 'Field required' : '',
                      onChanged: viewModel.onChangeKm),
                )
              ]),
              heithSpace,

              // note
              MutliLineTextField(
                  ctrl: viewModel.noteCtrl,
                  title: 'Note',
                  hint: 'Enter note',
                  isValidate: viewModel.isNote,
                  validatedText: viewModel.isNote ? 'Field required' : '',
                  minLine: 5,
                  maxLine: 20,
                  onChanged: viewModel.onChangeNote),
              ...multiheithSpace(2),

              // images picker
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  ButtonCustom(
                    text: 'Gallery',
                    color: primaryColor,
                    onTap: () => viewModel.imagePicker(false),
                  ),
                  widthSpace,
                  ButtonCustom(
                    text: 'Camera',
                    color: primaryColor,
                    onTap: () => viewModel.imagePicker(true),
                  )
                ]),
                viewModel.isEvidence
                    ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: mainPadding),
                        child: Text(
                          'please upload pictures',
                          style:
                              hintStyle.copyWith(color: redColor, fontSize: 10),
                        ),
                      )
                    : sizedBoxShrink
              ]),
              viewModel.pictures.isNotEmpty
                  ? widgetImg(viewModel.pictures)
                  : sizedBoxShrink,

              ...multiheithSpace(4),

              // button
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: mainPadding * 3),
                  child: ButtonCustom(
                    text: 'Submit',
                    color: greenColor,
                    onTap: () async {
                      if (viewModel.isValidated()) {
                        null;
                      } else {
                        await viewModel.insertData(context, widget.id);

                        if (context.mounted) {
                          viewModelFS.fetchDataByData(
                              widget.id, 'field_service',
                              context: context);
                        }
                      }
                    },
                  ),
                ),
              ),
              ...multiheithSpace(2)
            ],
          ),
        );
      },
    );
  }

  Widget widgetImg(List<File> data) => GridView.builder(
        shrinkWrap: true,
        physics: neverScroll,
        padding: EdgeInsets.fromLTRB(
            mainPadding, mainPadding * 2, mainPadding, mainPadding),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: mainPadding,
            mainAxisSpacing: mainPadding),
        itemCount: data.length,
        itemBuilder: (context, i) => GestureDetector(
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(mainRadius),
                child: Image.file(data[i],
                    height: double.infinity,
                    width: double.infinity,
                    fit: BoxFit.cover),
              ),
              IconButton(
                icon: const Icon(Icons.delete_forever_rounded,
                    size: 20, color: Colors.red),
                onPressed: () => Provider.of<OverallCheckingFormViewModel>(
                        context,
                        listen: false)
                    .onRemoveImage(i),
              )
            ],
          ),
        ),
      );
}
