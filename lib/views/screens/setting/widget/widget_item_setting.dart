import 'package:flutter/material.dart';
import 'package:umgkh_mobile/utils/theme.dart';

class WidgetItemSectionSetting extends StatelessWidget {
  final String title;
  const WidgetItemSectionSetting({super.key, required this.title});

  @override
  Widget build(BuildContext context) => Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: greyColor.withOpacity(0.1)),
      child: Text(title,
          style: titleStyle13.copyWith(fontWeight: FontWeight.bold)));
}

class WidgetItemSetting extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function() onTap;
  final bool isLast;
  const WidgetItemSetting({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) => InkWell(
      onTap: onTap,
      highlightColor: greyColor.withOpacity(0.1),
      splashColor: greyColor.withOpacity(0.1),
      child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: mainPadding, vertical: mainPadding / 2),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                    radius: 15,
                    backgroundColor: primaryColor.withOpacity(0.1),
                    child: Icon(icon, color: primaryColor, size: 15)),
                width10Space,
                Text(title, style: titleStyle13),
                const Spacer(),
                Icon(Icons.arrow_forward_ios_rounded,
                    size: 10, color: greyColor.withOpacity(0.5))
              ])));
}
