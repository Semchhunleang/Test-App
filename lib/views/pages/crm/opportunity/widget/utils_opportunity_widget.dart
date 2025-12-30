// =============================== Stages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../view_models/selections_view_model.dart';
import '../../../../../widgets/custom_drop_list.dart';

Widget selectStages(
        {required dynamic selected,
        String? titleHead,
        required dynamic Function(dynamic) onChanged}) =>
    Consumer<SelectionsViewModel>(
      builder: (context, viewModel, _) => CustomDropList(
          titleHead: titleHead,
          selected: selected,
          items: viewModel.stages.toList(),
          itemAsString: (i) => i.name.toString(),
          onChanged: onChanged),
    );

Widget selectStagesForm(
        {required dynamic selected,
        String? titleHead,
        required dynamic Function(dynamic) onChanged}) =>
    Consumer<SelectionsViewModel>(
      builder: (context, viewModel, _) => CustomDropList(
          titleHead: titleHead,
          selected: selected,
          items:
              viewModel.stages.where((stage) => stage.name != "All").toList(),
          itemAsString: (i) => i.name.toString(),
          onChanged: onChanged),
    );

Widget selectSaleTeams(
        {required bool isValidate,
        required dynamic selected,
        required dynamic Function(dynamic) onChanged}) =>
    Consumer<SelectionsViewModel>(
      builder: (context, viewModel, _) => Expanded(
        flex: 5,
        child: CustomDropList(
            isValidate: isValidate,
            titleHead: 'Sale team',
            selected: selected,
            items: viewModel.saleTeam.toList(),
            itemAsString: (i) => i.name.toString(),
            onChanged: onChanged),
      ),
    );
// =============================== PRIOTIY
Widget selectPriority(
        {required String selected, required Function(String) onValue}) =>
    Consumer<SelectionsViewModel>(
      builder: (context, viewModel, _) => Expanded(
        child: CustomDropList(
            titleHead: 'Priority',
            selected: viewModel.priorities[selected],
            items: viewModel.priorities.values.toList(),
            itemAsString: (i) => i.toString(),
            onChanged: (v) {
              final selectedKey = viewModel.priorities.entries
                  .firstWhere((entry) => entry.value == v)
                  .key;
              onValue(selectedKey);
            }),
      ),
    );

// =============================== CUSTOMER
Widget selectCustomer(
        {required dynamic selected,
        required dynamic Function(dynamic) onChanged,
        bool isTitle = true,
        bool isRemove = false,
        required bool isValidate,
        Function()? onRemove}) =>
    Consumer<SelectionsViewModel>(
      builder: (context, viewModel, _) => CustomDropList(
          isValidate: isValidate,
          titleHead: isTitle ? 'Customer' : null,
          isRemove: isRemove,
          isSearch: true,
          selected: selected,
          items: viewModel.customer.toList(),
          itemAsString: (i) => i.name.toString(),
          onChanged: onChanged,
          onRemove: onRemove),
    );

// =============================== STATE
Widget selectState(
        {required dynamic selected,
        required dynamic Function(dynamic) onChanged}) =>
    Consumer<SelectionsViewModel>(
      builder: (context, viewModel, _) => Expanded(
        flex: 5,
        child: CustomDropList(
            titleHead: 'State',
            enabled: false,
            selected: selected,
            items: viewModel.state.toList(),
            itemAsString: (i) => i.name.toString(),
            onChanged: onChanged),
      ),
    );

// =============================== COUNTRY
Widget selectCountry(
        {required dynamic selected,
        required dynamic Function(dynamic) onChanged}) =>
    Consumer<SelectionsViewModel>(
      builder: (context, viewModel, _) => Expanded(
        child: CustomDropList(
            titleHead: 'Country',
            enabled: false,
            selected: selected,
            items: viewModel.country.toList(),
            itemAsString: (i) => i.name.toString(),
            onChanged: onChanged),
      ),
    );

// =============================== SALE TEAM
Widget selectSaleTeam(
        {required bool isValidate,
        required dynamic selected,
        required dynamic Function(dynamic) onChanged}) =>
    Consumer<SelectionsViewModel>(
      builder: (context, viewModel, _) => CustomDropList(
          isValidate: isValidate,
          titleHead: 'Sale team',
          selected: selected,
          items: viewModel.saleTeam.toList(),
          itemAsString: (i) => i.name.toString(),
          onChanged: onChanged),
    );

// =============================== ACTIVITY TYPE
Widget selectActivityType(
        {required bool isValidate,
        required dynamic selected,
        required dynamic Function(dynamic) onChanged}) =>
    Consumer<SelectionsViewModel>(
      builder: (context, viewModel, _) => CustomDropList(
          isValidate: isValidate,
          titleHead: 'Type',
          selected: selected,
          items: viewModel.activityType.toList(),
          itemAsString: (i) => i.name.toString(),
          onChanged: onChanged),
    );
