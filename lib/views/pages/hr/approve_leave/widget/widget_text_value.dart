import 'package:flutter/material.dart';

import '../../../../../utils/theme.dart';

class WidgetTextValue extends StatelessWidget {
  final String title;
  final String? value;
  final Color valueColor;
  final FontWeight fontWeight;
  const WidgetTextValue(
      {super.key,
      required this.title,
      required this.value,
      this.valueColor = Colors.black87,
      this.fontWeight = FontWeight.w500});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: titleStyle13.copyWith(color: Colors.grey[600]),
        ),
        Flexible(
          child: Text(
            value ?? "N/A",
            style: titleStyle13.copyWith(
                color: valueColor, fontWeight: fontWeight),
          ),
        ),
      ],
    );
  }
}
