import 'package:flutter/material.dart';
import 'package:umgkh_mobile/utils/navigator.dart';
import 'package:umgkh_mobile/utils/theme.dart';

class WidgetButtonActionn extends StatelessWidget {
  final String name;
  final Widget page;
  final IconData icon;
  const WidgetButtonActionn(
      {super.key, required this.name, required this.page, required this.icon});

  @override
  Widget build(BuildContext context) => item(context);

  Widget item(BuildContext context) => GestureDetector(
        onTap: () => navPush(context, page),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(mainRadius),
          ),
          color: primaryColor,
          margin: EdgeInsets.symmetric(vertical: mainPadding / 2),
          child: Padding(
            padding: EdgeInsets.all(mainPadding * 1.2),
            child: Row(children: [
              Icon(icon, color: whiteColor),
              widthSpace,
              Text(name, style: white13Bold)
            ]),
          ),
        ),
      );
}
