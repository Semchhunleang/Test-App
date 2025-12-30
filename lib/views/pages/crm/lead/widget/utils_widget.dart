import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/view_models/selections_view_model.dart';
import 'package:umgkh_mobile/widgets/button_custom.dart';
import 'package:umgkh_mobile/widgets/custom_drop_list.dart';

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
                }),),);

// =============================== CUSTOMER
Widget selectCustomer(
        {required dynamic selected,
        required dynamic Function(dynamic) onChanged,
        bool isTitle = true,
        bool isRemove = false,
        bool isValidate = false,
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
            onRemove: onRemove),);

// =============================== STATE
Widget selectState(
        {required dynamic selected,
        required dynamic Function(dynamic) onChanged}) =>
    Consumer<SelectionsViewModel>(
        builder: (context, viewModel, _) => Expanded(
            flex: 5,
            child: CustomDropList(
                titleHead: 'State',
                selected: selected,
                items: viewModel.state.toList(),
                itemAsString: (i) => i.name.toString(),
                onChanged: onChanged),),);

// =============================== COUNTRY
Widget selectCountry(
        {required dynamic selected,
        required dynamic Function(dynamic) onChanged}) =>
    Consumer<SelectionsViewModel>(
        builder: (context, viewModel, _) => Expanded(
            child: CustomDropList(
                titleHead: 'Country',
                selected: selected,
                items: viewModel.country.toList(),
                itemAsString: (i) => i.name.toString(),
                onChanged: onChanged),),);

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
            onChanged: onChanged),);

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
            onChanged: onChanged),);

// =============================== DIALOG CONVERT TO OPPORTUNITY
Future<void> convertToOpportunity(BuildContext context,
        {required dynamic selected,
        required dynamic Function(dynamic) onChanged}) =>
    showDialog<void>(
        context: context,
        builder: (BuildContext contextDialog) => GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(FocusNode(),),
            behavior: HitTestBehavior.translucent,
            child: StatefulBuilder(
                builder: (context, state) => AlertDialog(
                        actionsPadding: EdgeInsets.all(mainPadding / 2),
                        title: Padding(
                            padding: EdgeInsets.only(left: mainPadding / 2),
                            child: Text("Convert To Opportunity",
                                style: primary15Bold),),
                        content: SizedBox(
                            height: 80,
                            width: double.infinity,
                            child: selectCustomer(
                                isTitle: false,
                                selected: selected,
                                isValidate: selected.id == 0,
                                onChanged: (v) => state(() => selected = v),),),
                        actions: [
                          Padding(
                              padding: EdgeInsets.only(right: mainPadding / 2),
                              child: ButtonCustom(
                                  text: 'Convert',
                                  onTap: () {
                                    if (selected.id != 0) {
                                      onChanged(selected);
                                      Navigator.pop(context);
                                    }
                                  }),),
                          Align(
                              alignment: Alignment.bottomRight,
                              child: TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text('Close',
                                      style: primary12Bold.copyWith(
                                          color: redColor),),),)
                        ]),),),);
