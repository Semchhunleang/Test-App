import 'package:flutter/material.dart';
import 'package:umgkh_mobile/utils/theme.dart';

class ItemDescriptionWidget extends StatelessWidget {
  final String value;
  const ItemDescriptionWidget({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Icon(
              Icons.circle_sharp,
              size: 12,
            ),
            width5Space,
            Text(
              value,
              style: titleStyle12,
            ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
      ],
    );
  }
}
