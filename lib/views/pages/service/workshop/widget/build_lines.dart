import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/models/service-project_task/project_task/project_task.dart';
import 'package:umgkh_mobile/utils/navigator.dart';
import 'package:umgkh_mobile/utils/static_state.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'package:umgkh_mobile/view_models/field_service_view_model.dart';
import 'package:umgkh_mobile/view_models/timesheet_form_view_model.dart';
import 'package:umgkh_mobile/views/pages/service/workshop/call_customer/call_customer_from.dart';
import 'package:umgkh_mobile/views/pages/service/workshop/job_analytic/form.dart';
import 'package:umgkh_mobile/views/pages/service/workshop/job_finish/form.dart';
import 'package:umgkh_mobile/views/pages/service/workshop/overall_checking/form.dart';
import 'package:umgkh_mobile/views/pages/service/workshop/service_report/form.dart';
import 'package:umgkh_mobile/views/pages/service/workshop/timesheet/form_remark.dart';
import 'package:umgkh_mobile/views/pages/service/workshop/widget/item_call_customer.dart';
import 'package:umgkh_mobile/views/pages/service/workshop/widget/item_job_analytic.dart';
import 'package:umgkh_mobile/views/pages/service/workshop/widget/item_job_assign.dart';
import 'package:umgkh_mobile/views/pages/service/workshop/widget/item_job_finish.dart';
import 'package:umgkh_mobile/views/pages/service/workshop/widget/item_overall_checking.dart';
import 'package:umgkh_mobile/views/pages/service/workshop/widget/item_service_report.dart';
import 'package:umgkh_mobile/views/pages/service/workshop/widget/item_timesheet.dart';
import 'package:umgkh_mobile/views/pages/service/workshop/widget/timesheet/continue_pop_up.dart';
import 'package:umgkh_mobile/views/pages/service/workshop/widget/timesheet/pop_up_form.dart';
import 'package:umgkh_mobile/widgets/float_bt.dart';
import 'package:umgkh_mobile/widgets/list_condition.dart';

class BuildLinesFS extends StatefulWidget {
  const BuildLinesFS({
    super.key,
  });

  @override
  State<BuildLinesFS> createState() => _BuildLinesFSState();
}

