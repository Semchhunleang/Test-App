import 'package:flutter/material.dart';
import 'package:umgkh_mobile/models/hr/leave/leave_type.dart';
import 'package:umgkh_mobile/utils/theme.dart';

class CustomDropLeaveType extends StatelessWidget {
  final Function(LeaveType?) onChanged;
  final LeaveType? dropdownvalue;
  final List<LeaveType>? items;

  const CustomDropLeaveType(
      {super.key, required this.onChanged, this.dropdownvalue, this.items});

  @override
  Widget build(BuildContext context) =>
      Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text("Leave Type", style: titleStyle15)),
        //DropdownButton(value: dropValue, items: items, onChanged: onChanged)
        widthSpace,
        Expanded(
            child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(width: 1, color: primaryColor)),
          child: DropdownButton(
            value: dropdownvalue,
            underline: sizedBoxShrink,
            isExpanded: true,
            borderRadius: BorderRadius.circular(10),
            padding: const EdgeInsets.symmetric(horizontal: 5),
            icon: Icon(Icons.arrow_drop_down_rounded,
                size: 20, color: primaryColor),
            onChanged: onChanged,
            items: items!
                .map(
                  (e) => DropdownMenuItem(
                    value: e,
                    child: Text(e.name, style: primary15Bold),
                  ),
                )
                .toList(),
          ),
        ))
      ]);
}
