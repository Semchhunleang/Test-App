import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/models/cms/tsb/tsb.dart';
import 'package:umgkh_mobile/utils/navigator.dart';
import 'package:umgkh_mobile/utils/odoo_model.dart';
import 'package:umgkh_mobile/utils/static_state.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'package:umgkh_mobile/view_models/log_note_form_view_model.dart';
import 'package:umgkh_mobile/view_models/log_note_view_model.dart';
import 'package:umgkh_mobile/view_models/profile_view_model.dart';
import 'package:umgkh_mobile/view_models/selections_view_model.dart';
import 'package:umgkh_mobile/view_models/tsb_form_view_model.dart';
import 'package:umgkh_mobile/view_models/tsb_view_model.dart';
import 'package:umgkh_mobile/views/pages/cms/tsb/part_info_form_page.dart';
import 'package:umgkh_mobile/views/pages/cms/tsb/widget/image_form_widget.dart';
import 'package:umgkh_mobile/views/pages/cms/tsb/widget/item_parts_widget.dart';
import 'package:umgkh_mobile/views/pages/cms/tsb/widget/utils_widget.dart';
import 'package:umgkh_mobile/views/pages/log_note/widget_comment_log_note.dart';
import 'package:umgkh_mobile/widgets/button_custom.dart';
import 'package:umgkh_mobile/widgets/custom_scaffold.dart';
import 'package:umgkh_mobile/widgets/custom_selected_date.dart';
import 'package:umgkh_mobile/widgets/custom_state_bar.dart';
import 'package:umgkh_mobile/widgets/textfield.dart';

class TsbDetailFormPages extends StatefulWidget {
  final TSBData? tsbData;
  final bool isForm;
  const TsbDetailFormPages({super.key, this.tsbData, this.isForm = true});

  @override
  State<TsbDetailFormPages> createState() => _TsbDetailFormPagesState();
}

class _TsbDetailFormPagesState extends State<TsbDetailFormPages> {
  @override
  void initState() {
    super.initState();
    final tsbFormView = Provider.of<TsbFormViewModel>(context, listen: false);
    final profile = Provider.of<ProfileViewModel>(context, listen: false);
    final selectView = Provider.of<SelectionsViewModel>(context, listen: false);
    tsbFormView.resetForm(profile, selectView);
    if (!widget.isForm) tsbFormView.setInfo(widget.tsbData!);
    fetchLogNote();
  }

