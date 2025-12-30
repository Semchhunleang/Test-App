import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/models/cms/a4/a4.dart';
import 'package:umgkh_mobile/utils/odoo_model.dart';
import 'package:umgkh_mobile/utils/static_state.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'package:umgkh_mobile/view_models/a4_all_level_form_view_model.dart';
import 'package:umgkh_mobile/view_models/a4_under_level_view_model.dart';
import 'package:umgkh_mobile/view_models/log_note_form_view_model.dart';
import 'package:umgkh_mobile/view_models/log_note_view_model.dart';
import 'package:umgkh_mobile/view_models/profile_view_model.dart';
import 'package:umgkh_mobile/view_models/selections_view_model.dart';
import 'package:umgkh_mobile/views/pages/cms/a4_all_level/widget/check_objective_widget.dart';
import 'package:umgkh_mobile/views/pages/cms/a4_all_level/widget/utils_widget.dart';
import 'package:umgkh_mobile/views/pages/cms/a4_for_under_level/widget/image_form_widget.dart';
import 'package:umgkh_mobile/views/pages/log_note/widget_comment_log_note.dart';
import 'package:umgkh_mobile/widgets/button_custom.dart';
import 'package:umgkh_mobile/widgets/custom_scaffold.dart';
import 'package:umgkh_mobile/widgets/custom_selected_date.dart';
import 'package:umgkh_mobile/widgets/custom_state_bar.dart';
import 'package:umgkh_mobile/widgets/textfield.dart';

class A4AllLevelFormAndInfo extends StatefulWidget {
  final bool isForm;
  final A4Data? a4Data;
  const A4AllLevelFormAndInfo({super.key, this.isForm = true, this.a4Data});

  @override
  State<A4AllLevelFormAndInfo> createState() => _A4AllLevelFormAndInfoState();
}

class _A4AllLevelFormAndInfoState extends State<A4AllLevelFormAndInfo> {
  @override
  void initState() {
    super.initState();
    final profile = Provider.of<ProfileViewModel>(context, listen: false);
    final a4View = Provider.of<A4AllLevelFormViewModel>(context, listen: false);
    final a4UnderView =
        Provider.of<A4UnderLevelViewModel>(context, listen: false);
    final selectView = Provider.of<SelectionsViewModel>(context, listen: false);
    a4View.resetForm(profile, selectView);
    if (!widget.isForm) a4View.setInfo(widget.a4Data!, selectView, a4UnderView);
    fetchLogNote();
  }

