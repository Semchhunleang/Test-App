import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/view_models/selections_view_model.dart';
import 'package:umgkh_mobile/widgets/custom_drop_list.dart';

// =============================== STATUS
Widget filterSelectStatus(
        {required String selected, required Function(String) onValue}) =>
    Consumer<SelectionsViewModel>(
      builder: (context, viewModel, _) => Expanded(
        child: CustomDropList(
            selected: viewModel.statusLeaveApproval[selected],
            items: viewModel.statusLeaveApproval.values.toList(),
            itemAsString: (i) => i.toString(),
            onChanged: (v) {
              final selectedKey = viewModel.statusLeaveApproval.entries
                  .firstWhere((entry) => entry.value == v)
                  .key;
              onValue(selectedKey);
            }),
      ),
    );

// =============================== YEAR
Widget filterYearLeaveApproval(
        {required Function() onTap, required int year}) =>
    Container(
      padding: const EdgeInsets.only(left: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(mainRadius / 2),
        border: Border.all(color: primaryColor),
      ),
      child: TextButton(
        onPressed: onTap,
        child: Row(children: [
          Text(
            '$year',
            style: const TextStyle(fontSize: 15),
          ),
          width10Space,
          Icon(Icons.arrow_drop_down_rounded, size: 20, color: primaryColor)
        ]),
      ),
    );
