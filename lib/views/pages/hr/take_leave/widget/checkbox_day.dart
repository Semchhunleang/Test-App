import 'package:flutter/material.dart';
import 'package:umgkh_mobile/utils/theme.dart';

class CheckBoxDay extends StatelessWidget {
  final bool? isCheck;
  final Function(bool?) onChanged;
  const CheckBoxDay(
      {super.key, required this.isCheck, required this.onChanged});

  @override
  Widget build(BuildContext context) => Row(children: [
        Transform.scale(
          scale: 1.1,
          child: Checkbox(value: isCheck, onChanged: onChanged),
        ),
        Text('Half Day', style: titleStyle15)
      ]);
}
