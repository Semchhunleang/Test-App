import 'package:flutter/material.dart';
import 'package:umgkh_mobile/utils/theme.dart';

class DefaultFloatButton extends StatelessWidget {
  final Function()? onTap;
  final String? toolTip;
  final IconData? icon;
  final Object? heroTag;
  final Widget? widget;
  final String type, title;
  final double height, width, iconSize;
  final Color? background;
  const DefaultFloatButton({
    super.key,
    this.onTap,
    this.toolTip = 'Create new record.',
    this.icon,
    this.heroTag,
    this.widget,
    this.type = 'icon',
    this.title = 'Create',
    this.height = 54.0,
    this.width = 54.0,
    this.iconSize = 25,
    this.background,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
      height: height,
      width: width,
      child: FloatingActionButton(
          backgroundColor: background ?? primaryColor,
          onPressed: onTap,
          tooltip: toolTip,
          heroTag: heroTag,
          shape: CircleBorder(
              side: BorderSide(
                  width: 1,
                  color: primaryColor.withOpacity(0.4),
                  strokeAlign: 2)),
          splashColor: whiteColor.withOpacity(0.1),
          elevation: 8.0,
          highlightElevation: 12.0,
          child: Stack(alignment: Alignment.center, children: [
            Container(
                height: height - 2,
                width: width - 2,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                        colors: [redColor.withOpacity(0.2), Colors.transparent],
                        radius: 0.8))),
            ShaderMask(
                shaderCallback: (Rect bounds) => LinearGradient(
                      colors: [Colors.white, Colors.purple.shade100],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds),
                child: widget ?? child())
          ])));

  Widget child() {
    switch (type) {
      case 'icon':
        return buildIcon();
      case 'text':
        return buildText();
      case 'loading':
        return buildLoading();
      default:
        return buildIcon();
    }
  }

  Widget buildIcon() => Icon(icon ?? Icons.add_circle_outline_rounded,
      size: iconSize, color: Colors.white, shadows: shadow);

  Widget buildText() => Padding(
      padding: const EdgeInsets.all(5),
      child: Text(title,
          textAlign: TextAlign.center,
          style: titleStyle12.copyWith(
              color: whiteColor,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              shadows: shadow)));
}

Widget buildLoading() => CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation<Color>(whiteColor),
    strokeWidth: 2.5,
    backgroundColor: Colors.grey.withOpacity(0.3),
    value: null,
    semanticsLabel: 'Loading');

List<Shadow> shadow = [
  Shadow(
      color: redColor.withOpacity(0.2),
      blurRadius: 3,
      offset: const Offset(1, 1))
];
