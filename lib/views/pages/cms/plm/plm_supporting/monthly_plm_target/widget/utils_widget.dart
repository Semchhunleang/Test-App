import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/models/base/user/user.dart';
import 'package:umgkh_mobile/view_models/access_levels_view_model.dart';
import 'package:umgkh_mobile/view_models/selections_view_model.dart';
import 'package:umgkh_mobile/widgets/custom_drop_list.dart';

Widget selectEmployees({
  required dynamic selected,
  required dynamic Function(dynamic) onChanged,
  required int departmentId,
}) =>
    Consumer2<SelectionsViewModel, AccessLevelViewModel>(
      builder: (context, selectionVM, accessVM, _) {
        final allOption = User.defaultUser(id: 0, name: "All Employees");

        final filteredEmployees = selectionVM.employees
            .where((e) => e.department?.id == departmentId)
            .toList();

        return CustomDropList(
          enabled: accessVM.accessLevel.isDh == 1,
          isSearch: true,
          selected: selected,
          items: [
            allOption,
            ...filteredEmployees,
          ],
          itemAsString: (i) => i.name.toString(),
          onChanged: onChanged,
        );
      },
    );

// =============================== MONTH
Widget filterSelectMonth(
        {required String selected, required Function(String) onValue}) =>
    Consumer<SelectionsViewModel>(
      builder: (context, viewModel, _) => Expanded(
        child: CustomDropList(
            selected: viewModel.monthSelection[selected],
            items: viewModel.monthSelection.values.toList(),
            itemAsString: (i) => i.toString(),
            onChanged: (v) {
              final selectedKey = viewModel.monthSelection.entries
                  .firstWhere((entry) => entry.value == v)
                  .key;
              onValue(selectedKey);
            }),
      ),
    );

// =============================== YEAR
Widget filterSelectYear(
        {required String selected, required Function(String) onValue}) =>
    Consumer<SelectionsViewModel>(
      builder: (context, viewModel, _) => Expanded(
        child: CustomDropList(
            selected: viewModel.yearSelection[selected],
            items: viewModel.yearSelection.values.toList(),
            itemAsString: (i) => i.toString(),
            onChanged: (v) {
              final selectedKey = viewModel.yearSelection.entries
                  .firstWhere((entry) => entry.value == v)
                  .key;
              onValue(selectedKey);
            }),
      ),
    );
