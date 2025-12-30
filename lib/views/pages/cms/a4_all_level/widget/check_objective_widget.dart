import 'package:flutter/material.dart';
import 'package:umgkh_mobile/utils/theme.dart';

class CheckObjectiveWidget extends StatelessWidget {
  final String label;
  final String? title;
  final ValueChanged<bool?>? onChanged;
  final bool value;
  final bool isShowTitle;
  final bool isValidate;
  const CheckObjectiveWidget(
      {super.key,
      this.label = "",
      this.onChanged,
      this.value = false,
      this.title,
      this.isShowTitle = false,
      this.isValidate = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isShowTitle)
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Text(
              isValidate ? "$title (Required, please select)" : "$title",
              style: isValidate
                  ? titleStyle12.copyWith(color: redColor)
                  : titleStyle12,
            ),
          ),
        if (label != "null")
          Row(
            children: [
              Checkbox(
                value: value,
                onChanged: onChanged,
              ),
              Expanded(child: Text(label)),
            ],
          ),
      ],
    );
  }
}
