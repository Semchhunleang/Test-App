import 'dart:async';
import 'package:flutter/material.dart';
import 'package:umgkh_mobile/utils/theme.dart';

class ButtonCustom extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  final Color? color, textColor;
  final double? textsize, iconSize;
  final bool isExpan, isDiable, isEnableCooldown;
  final IconData? icon;
  final EdgeInsetsGeometry? padding;

  const ButtonCustom(
      {super.key,
      required this.text,
      required this.onTap,
      this.color,
      this.textColor,
      this.textsize,
      this.iconSize = 20.0,
      this.isExpan = false,
      this.isDiable = false,
      this.isEnableCooldown = false,
      this.icon,
      this.padding});

  @override
  State<ButtonCustom> createState() => _ButtonCustomState();
}

class _ButtonCustomState extends State<ButtonCustom> {
  @override
  Widget build(BuildContext context) =>
      widget.isExpan ? Expanded(child: _button()) : _button();

  Widget _button() => Padding(
        padding: widget.padding ?? EdgeInsets.zero,
        child: ElevatedButton(
          onPressed: widget.isDiable
              ? null
              : widget.isEnableCooldown
                  ? preventDuplicateRecord
                  : widget.onTap,
          style: ElevatedButton.styleFrom(
              backgroundColor:
                  widget.isDiable ? Colors.grey : widget.color ?? primaryColor),
          child: widget.icon != null ? buildIcon() : buildText(),
        ),
      );

  Widget buildIcon() =>
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(widget.icon, size: 20, color: widget.textColor ?? whiteColor),
        width5Space,
        buildText()
      ]);

  Widget buildText() => Text(
        widget.text,
        textAlign: TextAlign.center,
        style: titleStyle13.copyWith(
            color: widget.textColor ?? whiteColor, fontSize: widget.textsize),
      );

// ============================================= prevent duplicate records
  bool isButtonDisabled = false;
  Timer? _timer;
  void preventDuplicateRecord() {
    if (isButtonDisabled) return; // prevent if button is disabled

    // disable button
    setState(() => isButtonDisabled = true);

    // actual logic or function to trigger api
    widget.onTap();

    // timer to re-enable the button after a short delay
    _timer = Timer(
      const Duration(seconds: 2),
      () => setState(() => isButtonDisabled = false),
    ); // Re-enable button
  }

  @override
  void dispose() {
    _timer?.cancel(); // cancel the timer if it exists
    super.dispose();
  }
// ============================================= end prevent
}

class StatusCustom extends StatelessWidget {
  final String text;
  final Color? color, textColor;
  final double? textsize;
  const StatusCustom(
      {super.key,
      required this.text,
      this.color,
      this.textColor,
      this.textsize});

  @override
  Widget build(BuildContext context) => ElevatedButton(
        onPressed: null,
        style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(color ?? primaryColor)),
        child: Text(
          text,
          style: titleStyle13.copyWith(
              color: textColor ?? Colors.white, fontSize: textsize),
        ),
      );
}

class CustomOutLineButton extends StatelessWidget {
  final String text;
  final Function() onTap;
  const CustomOutLineButton(
      {super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) => Expanded(
        child: OutlinedButton(
          onPressed: onTap,
          style: OutlinedButton.styleFrom(
            side: const BorderSide(width: 1, color: Colors.black45),
          ),
          child: Text(
            text,
            style: titleStyle13.copyWith(color: primaryColor),
          ),
        ),
      );
}

class CustomButtonAttachFile extends StatelessWidget {
  final Function() onTap;

  const CustomButtonAttachFile({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) => ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(Icons.attach_file, size: 15, color: primaryColor),
        label: Text("Attach files",
            style: titleStyle12.copyWith(color: primaryColor)),
        style: ElevatedButton.styleFrom(
            backgroundColor: transparent,
            foregroundColor: transparent,
            shadowColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            overlayColor: primaryColor.withOpacity(0.1),
            elevation: 0,
            side: BorderSide(width: 0.5, color: blackColor.withOpacity(0.1)),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(mainRadius / 2)),
            padding: EdgeInsets.symmetric(horizontal: mainPadding / 2)),
      );
}
