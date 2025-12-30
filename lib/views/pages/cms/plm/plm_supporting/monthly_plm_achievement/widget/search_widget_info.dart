import 'package:flutter/material.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/view_models/plm/plm_supporting/monthly_plm_achievement_form_view_model.dart';
import 'package:umgkh_mobile/widgets/textfield.dart';

Widget searchWidgetInfo(
    BuildContext context, MonthlyPlmAchievementFormViewModel viewModel) {
  return Table(
    columnWidths: const {
      0: IntrinsicColumnWidth(),
      1: FlexColumnWidth(),
    },
    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
    children: [
      TableRow(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text("Month", style: primary14Bold),
          ),
          // Padding(
          //   padding: const EdgeInsets.fromLTRB(15, 8, 0, 8),
          //   child: filterSelectMonth(
          //     selected: viewModel.selectedMonth,
          //     onValue: (v) => viewModel.onChangedMonth(context, v),
          //   ),
          // ),
        ],
      ),
      TableRow(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text("Year", style: primary14Bold),
          ),
          // Padding(
          //   padding: const EdgeInsets.fromLTRB(15, 8, 0, 8),
          //   child: filterSelectYear(
          //     selected: viewModel.selectedYear,
          //     onValue: (v) => viewModel.onChangedYear(context, v),
          //   ),
          // ),
        ],
      ),
      TableRow(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text("Employee", style: primary14Bold),
          ),
          // Padding(
          //   padding: const EdgeInsets.fromLTRB(15, 8, 0, 15),
          //   child: selectEmployees(
          //     selected: viewModel.selectEmployee,
          //     onChanged: viewModel.onChangeEmployee,
          //   ),
          // ),
        ],
      ),
      TableRow(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text("Department", style: primary14Bold),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 0, 8),
            child: InputTextField(
              ctrl: viewModel.departmentCtrl,
              title: '',
              enableSelectText: false,
              keyboardType: TextInputType.number,
              readOnly: true,
            ),
          ),
        ],
      ),
      TableRow(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text("Job Position", style: primary14Bold),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 8, 0, 8),
            child: InputTextField(
              ctrl: viewModel.jobPositionCtrl,
              title: '',
              enableSelectText: false,
              keyboardType: TextInputType.number,
              readOnly: true,
            ),
          ),
        ],
      ),
    ],
  );
}