class _BuildLinesFSState extends State<BuildLinesFS> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final p = Provider.of<TimesheetFormViewModel>(context, listen: false);
      final p1 = Provider.of<FieldServiceViewModel>(context, listen: false);
      await p1.resetData('workshop');
      await p.getLastIndex(p1.selectedData!);
      await p.isCheckButtonTimesheet(0, p1.selectedData!);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FieldServiceViewModel>(
      builder: (context, viewModel, _) {
        return Expanded(
          flex: 7,
          child: Scaffold(
            backgroundColor: transparent,
            floatingActionButton: viewModel.selectedData!.stage!.name != close
                ? _buildFloatingActionButton(viewModel.selected, viewModel)
                : null,
            body: Column(
              children: [
                _buildGrid(viewModel),
                viewModel.selected == 0
                    ? buildDesc(viewModel.selectedData?.description ?? '')
                    : ListCondition(
                        viewModel: viewModel,
                        showedData: _getShowedData(viewModel),
                        onRefresh: () => viewModel.fetchDataByData(
                          viewModel.selectedData!.id,
                          'workshop',
                          context: context,
                        ),
                        child: _buildListView(viewModel),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Builds the floating action button based on the selected value.
  Widget? _buildFloatingActionButton(int num, FieldServiceViewModel viewModel) {
    if (num == 0 || num == 1) return null;

    if (num == 2 &&
        (viewModel.selectedData?.stage?.name != evaluate &&
            viewModel.selectedData?.stage?.name != jobFinish)) {
      return timesheetBt();
    } else if (num == 4 &&
        ((viewModel.selectedData!.timesheetWorkshop != null &&
                (viewModel.selectedData!.overallCheckings != null &&
                    viewModel.selectedData!.timesheetWorkshop!.length ==
                        viewModel.selectedData!.overallCheckings!.length)) ||
            viewModel.selectedData!.timesheetWorkshop == null)) {
      return null;
    } else if (num == 5 &&
        ((viewModel.selectedData!.timesheetWorkshop != null &&
                (viewModel.selectedData!.serviceReports != null &&
                    viewModel.selectedData!.timesheetWorkshop!.length ==
                        viewModel.selectedData!.serviceReports!.length)) ||
            viewModel.selectedData!.timesheetWorkshop == null)) {
      return null;
    } else if ((num == 6) &&
        (((viewModel.selectedData?.stage?.name != evaluate ||
                    viewModel.selectedData?.stage?.name != jobFinish) &&
                viewModel.selectedData!.jobFinishes != null) ||
            viewModel.selectedData!.timesheetWorkshop == null ||
            (viewModel.selectedData!.timesheetWorkshop != null &&
                viewModel.selectedData!.timesheetWorkshop![0].jobCompleteDt ==
                    null))) {
      return null;
    } else if (num == 7) {
      if (viewModel.selectedData!.jobFinishes == null &&
          viewModel.selectedData?.stage?.name != evaluate) {
        return null;
      } else {
        return floatBt();
      }
    } else if (viewModel.selectedData?.stage?.name != evaluate &&
        viewModel.selectedData?.stage?.name != jobFinish) {
      return floatBt();
    } else {
      return null;
    }
  }

  /// Builds the grid view of items.
  Widget _buildGrid(FieldServiceViewModel viewModel) {
    return GridView.count(
      physics: neverScroll,
      shrinkWrap: true,
      crossAxisCount: 4,
      childAspectRatio: 2.5,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      children: List.generate(
        viewModel.lines?.length ?? 0,
        (index) => buildItem(index),
      ),
    );
  }

  /// Determines the data to be shown based on the selected value.
  dynamic _getShowedData(FieldServiceViewModel viewModel) {
    if (viewModel.selected == 1) {
      return viewModel.selectedData?.jobAssignLines ?? [];
    } else if (viewModel.selected == 2) {
      return viewModel.selectedData?.timesheetWorkshop ?? [];
    } else if (viewModel.selected == 4) {
      return viewModel.selectedData?.overallCheckings ?? [];
    } else if (viewModel.selected == 5) {
      return viewModel.selectedData?.serviceReports ?? [];
    } else if (viewModel.selected == 6) {
      return viewModel.selectedData?.jobFinishes ?? [];
    } else if (viewModel.selected == 7) {
      return viewModel.selectedData?.jobAnalytics ?? [];
    } else if (viewModel.selected == 3) {
      return viewModel.selectedData?.callToCustomers ?? [];
    } else {
      return viewModel.lines?[viewModel.selected].data ?? [];
    }
  }

  /// Builds the list view based on the selected value.
  Widget _buildListView(FieldServiceViewModel viewModel) {
    final itemCount = viewModel.selected == 2
        ? viewModel.selectedData?.timesheetWorkshop?.length ?? 0
        : viewModel.selected == 5
            ? viewModel.selectedData?.serviceReports?.length ?? 0
            : viewModel.selected == 6
                ? viewModel.selectedData?.jobFinishes?.length ?? 0
                : viewModel.selected == 7
                    ? viewModel.selectedData?.jobAnalytics?.length ?? 0
                    : viewModel.selected == 4
                        ? viewModel.selectedData?.overallCheckings?.length ?? 0
                        : viewModel.selected == 1
                            ? viewModel.selectedData?.jobAssignLines?.length ??
                                0
                            : viewModel.selected == 3
                                ? viewModel.selectedData?.callToCustomers
                                        ?.length ??
                                    0
                                : viewModel
                                    .lines?[viewModel.selected].data.length;

    return ListView.builder(
      physics: kBounce,
      itemCount: itemCount,
      padding: EdgeInsets.only(
        left: mainPadding,
        right: mainPadding,
        top: mainPadding / 2,
        bottom: viewModel.selected == 0 || viewModel.selected == 1
            ? mainPadding / 2
            : mainPadding * 6,
      ),
      itemBuilder: (context, index) {
        if (viewModel.selected == 5) {
          return ItemServiceReportWidget(
            data: viewModel.selectedData!.serviceReports![index],
          );
        } else if (viewModel.selected == 4) {
          return ItemOverallCheckingWidget(
            data: viewModel.selectedData!.overallCheckings![index],
          );
        } else if (viewModel.selected == 6) {
          return ItemJobFinishWidget(
            data: viewModel.selectedData!.jobFinishes![index],
          );
        } else if (viewModel.selected == 7) {
          return ItemJobAnalyticWidget(
            data: viewModel.selectedData!.jobAnalytics![index],
          );
        } else if (viewModel.selected == 2) {
          return ItemTimeSheetWidget(
            data: viewModel.selectedData!.timesheetWorkshop![index],
          );
        } else if (viewModel.selected == 1) {
          return ItemJobAssignWidget(
            data: viewModel.selectedData!.jobAssignLines![index],
          );
        } else if (viewModel.selected == 3) {
          return ItemCallCustomerWidget(
            data: viewModel.selectedData!.callToCustomers![index],
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  timesheetBt() => Consumer2<TimesheetFormViewModel, FieldServiceViewModel>(
          builder: (context, provider, providerFs, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (providerFs.selectedData!.timesheetWorkshop != null &&
                providerFs.selectedData!.timesheetWorkshop![0].jobStartDt !=
                    null &&
                providerFs.selectedData!.timesheetWorkshop![0].jobCompleteDt ==
                    null)
              bt('Pause Task', () {
                popUpFormAndInfo(context,
                    title: "Confirmation",
                    message: "Do you sure to pause the task?",
                    onTapAction: () async {
                  Navigator.pop(context);
                  await provider.insertPauseTask(context,
                      workshopId:
                          providerFs.selectedData!.timesheetWorkshop![0].id!);
                  await providerFs.fetchDataByData(
                      providerFs.selectedData!.id, 'workshop');
                });
              }, heroTag: 'pause_task'),
            widthSpace,
            bt(buttonCondition(providerFs.selectedData!), () {
              if (onCheckConditionJobStart(providerFs.selectedData!)) {
                popUpFormAndInfo(
                  context,
                  title: "Confirmation",
                  message: "Do you sure to start job?",
                  onTapAction: () {
                    Navigator.pop(context);
                    provider.insertTimesheetWorkshop(
                        context, providerFs.selectedData!.id, 'workshop');
                  },
                );
              } else if (onCheckConditionJobComplete(
                  providerFs.selectedData!)) {
                popUpFormAndInfo(
                  context,
                  child: const RemarkFormPage(),
                  onTapAction: () {
                    Navigator.pop(context);
                    provider.updateTimesheetWorkshop(
                        context,
                        providerFs.selectedData!.timesheetWorkshop![0].id!,
                        'workshop',
                        providerFs.selectedData!.id);
                  },
                );
              }
            }, heroTag: 'timesheet_task')
          ],
        );
      });

  String buttonCondition(ProjectTask data) {
    String title = "";
    if (onCheckConditionJobStart(data)) {
      title = 'Start Job';
    } else if (onCheckConditionJobComplete(data)) {
      title = 'Job Complete';
    }
    return title;
  }

  bool onCheckConditionJobStart(ProjectTask data) {
    if ((data.timesheetWorkshop != null &&
            data.timesheetWorkshop![0].jobStartDt == null) ||
        data.timesheetWorkshop == null ||
        (data.timesheetWorkshop != null &&
            data.timesheetWorkshop![0].jobStartDt != null &&
            data.timesheetWorkshop![0].jobCompleteDt != null)) {
      return true;
    } else {
      return false;
    }
  }

  bool onCheckOverallChecking(ProjectTask data) {
    int timesheetCount = 0;
    if (data.timesheetWorkshop == null) {
      timesheetCount = 0;
    }
    if (data.overallCheckings == null ||
        (data.overallCheckings != null &&
            data.timesheetWorkshop == null &&
            data.overallCheckings!.length < timesheetCount) ||
        (data.overallCheckings != null &&
            data.timesheetWorkshop != null &&
            data.overallCheckings!.length <= data.timesheetWorkshop!.length)) {
      return true;
    } else {
      return false;
    }
  }

  bool onCheckConditionJobComplete(ProjectTask data) {
    if (data.timesheetWorkshop != null &&
        data.timesheetWorkshop![0].jobCompleteDt == null) {
      return true;
    } else {
      return false;
    }
  }

  bool onCheckServiceReport(ProjectTask data) {
    int timesheetCount = 0;
    if (data.timesheetWorkshop == null) {
      timesheetCount = 0;
    }
    if (data.serviceReports == null ||
        (data.serviceReports != null &&
            data.timesheetWorkshop == null &&
            data.serviceReports!.length < timesheetCount) ||
        (data.serviceReports != null &&
            data.timesheetWorkshop != null &&
            data.serviceReports!.length < data.timesheetWorkshop!.length)) {
      return true;
    } else {
      return false;
    }
  }

  String message(ProjectTask data) {
    String message = "";
    if (onCheckConditionJobStart(data)) {
      message = "Can't fill Job Start Before you filled Overall Checking?";
    } else if (onCheckConditionJobComplete(data)) {
      message = "Can't fill Job Complete Before you filled Service Report?";
    }
    return message;
  }

  floatBt() =>
      Consumer<FieldServiceViewModel>(builder: (context, viewModel, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            bt(
              'Create',
              () async {
                if (mounted) {
                  await navPush(context,
                      pages(viewModel.selectedData!, viewModel.selected));
                }
              },
            )
          ],
        );
      });

  bt(String title, Function() onTap, {String? heroTag}) => DefaultFloatButton(
      onTap: onTap,
      heroTag: heroTag ?? UniqueKey(),
      type: 'text',
      title: title);

  Widget pages(ProjectTask data, int pageNum) {
    switch (pageNum) {
      case 3:
        return CallCustomerFormPage(id: data.id);
      case 4:
        return OverallCheckingFormPage(id: data.id);
      case 5:
        return ServiceReportFormPage(id: data.id);
      case 6:
        return JobFinishFormPage(id: data.id);
      case 7:
        return JobAnalyticFormPage(id: data.id);
      default:
        return const Text('Invalid View');
    }
  }

  buildItem(int index) =>
      Consumer<FieldServiceViewModel>(builder: (context, viewModel, child) {
        return Padding(
          padding: const EdgeInsets.all(2),
          child: InkWell(
            onTap: () => viewModel.lines![index].disable ? () {} : onTap(index),
            borderRadius: BorderRadius.circular(2),
            highlightColor: primaryColor.withOpacity(0.1),
            splashColor: primaryColor.withOpacity(0.1),
            child: Material(
              color: viewModel.selected == index
                  ? primaryColor
                  : viewModel.lines![index].disable
                      ? Colors.grey.shade300
                      : primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(2),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(3),
                  child: Text(
                    viewModel.lines![index].title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: titleStyle11.copyWith(
                        fontSize: 10,
                        color: viewModel.selected == index ? whiteColor : null,
                        fontWeight: viewModel.selected == index
                            ? FontWeight.bold
                            : null),
                  ),
                ),
              ),
            ),
          ),
        );
      });

  onTap(int index) {
    if (index == 2) {
      final pFS = Provider.of<FieldServiceViewModel>(context, listen: false);
      pFS.setSelected(index);
      final p = Provider.of<TimesheetFormViewModel>(context, listen: false);
      if (p.onContinueTask(
          Provider.of<FieldServiceViewModel>(context, listen: false)
              .selectedData!)) {
        continuePopup(context,
            timesheetId:
                Provider.of<FieldServiceViewModel>(context, listen: false)
                    .selectedData!
                    .timesheetWorkshop![0]
                    .pauseContinue![p.lastIndexPause]
                    .id!);
      }
    } else {
      final pFS = Provider.of<FieldServiceViewModel>(context, listen: false);
      pFS.setSelected(pFS.selectedData!.jobAssignLines == null ||
              pFS.selectedData!.jobAssignLines!.isEmpty ||
              pFS.selectedData!.jobAssignLines!.any((e) => e.state == wait)
          ? (index == 0 ? 0 : 1)
          : index);
    }
  }
}

buildDesc(String? data) {
  return Flexible(
    child: Padding(
      padding:
          EdgeInsets.symmetric(horizontal: mainPadding, vertical: mainPadding),
      child: data != null
          ? SingleChildScrollView(
              physics: kBounce,
              child: Column(
                children: [
                  HtmlWidget(data),
                ],
              ))
          : Container(),
    ),
  );
}
