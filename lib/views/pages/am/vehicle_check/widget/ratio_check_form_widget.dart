import 'package:flutter/material.dart';
import 'package:umgkh_mobile/utils/theme.dart';

class RatioCheckFormWidget extends StatelessWidget {
  final String selectedValue;
  final void Function(String?)? onChanged;
  final String value;
  final String label;
  const RatioCheckFormWidget(
      {super.key,
      required this.selectedValue,
      this.onChanged,
      required this.value,
      required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Radio<String>(
          value: value,
          groupValue: selectedValue,
          onChanged: onChanged,
          activeColor: approvedColor),
      Text(label, style: titleStyle12)
    ]);
  }
}
