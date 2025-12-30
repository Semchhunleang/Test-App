import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/view_models/overtime_view_model.dart';
import 'package:umgkh_mobile/views/pages/hr/request_overtime/widget/widget_drop_filters.dart';
import 'package:umgkh_mobile/widgets/textfield.dart';

class TopCardOvertime extends StatefulWidget {
  const TopCardOvertime({Key? key}) : super(key: key);

  @override
  State<TopCardOvertime> createState() => _TopCardOvertimeState();
}

class _TopCardOvertimeState extends State<TopCardOvertime> {

  @override
  Widget build(BuildContext context) {
    return Consumer<OvertimeViewModel>(
      builder: (context, viewModel, child) {
        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          color: primaryColor.withOpacity(0.1),
          margin: EdgeInsets.symmetric(
            horizontal: mainPadding,
            vertical: mainPadding / 2,
          ),
          child: Padding(
            padding: EdgeInsets.all(mainPadding),
            child: Column(
              children: [
                // search
                SearchTextfield(
                  ctrl: viewModel.searchCtrl,
                  onChanged: viewModel.onSearchChanged,
                ),
                heithSpace,

                // filter
                WidgetDropFilters(
                  optionsState: viewModel.optionStates,
                  selectedYear: viewModel.year,
                  selectedState: viewModel.selectedState,
                  onYearChanged: (v) {
                    viewModel.setYear(v!);
                  },
                  onStateChanged: (v) {
                    viewModel.setSelectedState(v!);
                    if (viewModel.selectedState == 'all') {
                      viewModel.fetchData();
                    } else {
                      viewModel.filterState();
                    }
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
