import 'package:flutter/material.dart';
import 'package:umgkh_mobile/utils/theme.dart';

class CustomStateBar extends StatelessWidget {
  final String text;
  final Color? color, textColor;
  final double? textsize;
  const CustomStateBar(
      {super.key,
      required this.text,
      this.color,
      this.textColor,
      this.textsize});

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        height: 40.0,
        decoration: BoxDecoration(
          color: whiteColor,
          border: Border(
            bottom: BorderSide(color: primaryColor, width: 1.0),
            top: BorderSide(color: primaryColor, width: 1.0),
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 3),
            )
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: primary15Bold.copyWith(color: color),
          ),
        ),
      );
}
