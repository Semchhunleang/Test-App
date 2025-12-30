import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/view_models/approve_employee_overtime_hr_view_model.dart';
import 'package:umgkh_mobile/view_models/selections_view_model.dart';
import '../../../../../utils/theme.dart';
import '../../../../../view_models/global_provider.dart';
import '../../../../../widgets/textfield.dart';
import '../../request_overtime/widget/widget_drop_filters.dart';

class SearchBlockWidget extends StatelessWidget {
  const SearchBlockWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer3<ApproveEmployeeOvertimeHRViewModel, GlobalProvider,
            SelectionsViewModel>(
        builder: (context, approvalModel, globalProvider, selectModel, child) {
      Map<int, String> departmentMap = {
        0: "All Department",
        for (var department in selectModel.department)
          department.id: department.name,
      };
      return Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: primaryColor.withOpacity(0.1),
        margin: EdgeInsets.symmetric(
            horizontal: mainPadding, vertical: mainPadding / 2),
        child: Padding(
          padding: EdgeInsets.all(mainPadding),
          child: Column(
            children: [
              // Search text field
              SearchTextfield(
                ctrl: approvalModel.searchController,
                onChanged: (v) {
                  approvalModel.search = v;
                },
                onEditing: () {
                  FocusScope.of(context).unfocus(); // Dismiss the keyboard
                  // No need for additional actions on editing
                },
              ),
              heithSpace,

              // Filter dropdown
              WidgetDropFilters(
                optionsState: approvalModel.optionStates,
                selectedState: approvalModel.selectedState,
                selectedYear: approvalModel.year,
                selectedDepartment: approvalModel.selectedDepartment,
                optionsDepartment: departmentMap,
                onYearChanged: (v) {
                  approvalModel.year = v;
                },
                onStateChanged: (v) {
                  approvalModel.selectedState = v;
                },
                onDepartmentChanged: (v) {
                  approvalModel.selectedDepartment = v;
                },
                isShowDepartment: true,
              ),
            ],
          ),
        ),
      );
    });
  }
}
