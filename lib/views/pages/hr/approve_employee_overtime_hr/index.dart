import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/view_models/access_levels_view_model.dart';
import 'package:umgkh_mobile/view_models/approve_employee_overtime_form_view_model.dart';
import 'package:umgkh_mobile/view_models/approve_employee_overtime_hr_view_model.dart';
import 'package:umgkh_mobile/view_models/selections_view_model.dart';
import 'package:umgkh_mobile/widgets/list_condition.dart';
import '../../../../utils/theme.dart';
import '../../../../view_models/global_provider.dart';
import '../../../../widgets/custom_scaffold.dart';
import 'widget/search_block_widget.dart';
import 'widget/widget_item_approval_overtime.dart';

class ApproveEmployeeOvertimeHrPage extends StatefulWidget {
  static const routeName = '/approve_employee_overtime_hr';
  static const namePage = 'Approve Employee Overtime HR';
  const ApproveEmployeeOvertimeHrPage({super.key});

  @override
  State<ApproveEmployeeOvertimeHrPage> createState() =>
      _ApproveEmployeeOvertimeHrPageState();
}

class _ApproveEmployeeOvertimeHrPageState
    extends State<ApproveEmployeeOvertimeHrPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ApproveEmployeeOvertimeHRViewModel>(context, listen: false);
      Provider.of<GlobalProvider>(context, listen: false);
      Provider.of<ApproveEmployeeOvertimeHRViewModel>(context, listen: false)
          .fetchApproveEmployeeOT();
      Provider.of<AccessLevelViewModel>(context, listen: false).fetchLocal();
      Provider.of<SelectionsViewModel>(context, listen: false)
          .fetchDepartment();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: ApproveEmployeeOvertimeHrPage.namePage,
      body: Consumer2<ApproveEmployeeOvertimeHRViewModel,
          ApproveEmployeeOvertimeFormViewModel>(
        builder: (context, viewModel, updateStateProvider, child) {
          return Column(
            children: [
              const SearchBlockWidget(),
              ListCondition(
                viewModel: viewModel,
                showedData: viewModel.filterApprovalOTList,
                onRefresh: () async {
                  await viewModel.fetchApproveEmployeeOT();
                  viewModel.year = DateTime.now().year;
                  viewModel.selectedState = "all";
                  viewModel.searchController.text = "";
                  viewModel.search = "";
                  viewModel.selectedDepartment = 0;
                },
                child: FadeIn(
                  child: ListView.builder(
                    padding: EdgeInsets.fromLTRB(
                        mainPadding, 0, mainPadding, mainPadding * 5.5),
                    itemCount: viewModel.filterApprovalOTList.length,
                    itemBuilder: (context, index) {
                      final request = viewModel.filterApprovalOTList[index];
                      return WidgetItemApprovalOvertime(data: request);
                    },
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
