import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/models/crm/activity/activity.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'package:umgkh_mobile/view_models/activity_form_view_model.dart';
import 'package:umgkh_mobile/views/pages/crm/lead/widget/utils_widget.dart';
import 'package:umgkh_mobile/widgets/button_custom.dart';
import 'package:umgkh_mobile/widgets/custom_scaffold.dart';
import 'package:umgkh_mobile/widgets/textfield.dart';

class ActivityFormPage extends StatefulWidget {
  final int id;
  final Activity? data;
  const ActivityFormPage({super.key, required this.id, this.data});

  @override
  State<ActivityFormPage> createState() => _ActivityFormPageState();
}

class _ActivityFormPageState extends State<ActivityFormPage> {
  @override
  void initState() {
    final p = Provider.of<ActivityFormViewModel>(context, listen: false);
    p.resetValidate();
    p.resetForm();
    if (isUpdate()) p.setInfo(widget.data!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Consumer<ActivityFormViewModel>(
        builder: (context, viewModel, _) => CustomScaffold(
          resizeToAvoidBottomInset: true,
          title: 'Create Schedule & Activity',
          body: ListView(
              physics: kBounce,
              padding: EdgeInsets.symmetric(horizontal: mainPadding),
              children: [
                selectActivityType(
                    isValidate: viewModel.isType,
                    selected: viewModel.selectedType,
                    onChanged: viewModel.onChangeType),
                heithSpace,

                // note
                MutliLineTextField(
                    ctrl: viewModel.summaryCtrl,
                    title: 'Summary',
                    hint: 'Enter summary',
                    isValidate: viewModel.isSummary,
                    validatedText: viewModel.isSummary ? 'Field required' : '',
                    minLine: 5,
                    maxLine: 20,
                    onChanged: viewModel.onChangeSummary),
                ...multiheithSpace(2),

                // picture
                isNotUpdatePic()
                    ? sizedBoxShrink
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                            ButtonCustom(
                                text: 'Upload Evidence',
                                onTap: () =>
                                    viewModel.pickOrCapture(isGallery: true)),
                            viewModel.isEvidence
                                ? Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: mainPadding),
                                    child: Text(
                                      'please upload picture',
                                      style: hintStyle.copyWith(
                                          color: redColor, fontSize: 10),
                                    ),
                                  )
                                : sizedBoxShrink
                          ]),
                viewModel.selectedPicture != null
                    ? Padding(
                        padding: EdgeInsets.only(top: mainPadding),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(mainRadius),
                          child: Image(
                            image: FileImage(viewModel.picture!),
                          ),
                        ))
                    : sizedBoxShrink,
                ...multiheithSpace(4),

                // button
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: mainPadding * 0),
                    child: Row(children: [
                      if (!isUpdate()) ...[
                        ButtonCustom(
                            text: 'Schedule',
                            color: amberColor,
                            isExpan: true,
                            onTap: () => viewModel.isValidated(isNotUpdatePic())
                                ? null
                                : viewModel.insertSchedule(context, widget.id)),
                        widthSpace,
                        ButtonCustom(
                            text: 'Activity',
                            color: greenColor,
                            isExpan: true,
                            onTap: () => viewModel.isValidated(isNotUpdatePic())
                                ? null
                                : viewModel.insertActivity(context, widget.id))
                      ],
                      if (isUpdate()) ...[
                        ButtonCustom(
                            text: 'Done',
                            color: greenColor,
                            isExpan: true,
                            onTap: () => viewModel.isValidated(isNotUpdatePic())
                                ? null
                                : viewModel.insertActivity(
                                    context, widget.data!.resId,
                                    mailActivityId: widget.data?.id)),
                        widthSpace,
                        ButtonCustom(
                            text: 'Update',
                            color: primaryColor,
                            isExpan: true,
                            onTap: () => viewModel.isValidated(isNotUpdatePic())
                                ? null
                                : viewModel.updateSchedule(
                                    context, widget.data!.id))
                      ]
                    ]),
                  ),
                ),
                ...multiheithSpace(2)
              ]),
        ),
      );

  bool isUpdate() => widget.data != null;
  bool isNotUpdatePic() => isUpdate() && widget.data!.images.isNotEmpty;
}
