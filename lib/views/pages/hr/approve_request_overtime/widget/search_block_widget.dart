import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/view_models/approve_request_overtime_view_model.dart';

import '../../../../../utils/theme.dart';
import '../../../../../view_models/global_provider.dart';
import '../../../../../widgets/textfield.dart';
import '../../request_overtime/widget/widget_drop_filters.dart';

class SearchBlockWidget extends StatelessWidget {
  const SearchBlockWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ApproveRequestOvertimeViewModel, GlobalProvider>(
        builder: (context, approvalModel, globalProvider, child) {
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
                onYearChanged: (v) {
                  approvalModel.year = v;
                  approvalModel.onClearSelect();
                },
                onStateChanged: (v) {
                  approvalModel.selectedState = v;
                  approvalModel.onClearSelect();
                },
              ),
            ],
          ),
        ),
      );
    });
  }
}
