// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signature/signature.dart';
import 'package:umgkh_mobile/services/local_storage/models/offline_actions_local_storage_service.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'package:umgkh_mobile/view_models/field_service_view_model.dart';
import 'package:umgkh_mobile/view_models/job_finish_form_view_model.dart';
import 'package:umgkh_mobile/views/pages/service/field_service/widget/utils_widget.dart';
import 'package:umgkh_mobile/widgets/button_custom.dart';
import 'package:umgkh_mobile/widgets/custom_scaffold.dart';
import 'package:umgkh_mobile/widgets/textfield.dart';

class JobFinishFormPage extends StatefulWidget {
  final int id;
  const JobFinishFormPage({super.key, required this.id});

  @override
  State<JobFinishFormPage> createState() => _JobFinishFormPageState();
}

class _JobFinishFormPageState extends State<JobFinishFormPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final p = Provider.of<JobFinishFormViewModel>(context, listen: false);
      p.resetValidate();
      p.resetForm();

      p.controller.addListener(() => debugPrint('Customer sign changed'));
      p.mechanicSignatureController
          .addListener(() => debugPrint('Mechanic sign changed'));
    });
  }

  late JobFinishFormViewModel viewModel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    viewModel = Provider.of<JobFinishFormViewModel>(context, listen: false);
    viewModel.resetValidate();
  }

  @override
  Widget build(BuildContext context) =>
      Consumer2<JobFinishFormViewModel, FieldServiceViewModel>(
        builder: (context, viewModel, viewModelFS, _) => CustomScaffold(
          resizeToAvoidBottomInset: true,
          isLoading: viewModel.isLoading,
          title: 'Create Job Finish',
          body: ListView(
            physics: kBounce,
            padding: EdgeInsets.symmetric(horizontal: mainPadding),
            children: [
              selectCustomerSatisfied(
                  validate: viewModel.isCusSatisfied,
                  selected: viewModel.customerSatisfied,
                  onChanged: viewModel.onChangeCustomerSatisfied),
              heithSpace,

              InputTextField(
                  ctrl: viewModel.customerCtrl,
                  title: 'Customer Name',
                  hint: 'Enter customer name',
                  isValidate: viewModel.isCustomer,
                  validatedText: viewModel.isCustomer ? 'Field required' : '',
                  onChanged: viewModel.onChangeCustomer),
              heithSpace,

              InputTextField(
                  ctrl: viewModel.phoneCtrl,
                  title: 'Phone',
                  hint: 'Enter phone',
                  isValidate: viewModel.isPhone,
                  keyboardType: TextInputType.phone,
                  validatedText: viewModel.isPhone ? 'Field required' : '',
                  onChanged: viewModel.onChangePhone),
              heithSpace,

              MutliLineTextField(
                  ctrl: viewModel.commentCtrl,
                  title: 'Customer Comment',
                  hint: 'Enter customer comment',
                  isValidate: viewModel.isComment,
                  validatedText: viewModel.isComment ? 'Field required' : '',
                  minLine: 1,
                  maxLine: 20,
                  onChanged: viewModel.onChangeComment),
              heithSpace,
              MutliLineTextField(
                  ctrl: viewModel.recommendCtrl,
                  title: 'Service Recommendation',
                  hint: 'Enter service recommendation',
                  isValidate: viewModel.isRecommend,
                  validatedText: viewModel.isRecommend ? 'Field required' : '',
                  minLine: 1,
                  maxLine: 20,
                  onChanged: viewModel.onChangeRecommend),
              ...multiheithSpace(2),

              // signature
              buildSignature(viewModel,
                  controller: viewModel.controller,
                  isSign: viewModel.isSign,
                  signFrom: "sign_customer"),
              heithSpace,
              buildSignature(viewModel,
                  title: "Mechanic Signature",
                  controller: viewModel.mechanicSignatureController,
                  isSign: viewModel.isSignMechanic,
                  signFrom: "sign_mechanic"),

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
                      if (await viewModel.isValidated()) {
                        null;
                      } else {
                        await viewModel.insertData(context, widget.id);

                        await OfflineActionStorageService().saveOfflineAction(
                          'project.task',
                          widget.id,
                          'update',
                          jsonEncode("Job Finish"),
                        );
                        viewModelFS.fetchDataByData(widget.id, 'field_service',
                            context: context);
                      }
                    },
                  ),
                ),
              ),
              ...multiheithSpace(2)
            ],
          ),
        ),
      );

  buildSignature(JobFinishFormViewModel p,
          {String title = "Signature",
          SignatureController? controller,
          bool isSign = false,
          String signFrom = "sign_customer"}) =>
      Column(
        children: [
          Material(
            color: primaryColor.withOpacity(0.1),
            elevation: 0,
            borderRadius: BorderRadius.circular(mainRadius),
            child: Padding(
              padding: EdgeInsets.all(mainPadding),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: mainPadding, bottom: mainPadding / 2.5),
                      child: Text(title, style: titleStyle13),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(mainRadius),
                    child: Signature(
                      key: const Key('signature'),
                      controller: controller!,
                      width: double.infinity,
                      height: 200,
                      backgroundColor: primaryColor.withOpacity(0.1),
                    ),
                  ),
                  isSign
                      ? Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: mainPadding,
                                vertical: mainPadding / 3),
                            child: Text(
                              'Please leave a sign before sumbit!',
                              style: hintStyle.copyWith(
                                  color: redColor, fontSize: 10),
                            ),
                          ),
                        )
                      : sizedBoxShrink,
                  heithSpace,
                  bt(p, signFrom: signFrom)
                ],
              ),
            ),
          )
        ],
      );

  bt(JobFinishFormViewModel p, {String signFrom = "sign_customer"}) =>
      Row(children: [
        ButtonCustom(
            isExpan: true,
            text: 'Undo',
            textsize: 9,
            iconSize: 18,
            icon: Icons.undo_rounded,
            color: primaryColor,
            onTap: signFrom == "sign_customer" ? p.undo : p.undoMechanicSign),
        widthSpace,
        ButtonCustom(
            isExpan: true,
            text: 'Redo',
            textsize: 9,
            iconSize: 18,
            icon: Icons.redo_rounded,
            color: approvedColor,
            onTap: signFrom == "sign_customer" ? p.redo : p.redoMechanicSign),
        widthSpace,
        ButtonCustom(
            isExpan: true,
            text: 'Clear',
            textsize: 9,
            iconSize: 18,
            icon: Icons.clear_rounded,
            color: redColor,
            onTap: signFrom == "sign_customer" ? p.clear : p.clearMechanicSign),
      ]);
}
