import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'package:umgkh_mobile/view_models/field_service_view_model.dart';
import 'package:umgkh_mobile/view_models/job_analytic_form_view_model.dart';
import 'package:umgkh_mobile/views/pages/service/field_service/widget/utils_widget.dart';
import 'package:umgkh_mobile/widgets/button_custom.dart';
import 'package:umgkh_mobile/widgets/custom_drop_list.dart';
import 'package:umgkh_mobile/widgets/custom_scaffold.dart';
import 'package:umgkh_mobile/widgets/textfield.dart';

class JobAnalyticFormPage extends StatefulWidget {
  final int id;
  const JobAnalyticFormPage({super.key, required this.id});

  @override
  State<JobAnalyticFormPage> createState() => _JobAnalyticFormPageState();
}

class _JobAnalyticFormPageState extends State<JobAnalyticFormPage> {
  @override
  void initState() {
    final p = Provider.of<JobAnalytisFormViewModel>(context, listen: false);
    p.resetValidate();
    p.resetForm();
    super.initState();
  }

  @override
  Widget build(BuildContext context) =>
      Consumer2<JobAnalytisFormViewModel, FieldServiceViewModel>(
          builder: (context, viewModel, viewModelFS, _) {
        final takenActionByUserIds =
            viewModelFS.getTakenActionByUserIds(widget.id, context);
        return CustomScaffold(
          resizeToAvoidBottomInset: true,
          isLoading: viewModel.isLoading,
          title: 'Create Job Analytic',
          body: ListView(
            physics: kBounce,
            padding: EdgeInsets.symmetric(horizontal: mainPadding),
            children: [
              selectSystemComponent(
                  validate: viewModel.isSystem,
                  selected: viewModel.system,
                  onChanged: viewModel.onChangeSystem),
              heithSpace,

              selectPhenomenon(
                  validate: viewModel.isPhenomenon,
                  selected: viewModel.phenomenon,
                  onChanged: viewModel.onChangePhenomenon),
              heithSpace,

              selectAction(
                  validate: viewModel.isAction,
                  selected: viewModel.action,
                  onChanged: viewModel.onChangeAction),
              heithSpace,

              // action by as multi
              Row(children: [
                Expanded(
                  child: CustomMultiDropList(
                    titleHead: 'Action By',
                    // enabled: !viewModel.isReadOnly,
                    // readOnlyAndFilled: viewModel.isReadOnly,
                    selected: viewModel.selectActionBy,
                    isValidate: viewModel.isActionBy,
                    items: viewModelFS.optionUser!
                        .where((e) =>
                            !viewModel.selectActionBy
                                .any((selected) => selected.id == e.id) &&
                            !takenActionByUserIds.contains(e.id))
                        .toList(),
                    itemAsString: (i) => i.name.toString(),
                    onChanged: viewModel.onChangeActionBy,
                    onRemove: viewModel.onRemoveActionBy,
                  ),
                ),
              ]),
              // selectActionBy(
              //     validate: viewModel.isActionBy,
              //     selected: viewModel.actionBy,
              //     onChanged: viewModel.onChangeActionBy),
              heithSpace,

              selectServiceJobPoint(
                  validate: viewModel.isServicePoint,
                  selected: viewModel.servicePoint,
                  onChanged: viewModel.onChangeServicePoint),
              heithSpace,

              MutliLineTextField(
                  ctrl: viewModel.noteCtrl,
                  title: 'Note',
                  hint: 'Enter note',
                  isValidate: viewModel.isNote,
                  validatedText: viewModel.isNote ? 'Field required' : '',
                  minLine: 5,
                  maxLine: 20,
                  onChanged: viewModel.onChangeNote),
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
                        SchedulerBinding.instance
                            .addPostFrameCallback((_) async {
                          await viewModelFS
                              .fetchDataByData(widget.id, 'workshop',
                                  context: context)
                              .then((value) {
                            viewModelFS.fetchDataByData(widget.id, 'workshop',
                                // ignore: use_build_context_synchronously
                                context: context);
                          });
                        });
                      }
                    },
                  ),
                ),
              ),
              ...multiheithSpace(2)
            ],
          ),
        );
      });
}
