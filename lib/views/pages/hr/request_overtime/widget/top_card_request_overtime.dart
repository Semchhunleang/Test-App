import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/view_models/request_overtime_view_model.dart';
import 'package:umgkh_mobile/views/pages/hr/request_overtime/widget/widget_drop_filters.dart';
import 'package:umgkh_mobile/widgets/textfield.dart';

class TopCardRequestOvertime extends StatefulWidget {
  const TopCardRequestOvertime({Key? key}) : super(key: key);

  @override
  State<TopCardRequestOvertime> createState() => _TopCardRequestOvertimeState();
}

class _TopCardRequestOvertimeState extends State<TopCardRequestOvertime> {

  @override
  Widget build(BuildContext context) {
    return Consumer<RequestOvertimeViewModel>(
      builder: (context, viewModel, child) {
       return Card(
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
          color: primaryColor.withOpacity(0.1),
          margin: EdgeInsets.symmetric(
              horizontal: mainPadding, vertical: mainPadding / 2),
          child: Padding(
            padding: EdgeInsets.all(mainPadding),
            child: Column(
              children: [
                // Search text field
                SearchTextfield(
                  // initialValue: viewModel.search,
                  ctrl: viewModel.searchController,
                  onChanged: (v) {
                    viewModel.search = v;
                  },
                  onEditing: () {
                    FocusScope.of(context).unfocus(); // Dismiss the keyboard
                    // No need for additional actions on editing
                  },
                ),
                heithSpace,

                // Filter dropdown
                WidgetDropFilters(
                  optionsState: viewModel.optionStates,
                  selectedState: viewModel.selectedState,
                  selectedYear: viewModel.year,
                  onYearChanged: (v) {
                    viewModel.year = v;
                  },
                  onStateChanged: (v) {
                    viewModel.selectedState = v;
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