  Future<void> fetchLogNote() async {
    final vmLN = Provider.of<LogNoteViewModel>(context, listen: false);
    final vmLNF = Provider.of<LogNoteFormViewModel>(context, listen: false);
    if (widget.tsbData != null) {
      vmLN.fetchData(widget.tsbData!.id, technicalServiceBulletin);
      vmLNF.resetForm();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<TsbFormViewModel, SelectionsViewModel, TsbViewModel>(
        builder: (context, viewModel, viewModel1, viewModel2, _) {
      return CustomScaffold(
        title: "TSB Form",
        resizeToAvoidBottomInset: true,
        body: Column(
          children: [
            CustomStateBar(
              text: widget.tsbData != null
                  ? stateTitleA4(widget.tsbData!.state).toUpperCase()
                  : stateTitleTsb(draft).toUpperCase(),
              color: widget.tsbData != null
                  ? stateColor(widget.tsbData!.state)
                  : stateColor(draft),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: mainPadding, vertical: mainPadding),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomSelectDate(
                        ctrl: viewModel.dateCtrl,
                        title: '',
                        readOnlyAndFilled:
                            !widget.isForm && widget.tsbData!.state != draft,
                        onTap: !widget.isForm && widget.tsbData!.state != draft
                            ? null
                            : () => viewModel.selectDateTime(context),
                      ),
                      heith10Space,
                      Row(
                        children: [
                          Expanded(
                            child: InputTextField(
                              ctrl: viewModel.preparedByCtrl,
                              title: 'Prepared By',
                              hint: 'Enter proposed by',
                              readOnly: true,
                              readOnlyAndFilled: true,
                            ),
                          ),
                          widthSpace,
                          Expanded(
                            child: InputTextField(
                              ctrl: viewModel.managerCtrl,
                              title: 'Acknowledged By',
                              hint: 'Enter facilitated by',
                              readOnly: true,
                              readOnlyAndFilled: true,
                            ),
                          ),
                        ],
                      ),
                      // heith10Space,
                      // InputTextField(
                      //   ctrl: viewModel.positionCtrl,
                      //   title: 'Position',
                      //   hint: 'Enter position',
                      //   readOnly: true,
                      //   readOnlyAndFilled: true,
                      // ),
                      // heith10Space,
                      // InputTextField(
                      //   ctrl: viewModel.departmentCtrl,
                      //   title: 'Department',
                      //   hint: 'Enter department',
                      //   readOnly: true,
                      //   readOnlyAndFilled: true,
                      // ),
                      // heith10Space,
                      // Row(
                      //   children: [
                      //     Expanded(
                      //       flex: 2,
                      //       child: InputTextField(
                      //         ctrl: viewModel.documentNoCtrl,
                      //         title: 'Document No',
                      //         hint: '',
                      //         readOnly: true,
                      //         readOnlyAndFilled: true,
                      //       ),
                      //     ),
                      //     widthSpace,
                      //     Expanded(
                      //       flex: 1,
                      //       child: InputTextField(
                      //         ctrl: viewModel.scoreCtrl,
                      //         title: 'Score',
                      //         hint: '0',
                      //         readOnly: true,
                      //         readOnlyAndFilled: true,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      heith10Space,
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: InputTextField(
                              ctrl: viewModel.gradeBySuperiorCtrl,
                              title: 'Grade By SPV',
                              hint: '',
                              readOnly: true,
                              readOnlyAndFilled: true,
                            ),
                          ),
                          widthSpace,
                          Expanded(
                            flex: 3,
                            child: InputTextField(
                              ctrl: viewModel.gradeByCbCtrl,
                              title: 'Grade By CB',
                              hint: '',
                              readOnly: true,
                              readOnlyAndFilled: true,
                            ),
                          ),
                          widthSpace,
                          Expanded(
                            flex: 2,
                            child: InputTextField(
                              ctrl: viewModel.scoreCtrl,
                              title: 'Score',
                              hint: '0',
                              readOnly: true,
                              readOnlyAndFilled: true,
                            ),
                          ),
                        ],
                      ),
                      heith10Space,
                      Row(
                        children: [
                          Expanded(
                            child: selectManufacturer(
                                selected: viewModel.productBrand,
                                validate: viewModel.isProductBrand,
                                isReadOnly: !widget.isForm &&
                                    widget.tsbData!.state != draft,
                                onChanged: viewModel.onChangeProductBrand),
                          ),
                          widthSpace,
                          Expanded(
                            child: selectProductLine(
                                selected: viewModel.tsbProductCateg,
                                validate: viewModel.isTsbProductCateg,
                                isReadOnly: !widget.isForm &&
                                    widget.tsbData!.state != draft,
                                onChanged: viewModel.onChangeTsbProductCateg),
                          ),
                        ],
                      ),
                      heith10Space,
                      Row(
                        children: [
                          Expanded(
                            child: selectEngineModel(
                                selected: viewModel.engineModel,
                                validate: viewModel.isEngineModel,
                                isReadOnly: !widget.isForm &&
                                    widget.tsbData!.state != draft,
                                onChanged: viewModel.onChangeEngineModel),
                          ),
                          widthSpace,
                          Expanded(
                            child: selectComponentGroup(
                                selected: viewModel.componentGroup,
                                validate: viewModel.isComponentGroup,
                                isReadOnly: !widget.isForm &&
                                    widget.tsbData!.state != draft,
                                onChanged: viewModel.onChangeComponentGroup),
                          ),
                        ],
                      ),
                      heith10Space,
                      Row(
                        children: [
                          Expanded(
                            child: selectModel(
                                selected: viewModel.productModel,
                                validate: viewModel.isProductModel,
                                isReadOnly: !widget.isForm &&
                                    widget.tsbData!.state != draft,
                                onChanged: viewModel.onChangeProductModel),
                          ),
                          widthSpace,
                          Expanded(
                            child: selectSeries(
                                selected: viewModel.stockProductionLot,
                                validate: viewModel.isStockProductionLot,
                                isReadOnly: !widget.isForm &&
                                    widget.tsbData!.state != draft,
                                onChanged: viewModel.onChangeStockProductLot),
                          ),
                        ],
                      ),
                      heith10Space,
                      MutliLineTextField(
                        maxLine: null,
                        ctrl: viewModel.subjectCtrl,
                        title: 'Subject',
                        hint: 'Enter subject',
                        isValidate: viewModel.isSubject,
                        validatedText:
                            viewModel.isSubject ? 'Required field' : '',
                        onChanged: viewModel.onChangeSubject,
                        readOnly:
                            !widget.isForm && widget.tsbData!.state != draft,
                        readOnlyAndFilled:
                            !widget.isForm && widget.tsbData!.state != draft,

                        // readOnly: true,
                        // readOnlyAndFilled: true,
                      ),
                      heith10Space,
                      MutliLineTextField(
                        maxLine: null,
                        ctrl: viewModel.problemCtrl,
                        title: 'Failure/Problem',
                        hint: 'Enter failure/problem',
                        isValidate: viewModel.isProblem,
                        validatedText:
                            viewModel.isProblem ? 'Required field' : '',
                        onChanged: viewModel.onChangeProblem,
                        readOnly:
                            !widget.isForm && widget.tsbData!.state != draft,
                        readOnlyAndFilled:
                            !widget.isForm && widget.tsbData!.state != draft,
                      ),
                      heith10Space,
                      MutliLineTextField(
                        maxLine: null,
                        ctrl: viewModel.symptomCtrl,
                        title: 'Symptom',
                        hint: 'Enter symptom',
                        isValidate: viewModel.isSymptom,
                        validatedText:
                            viewModel.isSymptom ? 'Required field' : '',
                        onChanged: viewModel.onChangeSymptom,
                        readOnly:
                            !widget.isForm && widget.tsbData!.state != draft,
                        readOnlyAndFilled:
                            !widget.isForm && widget.tsbData!.state != draft,
                      ),
                      heith10Space,
                      MutliLineTextField(
                        maxLine: null,
                        ctrl: viewModel.historyCtrl,
                        title: 'History',
                        hint: 'Enter history',
                        isValidate: viewModel.isHistory,
                        validatedText:
                            viewModel.isHistory ? 'Required field' : '',
                        onChanged: viewModel.onChangeHistory,
                        readOnly:
                            !widget.isForm && widget.tsbData!.state != draft,
                        readOnlyAndFilled:
                            !widget.isForm && widget.tsbData!.state != draft,
                      ),
                      heith10Space,
                      MutliLineTextField(
                        maxLine: null,
                        ctrl: viewModel.causeAnalysisCtrl,
                        title: 'Cause & Analysis',
                        hint: 'Enter cause & analysis',
                        readOnly:
                            !widget.isForm && widget.tsbData!.state != draft,
                        readOnlyAndFilled:
                            !widget.isForm && widget.tsbData!.state != draft,
                      ),
                      heith10Space,
                      MutliLineTextField(
                        maxLine: null,
                        ctrl: viewModel.actionCtrl,
                        title: 'Action',
                        hint: 'Enter action',
                        readOnly:
                            !widget.isForm && widget.tsbData!.state != draft,
                        readOnlyAndFilled:
                            !widget.isForm && widget.tsbData!.state != draft,
                      ),
                      heithSpace,
                      ImageFormWidget(
                          title: "Before",
                          id: widget.tsbData?.id,
                          isHideSelectImage:
                              !widget.isForm && widget.tsbData!.state != draft,
                          field: 'before_pict',
                          isValidate: viewModel.isImageBefore,
                          onTapCamera: () => viewModel.pickOrCaptureImage(
                              isBefore: true, fromGallery: false),
                          onTapGallery: () => viewModel.pickOrCaptureImage(
                              isBefore: true, fromGallery: true),
                          fillImage: viewModel.selectedImageBefore),
                      heith10Space,
                      ImageFormWidget(
                          title: "After",
                          id: widget.tsbData?.id,
                          isHideSelectImage:
                              !widget.isForm && widget.tsbData!.state != draft,
                          field: 'after_pict',
                          isValidate: viewModel.isImageAfter,
                          onTapCamera: () => viewModel.pickOrCaptureImage(
                              isBefore: false, fromGallery: false),
                          onTapGallery: () => viewModel.pickOrCaptureImage(
                              isBefore: false, fromGallery: true),
                          fillImage: viewModel.selectedImageAfter),
                      heith10Space,
                      if (widget.tsbData != null &&
                          widget.tsbData!.state == draft)
                        SizedBox(
                          width: 130,
                          child: ElevatedButton(
                            onPressed: () {
                              navPush(
                                context,
                                PartsInfoFormPage(id: widget.tsbData!.id),
                              );
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(Icons.add),
                                widthSpace,
                                const Text("Parts")
                              ],
                            ),
                          ),
                        ),
                      if (widget.tsbData != null &&
                          widget.tsbData!.tsbLine != null)
                        Column(
                          children:
                              widget.tsbData!.tsbLine!.asMap().entries.map((e) {
                            return GestureDetector(
                              onTap: () async {
                                final result = await navPush(
                                  context,
                                  PartsInfoFormPage(
                                    isForm: false,
                                    tsbLine: widget.tsbData!.tsbLine![e.key],
                                    id: widget.tsbData!.id,
                                    state: widget.tsbData!.state!,
                                  ),
                                );
                                if (result == true) {
                                  viewModel2.fetchTsbLineData(
                                      widget.tsbData!.tsbLine![e.key].id!);
                                }
                              },
                              child: ItemPartsWidget(
                                tsbLine: e.value,
                              ),
                            );
                          }).toList(),
                        ),
                      if (widget.tsbData != null) ...[
                        Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: mainPadding * 2,
                                horizontal: mainPadding * 3),
                            child: Divider(
                                color: greyColor.withOpacity(0.5), height: 5)),
                        WidgetCommentLogNote(
                            resId: widget.tsbData!.id,
                            model: technicalServiceBulletin),
                        heithSpace
                      ],
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
                        text: 'Submit',
                        // isDiable: viewModel.isLoading,
                        onTap: () {
                          final parentContext = Navigator.of(context).context;
                          if (!viewModel.isValidated(isForm: true)) {
                            viewModel.insertTsb(parentContext);
                          }
                        }),
                  )
                : widget.tsbData != null && widget.tsbData!.state == draft
                    ? Container(
                        margin: EdgeInsets.only(
                            left: mainPadding,
                            right: mainPadding,
                            bottom: mainPadding),
                        child: Row(
                          children: [
                            Expanded(
                              child: ButtonCustom(
                                  text: 'Prepare',
                                  isDiable: viewModel.isLoading,
                                  color: Colors.orangeAccent,
                                  onTap: viewModel.isLoading
                                      ? () {}
                                      : () {
                                          final parentContext =
                                              Navigator.of(context).context;
                                          viewModel.updateStateTsb(
                                              parentContext,
                                              widget.tsbData!.id,
                                              prepared);
                                        }),
                            ),
                            width10Space,
                            Expanded(
                              child: ButtonCustom(
                                text: "Update",
                                isDiable: viewModel.isLoading,
                                onTap: viewModel.isLoading
                                    ? () {}
                                    : () {
                                        final parentContext =
                                            Navigator.of(context).context;
                                        if (!viewModel.isValidated(
                                            tsb: widget.tsbData,
                                            isForm: widget.isForm)) {
                                          Future.delayed(
                                              const Duration(milliseconds: 500),
                                              () {
                                            if (context.mounted) {
                                              Navigator.pop(context);
                                            }
                                          });
                                          viewModel.updateA4(parentContext,
                                              widget.tsbData!.id);
                                        }
                                      },
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(),
          ],
        ),
      );
    });
  }
}