  Future<void> fetchLogNote() async {
    final vmLN = Provider.of<LogNoteViewModel>(context, listen: false);
    final vmLNF = Provider.of<LogNoteFormViewModel>(context, listen: false);
    if (widget.a4Data != null) {
      vmLN.fetchData(widget.a4Data!.id, formA4);
      vmLNF.resetForm();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<A4AllLevelFormViewModel, SelectionsViewModel,
            A4UnderLevelViewModel>(
        builder: (context, viewModel, viewModel1, a4UnderView, _) {
      return CustomScaffold(
        title: widget.isForm ? 'Create A4 Page' : 'Detail A4 Page',
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            Column(
              children: [
                CustomStateBar(
                  text: widget.a4Data != null
                      ? stateTitleA4(widget.a4Data!.state).toUpperCase()
                      : stateTitleA4(draft).toUpperCase(),
                  color: widget.a4Data != null
                      ? stateColor(widget.a4Data!.state)
                      : stateColor(draft),
                ),
                heith10Space,
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: mainPadding),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: CustomSelectDate(
                                  ctrl: viewModel.startPeriodCtrl,
                                  title: '',
                                  readOnlyAndFilled: !widget.isForm &&
                                      widget.a4Data!.state != draft,
                                  onTap: !widget.isForm &&
                                          widget.a4Data!.state != draft
                                      ? null
                                      : () => viewModel
                                          .selectStartDateTime(context),
                                ),
                              ),
                              widthSpace,
                              Expanded(
                                child: CustomSelectDate(
                                  ctrl: viewModel.endPeriodCtrl,
                                  title: '',
                                  readOnlyAndFilled: true,
                                ),
                              ),
                            ],
                          ),
                          heith10Space,
                          Row(
                            children: [
                              Expanded(
                                child: InputTextField(
                                  ctrl: viewModel.creatorCtrl,
                                  title: 'Proposed By',
                                  hint: 'Enter proposed by',
                                  readOnly: true,
                                  readOnlyAndFilled: true,
                                ),
                              ),
                              widthSpace,
                              Expanded(
                                child: InputTextField(
                                  ctrl: viewModel.managerCtrl,
                                  title: 'Facilitated By',
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
                          //         hint: 'Enter document no',
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
                          MutliLineTextField(
                            ctrl: viewModel.improvementThemeCtrl,
                            title:
                                'IMPROVEMENT THEME (Write down the title of improvement idea)',
                            hint: 'Enter improve theme',
                            readOnly:
                                !widget.isForm && widget.a4Data!.state != draft,
                            readOnlyAndFilled:
                                !widget.isForm && widget.a4Data!.state != draft,
                            isValidate: viewModel.isImproveTheme,
                            validatedText: viewModel.isImproveTheme
                                ? 'Required field'
                                : '',
                            onChanged: viewModel.onChangeImprovTheme,
                          ),
                          heith10Space,
                          MutliLineTextField(
                            ctrl: viewModel.currentConditionCtrl,
                            title:
                                'CURRENT CONDITION ANALYZE (Explain current not good condition found and why need to improve)',
                            hint: 'Enter current condition',
                            readOnly:
                                !widget.isForm && widget.a4Data!.state != draft,
                            readOnlyAndFilled:
                                !widget.isForm && widget.a4Data!.state != draft,
                            isValidate: viewModel.isCurrentCondition,
                            validatedText: viewModel.isCurrentCondition
                                ? 'Required field'
                                : '',
                            onChanged: viewModel.onChangeCurrentCondition,
                          ),
                          heith10Space,
                          MutliLineTextField(
                            ctrl: viewModel.improvementSuggestionCtrl,
                            title:
                                'IMPROVEMENT SUGGESTION (Write the idea/suggestion to improved the condition above)',
                            hint: 'Enter improve suggestion',
                            readOnly:
                                !widget.isForm && widget.a4Data!.state != draft,
                            readOnlyAndFilled:
                                !widget.isForm && widget.a4Data!.state != draft,
                            isValidate: viewModel.isImproveSuggestion,
                            validatedText: viewModel.isImproveSuggestion
                                ? 'Required field'
                                : '',
                            onChanged: viewModel.onChangeImproveSuggestion,
                          ),
                          heith10Space,
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 10.0),
                            child: Text(
                              "CHOOSE THE IMPROVEMENT SUGGESTION OBJECTIVE (SQCDM, 4M+EI and 5S) and tick in the appropriate columns",
                              style: titleStyle13,
                            ),
                          ),
                          heith10Space,
                          //SQCDM Objective
                          Column(
                            children: viewModel1.isoOjective1
                                .asMap()
                                .entries
                                .map((entry) {
                              final int index = entry.key;
                              final int id = entry.value.id!;
                              return CheckObjectiveWidget(
                                title: "*SQCDM Objective",
                                isShowTitle: index == 0,
                                isValidate: viewModel.isObjective1,
                                label: "${entry.value.name}",
                                value:
                                    viewModel.selectedObjectives1[id] ?? false,
                                onChanged: !widget.isForm &&
                                        widget.a4Data!.state != draft
                                    ? null
                                    : (value) {
                                        viewModel.toggleSelectionObj1(
                                            id, value);
                                      },
                              );
                            }).toList(),
                          ),
                          //4M+EI Objective
                          Column(
                            children: viewModel1.isoOjective2
                                .asMap()
                                .entries
                                .map((entry) {
                              final int index = entry.key;
                              final int id = entry.value.id!;
                              return CheckObjectiveWidget(
                                title: "*4M+EI Objective",
                                isShowTitle: index == 0,
                                isValidate: viewModel.isObjective2,
                                label: "${entry.value.name}",
                                value:
                                    viewModel.selectedObjectives2[id] ?? false,
                                onChanged: !widget.isForm &&
                                        widget.a4Data!.state != draft
                                    ? null
                                    : (value) {
                                        viewModel.toggleSelectionObj2(
                                            id, value);
                                      },
                              );
                            }).toList(),
                          ),
                          //5S Objective
                          Column(
                            children: viewModel1.sheetProblem
                                .asMap()
                                .entries
                                .map((entry) {
                              final int index = entry.key;
                              final int id = entry.value.id!;
                              return CheckObjectiveWidget(
                                title: "*5S Objective",
                                isShowTitle: index == 0,
                                isValidate: viewModel.is5sOjective,
                                label: "${entry.value.name}",
                                value:
                                    viewModel.selectedSheetProblem[id] ?? false,
                                onChanged: !widget.isForm &&
                                        widget.a4Data!.state != draft
                                    ? null
                                    : (value) {
                                        viewModel.toggleSelectionSheetProblem(
                                            id, value);
                                      },
                              );
                            }).toList(),
                          ),
                          selectImprovScope(
                              selected: viewModel.improvScop,
                              validate: viewModel.isImproveScope,
                              isReadOnly: !widget.isForm &&
                                  widget.a4Data!.state != draft,
                              onChanged: viewModel.onChangeImprovScope),
                          heith10Space,
                          MutliLineTextField(
                            ctrl: viewModel.deliverablesCtrl,
                            title:
                                'DELIVERABLES (Value added / advantages given after improvement done) Related to tangible thing',
                            hint: 'Enter deliverables',
                            readOnly:
                                !widget.isForm && widget.a4Data!.state != draft,
                            readOnlyAndFilled:
                                !widget.isForm && widget.a4Data!.state != draft,
                            isValidate: viewModel.isDeliverables,
                            validatedText: viewModel.isDeliverables
                                ? 'Required field'
                                : '',
                            onChanged: viewModel.onChangeDeliverables,
                          ),
                          heith10Space,
                          MutliLineTextField(
                            ctrl: viewModel.nextImprovementCtrl,
                            title:
                                'NEXT IMPROVEMENT PLAN (What will be improved next, related the previous theme)',
                            hint: 'Enter next improvement plan',
                            readOnly:
                                !widget.isForm && widget.a4Data!.state != draft,
                            readOnlyAndFilled:
                                !widget.isForm && widget.a4Data!.state != draft,
                            isValidate: viewModel.isNextImprovePlan,
                            validatedText: viewModel.isNextImprovePlan
                                ? 'Required field'
                                : '',
                            onChanged: viewModel.onChangeNextImprove,
                          ),
                          heith10Space,
                          ImageFormWidget(
                              title: "Before",
                              id: widget.a4Data?.id,
                              isHideSelectImage: !widget.isForm &&
                                  widget.a4Data!.state != draft,
                              field: 'before_improv',
                              isValidate: viewModel.isImageBefore,
                              onTapCamera: () => viewModel.pickOrCaptureImage(
                                  isBefore: true, fromGallery: false),
                              onTapGallery: () => viewModel.pickOrCaptureImage(
                                  isBefore: true, fromGallery: true),
                              fillImage: viewModel.selectedImageBefore),
                          heith10Space,
                          ImageFormWidget(
                              title: "After",
                              id: widget.a4Data?.id,
                              isHideSelectImage: !widget.isForm &&
                                  widget.a4Data!.state != draft,
                              field: 'after_improv',
                              isValidate: viewModel.isImageAfter,
                              onTapCamera: () => viewModel.pickOrCaptureImage(
                                  isBefore: false, fromGallery: false),
                              onTapGallery: () => viewModel.pickOrCaptureImage(
                                  isBefore: false, fromGallery: true),
                              fillImage: viewModel.selectedImageAfter),
                          //...multiheithSpace(4),

                          if (widget.a4Data != null) ...[
                            Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: mainPadding * 2,
                                    horizontal: mainPadding * 3),
                                child: Divider(
                                    color: greyColor.withOpacity(0.5),
                                    height: 5)),
                            WidgetCommentLogNote(
                                resId: widget.a4Data!.id, model: formA4),
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
                            isDiable: viewModel.isLoading,
                            onTap: viewModel.isLoading
                                ? () {}
                                : () {
                                    final parentContext =
                                        Navigator.of(context).context;
                                    if (!viewModel.isValidated(
                                        context, a4UnderView,
                                        isForm: widget.isForm)) {
                                      viewModel.insertA4(parentContext);
                                    }
                                  }),
                      )
                    : widget.a4Data != null && widget.a4Data!.state == draft
                        ? Container(
                            margin: EdgeInsets.only(
                                left: mainPadding,
                                right: mainPadding,
                                bottom: mainPadding),
                            child: Row(
                              children: [
                                Expanded(
                                  child: ButtonCustom(
                                      text: 'Submit',
                                      isDiable: viewModel.isLoading,
                                      color: Colors.orangeAccent,
                                      onTap: viewModel.isLoading
                                          ? () {}
                                          : () {
                                              final parentContext =
                                                  Navigator.of(context).context;
                                              viewModel.updateStateA4(
                                                  parentContext,
                                                  widget.a4Data!.id,
                                                  submit);
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
                                                  context, a4UnderView,
                                                  a4: widget.a4Data!,
                                                  isForm: widget.isForm)) {
                                                Future.delayed(
                                                    const Duration(
                                                        milliseconds: 500), () {
                                                  if (context.mounted) {
                                                    Navigator.pop(context);
                                                  }
                                                });
                                                viewModel.updateA4(
                                                    parentContext,
                                                    widget.a4Data!.id);
                                              }
                                            }),
                                ),
                              ],
                            ),
                          )
                        : Container(),
              ],
            ),
            if (viewModel.isLoading)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              )
          ],
        ),
      );
    });
  }
}
