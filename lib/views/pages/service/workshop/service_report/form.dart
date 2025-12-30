import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'package:umgkh_mobile/view_models/service_report_form_view_model.dart';
import 'package:umgkh_mobile/widgets/button_custom.dart';
import 'package:umgkh_mobile/widgets/custom_scaffold.dart';
import 'package:umgkh_mobile/widgets/textfield.dart';

class ServiceReportFormPage extends StatefulWidget {
  final int id;
  const ServiceReportFormPage({super.key, required this.id});

  @override
  State<ServiceReportFormPage> createState() => _ServiceReportFormPageState();
}

class _ServiceReportFormPageState extends State<ServiceReportFormPage> {
  @override
  void initState() {
    final p = Provider.of<ServiceReportFormViewModel>(context, listen: false);
    p.resetValidate();
    p.resetForm();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Consumer<ServiceReportFormViewModel>(
      builder: (context, viewModel, _) => CustomScaffold(
          resizeToAvoidBottomInset: true,
          isLoading: viewModel.isLoading,
          title: 'Create Service Report',
          body: ListView(
              physics: kBounce,
              padding: EdgeInsets.symmetric(horizontal: mainPadding),
              children: [
                MutliLineTextField(
                    ctrl: viewModel.problemCtrl,
                    title: 'Problem',
                    hint: 'Enter problem',
                    isValidate: viewModel.isProblem,
                    validatedText: viewModel.isProblem ? 'Field required' : '',
                    minLine: 1,
                    maxLine: 20,
                    onChanged: viewModel.onChangeProblem),
                heithSpace,
                MutliLineTextField(
                    ctrl: viewModel.rootCauseCtrl,
                    title: 'Root Cause',
                    hint: 'Enter root cause',
                    isValidate: viewModel.isRootCuase,
                    validatedText:
                        viewModel.isRootCuase ? 'Field required' : '',
                    minLine: 1,
                    maxLine: 20,
                    onChanged: viewModel.onChangeRootCause),
                heithSpace,
                MutliLineTextField(
                    ctrl: viewModel.actionCtrl,
                    title: 'Action',
                    hint: 'Enter action',
                    isValidate: viewModel.isAction,
                    validatedText: viewModel.isAction ? 'Field required' : '',
                    minLine: 1,
                    maxLine: 20,
                    onChanged: viewModel.onChangeAction),
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
                viewModel.pictures.isNotEmpty
                    ? widgetImg(viewModel.pictures)
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
                                : viewModel.insertData(
                                    context,
                                    widget.id,
                                    'workshop',
                                  ),),),),
                ...multiheithSpace(2)
              ]),),);

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
              // onTap: () => navPush(context, ViewFullImagePage(image: data[i]),),
              child: Stack(alignment: Alignment.topRight, children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(mainRadius),
                child: Image.file(data[i],
                    height: double.infinity,
                    width: double.infinity,
                    fit: BoxFit.cover),),
            IconButton(
                icon: const Icon(Icons.delete_forever_rounded,
                    size: 20, color: Colors.red),
                onPressed: () => Provider.of<ServiceReportFormViewModel>(
                        context,
                        listen: false)
                    .onRemoveImage(i),)
          ]),),);
}
