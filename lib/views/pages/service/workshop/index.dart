// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/view_models/field_service_view_model.dart';
import 'package:umgkh_mobile/view_models/selections_view_model.dart';
import 'package:umgkh_mobile/views/pages/service/field_service/widget/utils_widget.dart';
import 'package:umgkh_mobile/views/pages/service/workshop/widget/item_workshop.dart';
import 'package:umgkh_mobile/widgets/custom_scaffold.dart';
import 'package:umgkh_mobile/widgets/list_condition.dart';
import 'package:umgkh_mobile/widgets/textfield.dart';

class WorkshopPage extends StatefulWidget {
  static const routeName = '/workshop';
  static const pageName = 'Workshop';
  const WorkshopPage({super.key});

  @override
  State<WorkshopPage> createState() => _WorkshopPageState();
}

class _WorkshopPageState extends State<WorkshopPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final p1 = Provider.of<FieldServiceViewModel>(context, listen: false);
      final p2 = Provider.of<SelectionsViewModel>(context, listen: false);
      await p2.fetchServiceStage(context);
      p2.fetchSystemComponent();
      p2.fetchFSPhenomenon();
      p2.fetchFSAction();
      p2.fetchAllEmployee();
      p2.fetchJobAssignLineStatus();
      p2.fetchCustomerSatisfied();
      p2.fetchServiceJobPoint();
      p2.fetchFleetVehicle();
      p1.resetData('workshop');
      p1.fetchData('workshop');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Consumer<FieldServiceViewModel>(
        builder: (context, viewModel, _) => CustomScaffold(
          title: WorkshopPage.pageName,
          body: Column(
            children: [
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: primaryColor.withOpacity(0.1),
                margin: EdgeInsets.symmetric(
                    horizontal: mainPadding, vertical: mainPadding / 2),
                child: Padding(
                  padding: EdgeInsets.all(mainPadding),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: SearchTextfield(
                                ctrl: viewModel.searchCtrl,
                                onChanged: viewModel.onSearchChanged),
                          ),
                          width5Space,
                          InkWell(
                            onTap: viewModel.changeShowFilter,
                            borderRadius: BorderRadius.circular(mainRadius * 2),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                              child: Icon(
                                size: 24,
                                color: viewModel.showFilter == false
                                    ? Colors.red
                                    : primaryColor,
                                viewModel.showFilter == false
                                    ? Icons.filter_alt_off_rounded
                                    : Icons.filter_alt_rounded,
                              ),
                            ),
                          )
                        ],
                      ),
                      if (viewModel.showFilter == true) heithSpace,
                      if (viewModel.showFilter == true)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(width: 1, color: primaryColor),
                              ),
                              child: TextButton(
                                onPressed: () => _selectDate(context, true),
                                child: Text(
                                  'Start : ${DateFormat('dd/MM/yyyy').format(viewModel.startDate)}',
                                  style: TextStyle(color: primaryColor),
                                ),
                              ),
                            ),
                            Text(
                              '-',
                              style: TextStyle(color: primaryColor),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(width: 1, color: primaryColor),
                              ),
                              child: TextButton(
                                onPressed: () => _selectDate(context, false),
                                child: Text(
                                  'End : ${DateFormat('dd/MM/yyyy').format(viewModel.endDate)}',
                                  style: TextStyle(color: primaryColor),
                                ),
                              ),
                            ),
                          ],
                        ),
                      if (viewModel.showFilter == true) heithSpace,
                      if (viewModel.showFilter == true)
                        Row(
                          children: [
                            Text("Stage Included",
                                style: TextStyle(color: primaryColor)),
                            widthSpace,
                            filterFieldServiceStage(
                                selected: viewModel.selectedStage,
                                onChanged: viewModel.onChangeStage),
                          ],
                        ),
                      if (viewModel.showFilter == true) heithSpace,
                      if (viewModel.showFilter == true)
                        Row(
                          children: [
                            Text("Stage Excluded",
                                style: TextStyle(color: primaryColor)),
                            widthSpace,
                            filterFieldServiceStage(
                                selected: viewModel.excludedStage,
                                onChanged: viewModel.onChangeExcludeStage),
                          ],
                        ),
                      if (viewModel.showFilter == true) heithSpace,
                      if (viewModel.showFilter == true)
                        Row(
                          children: [
                            Text("Assigned Status",
                                style: TextStyle(color: primaryColor)),
                            widthSpace,
                            filterJobAssignLineStatus(
                              selected: viewModel.selectedStatus,
                              onChanged: (v) =>
                                  viewModel.onChangeStatus(v, context),
                            )
                          ],
                        ),
                    ],
                  ),
                ),
              ),

              // list
              ListCondition(
                viewModel: viewModel,
                showedData: viewModel.showedData,
                onRefresh: () => viewModel.fetchData('workshop'),
                child: ListView.builder(
                  padding: EdgeInsets.fromLTRB(
                      mainPadding, 0, mainPadding, mainPadding * 5.5),
                  itemCount: viewModel.showedData.length,
                  itemBuilder: (context, i) =>
                      ItemWorkshopWidget(data: viewModel.showedData[i]),
                ),
              )
            ],
          ),
        ),
      );

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate
          ? Provider.of<FieldServiceViewModel>(context, listen: false).startDate
          : Provider.of<FieldServiceViewModel>(context, listen: false).endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        Provider.of<FieldServiceViewModel>(context, listen: false)
            .setDate(picked, isStartDate, 'field_service');
      });
    }
  }
}
