import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/models/base/user/user.dart';
import 'package:umgkh_mobile/models/visual_board/stage.dart';
import 'package:umgkh_mobile/models/visual_board/visual_board.dart';
import 'package:umgkh_mobile/utils/odoo_model.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/view_models/log_note_form_view_model.dart';
import 'package:umgkh_mobile/view_models/log_note_view_model.dart';
import 'package:umgkh_mobile/view_models/profile_view_model.dart';
import 'package:umgkh_mobile/view_models/selections_view_model.dart';
import 'package:umgkh_mobile/view_models/visual_board/visual_board_form_view_model.dart';
import 'package:umgkh_mobile/view_models/visual_board/visual_board_view_model.dart';
import 'package:umgkh_mobile/views/pages/cms/visual_board/form/widget/datetime.dart';
import 'package:umgkh_mobile/views/pages/cms/visual_board/form/widget/many2many.dart';
import 'package:umgkh_mobile/views/pages/crm/opportunity/widget/utils_opportunity_widget.dart';
import 'package:umgkh_mobile/views/pages/log_note/widget_comment_log_note.dart';
import 'package:umgkh_mobile/widgets/button_custom.dart';
// import 'package:umgkh_mobile/views/pages/cms/visual_board/list/widget/item_visual_board_widget.dart';
import 'package:umgkh_mobile/widgets/custom_drop_list.dart';
import 'package:umgkh_mobile/widgets/custom_scaffold.dart';
import 'package:umgkh_mobile/widgets/list_condition.dart';
import 'package:umgkh_mobile/widgets/textfield.dart';

class VisualBoardFormPage extends StatefulWidget {
  static const routeName = '/visual-board-form';
  static const pageName = 'Visual Board Form';
  final VisualBoard? data;

  const VisualBoardFormPage({Key? key, this.data}) : super(key: key);

  @override
  State<VisualBoardFormPage> createState() => _VisualBoardFormPageState();
}

class _VisualBoardFormPageState extends State<VisualBoardFormPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vbfml =
          Provider.of<VisualBoardFormViewModel>(context, listen: false);
      if (widget.data != null) {
        vbfml.updateVisualBoard(widget.data!);
        fetchLogNote();
      }
    });
  }

  Future<void> fetchLogNote() async {
    final vmLN = Provider.of<LogNoteViewModel>(context, listen: false);
    final vmLNF = Provider.of<LogNoteFormViewModel>(context, listen: false);

    if (widget.data != null) {
      vmLN.fetchData(widget.data!.id, visualBoard);
      vmLNF.resetForm();
    }
  }

  @override
  Widget build(BuildContext context) => Consumer6<
              VisualBoardFormViewModel,
              ProfileViewModel,
              SelectionsViewModel,
              LogNoteViewModel,
              LogNoteFormViewModel,
              VisualBoardViewModel>(
          builder: (context, viewModel, userVM, selectedVM, lnVM, lnfVM, vbVM,
              child) {
        if (viewModel.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return CustomScaffold(
            title: VisualBoardFormPage.pageName,
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Column(
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomDropList(
                                titleHead: "Stage",
                                selected: viewModel.vb.stage,
                                items: vbVM.listStage,
                                itemAsString: (i) => i.name.toString(),
                                onChanged: viewModel.onChangeStage),
                            const SizedBox(height: 16),
                            // NAME
                            TextFormField(
                              minLines: 1,
                              maxLines: 5,
                              decoration: const InputDecoration(
                                labelText: 'Name',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                viewModel.updateField<String>('name', value);
                              },
                              initialValue: widget.data!.name,
                            ),
                            const SizedBox(height: 16),

                            // ASSIGNED IDS
                            Many2ManyField(
                              label: 'Assigned Employees',
                              items: widget.data!.assignees,
                              selectedItems: const [],
                            ),
                            const SizedBox(height: 16),

                            // REQUESTOR IDS
                            if (widget.data!.requestors.isNotEmpty)
                              Many2ManyField(
                                label: 'Requestors',
                                items: widget.data!.requestors,
                                selectedItems: const [],
                              ),
                            if (widget.data!.requestors.isNotEmpty)
                              const SizedBox(height: 16),

                            // DEPARTMENT IDS
                            Many2ManyField(
                              label: 'Departments',
                              items: const [],
                              itemDept: widget.data!.departments,
                              selectedItems: const [],
                            ),
                            const SizedBox(height: 16),

                            // DUE DATE
                            if (widget.data!.dueDate != null)
                              DateTimeField(
                                label: 'Due Date',
                                onChanged: (value) {},
                                initialValue: widget.data!.dueDate,
                              ),
                            const SizedBox(height: 16),

                            // ASSIGNED DATE (readonly)
                            if (widget.data!.assignedDT != null)
                              DateTimeField(
                                  label: 'Assigned Date',
                                  readOnly: true,
                                  initialValue: widget.data!.assignedDT),
                            const SizedBox(height: 16),

                            // DONE DATE (readonly)
                            if (widget.data!.doneDT != null)
                              DateTimeField(
                                  label: 'Done Date',
                                  readOnly: true,
                                  initialValue: widget.data!.doneDT),
                            const SizedBox(height: 16),

                            // DESCRIPTION
                            TextFormField(
                              minLines: 3,
                              maxLines: 10,
                              decoration: const InputDecoration(
                                labelText: 'Description',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                viewModel.updateField<String>(
                                    'description', value);
                              },
                              initialValue: widget.data!.description,
                            ),
                            const SizedBox(height: 16),
                            // Analytic
                            // LEAD DAY + OD DAY SIDE BY SIDE
                            Row(
                              children: [
                                if (widget.data!.id != 0 &&
                                    widget.data!.leadDay! > 0.5)
                                  Expanded(
                                    child: TextFormField(
                                      readOnly: true,
                                      decoration: const InputDecoration(
                                          labelText:
                                              'Lead Day (Done - Assigned)',
                                          border: OutlineInputBorder(),
                                          suffixText: "Day"),
                                      initialValue:
                                          widget.data!.leadDay.toString(),
                                    ),
                                  ),
                                if (widget.data!.id != 0 &&
                                    widget.data!.leadDay! > 0.5 &&
                                    widget.data!.odDay! > 0.5)
                                  const SizedBox(width: 16),
                                if (widget.data!.id != 0 &&
                                    widget.data!.odDay! > 0.5)
                                  Expanded(
                                    child: TextFormField(
                                      readOnly: true,
                                      decoration: const InputDecoration(
                                          labelText: 'OD Day (Due - Done)',
                                          border: OutlineInputBorder(),
                                          suffixText: "Day"),
                                      initialValue:
                                          widget.data!.odDay.toString(),
                                    ),
                                  ),
                              ],
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: mainPadding * 3),
                                child: ButtonCustom(
                                  text: 'Update',
                                  color: primaryColor,
                                  onTap: () async {
                                    viewModel.updateVB(context);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    WidgetCommentLogNote(
                        resId: widget.data!.id, model: visualBoard)
                  ],
                ),
              ),
            ),
          );
        }
      });
}
