import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/view_models/global_provider.dart';

class WidgetDropFilters extends StatelessWidget {
  final Function(int?) onYearChanged;
  final Function(String?) onStateChanged;
  final String? selectedState;
  final int? selectedYear;
  final Map<String, String> optionsState;
  final Map<int, String>? optionsDepartment;
  final int? selectedDepartment;
  final Function(int?)? onDepartmentChanged;
  final bool isShowDepartment;

  const WidgetDropFilters({
    super.key,
    required this.onYearChanged,
    required this.onStateChanged,
    this.selectedState,
    this.selectedYear,
    this.onDepartmentChanged,
    this.isShowDepartment = false,
    this.optionsDepartment,
    this.selectedDepartment,
    required this.optionsState,
  });

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              width: 100,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 1, color: primaryColor),
              ),
              child: Consumer<GlobalProvider>(
                builder: (__, provider, _) => DropdownButton<int>(
                  value: selectedYear,
                  items: provider.ddmenu,
                  borderRadius: BorderRadius.circular(10),
                  underline: sizedBoxShrink,
                  isExpanded: true,
                  padding: EdgeInsets.only(
                      left: mainPadding, right: mainPadding - 5),
                  style: primary13Bold,
                  icon: Icon(Icons.arrow_drop_down_rounded,
                      size: 20, color: primaryColor),
                  onChanged: (v) {
                    onYearChanged(v);
                  },
                ),
              ),
            ),
            widthSpace,
            Expanded(
                child: Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 1, color: primaryColor),
              ),
              child: DropdownSearch<String>(
                items: optionsState.values.toList(),
                itemAsString: (item) => item,
                onChanged: (String? newState) {
                  final selectedKey = optionsState.entries
                      .firstWhere((entry) => entry.value == newState)
                      .key;
                  onStateChanged(selectedKey);
                },
                selectedItem: selectedState != null
                    ? optionsState[selectedState]
                    : optionsState["all"],
                popupProps: const PopupProps.menu(fit: FlexFit.loose),
                dropdownButtonProps: DropdownButtonProps(
                  icon: Icon(Icons.arrow_drop_down_rounded,
                      size: 20, color: primaryColor),
                ),
                dropdownDecoratorProps: DropDownDecoratorProps(
                  baseStyle: primary13Bold,
                  textAlign: TextAlign.start,
                  textAlignVertical: TextAlignVertical.center,
                  dropdownSearchDecoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: mainPadding),
                      border: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none),
                ),
              ),
            ))
          ]),
          if (isShowDepartment) ...[
            heithSpace,
            Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 1, color: primaryColor),
              ),
              child: DropdownSearch<String>(
                items: optionsDepartment!.values.toList(),
                itemAsString: (item) => item,
                onChanged: (String? newState) {
                  final selectedKey = optionsDepartment!.entries
                      .firstWhere((entry) => entry.value == newState)
                      .key;
                  onDepartmentChanged!(selectedKey);
                },
                selectedItem: selectedDepartment != null &&
                        optionsDepartment!.containsKey(selectedDepartment)
                    ? optionsDepartment![selectedDepartment]
                    : "All Department",
                popupProps: const PopupProps.menu(fit: FlexFit.loose),
                dropdownButtonProps: DropdownButtonProps(
                  icon: Icon(Icons.arrow_drop_down_rounded,
                      size: 20, color: primaryColor),
                ),
                dropdownDecoratorProps: DropDownDecoratorProps(
                  baseStyle: primary13Bold,
                  textAlign: TextAlign.start,
                  textAlignVertical: TextAlignVertical.center,
                  dropdownSearchDecoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: mainPadding),
                      border: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none),
                ),
              ),
            ),
          ],
        ],
      );
}
