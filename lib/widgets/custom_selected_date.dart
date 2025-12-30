import 'package:flutter/material.dart';
import 'package:umgkh_mobile/utils/theme.dart';

class CustomSelectDate extends StatelessWidget {
  final TextEditingController ctrl;
  final String title;
  final String hint;
  final Function()? onTap;
  final bool readOnlyAndFilled;
  final bool isRequired;
  const CustomSelectDate({
    super.key,
    required this.ctrl,
    this.title = '',
    this.hint = 'Choose date',
    this.onTap,
    this.readOnlyAndFilled = false,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (title != '')
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 5),
            child: Text(title, style: titleStyle13),
          ),
        Container(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                width: 1,
                color: readOnlyAndFilled
                    ? Colors.grey.shade400
                    : isRequired
                        ? redColor
                        : primaryColor),
          ),
          child: TextField(
            controller: ctrl,
            readOnly: true,
            enableInteractiveSelection: false,
            style: readOnlyAndFilled
                ? primary13Bold.copyWith(color: Colors.grey.shade400)
                : primary13Bold,
            onTap: readOnlyAndFilled ? null : onTap,
            decoration: InputDecoration(
                suffixIcon: Icon(
                  Icons.date_range_rounded,
                  size: 18,
                  color:
                      readOnlyAndFilled ? Colors.grey.shade400 : primaryColor,
                ),
                hintText: hint,
                hintStyle: hintStyle,
                suffixIconConstraints: const BoxConstraints(),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none),
          ),
        ),
        isRequired
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: mainPadding),
                child: Text(
                  'Date is required',
                  style: hintStyle.copyWith(color: redColor, fontSize: 10),
                ),
              )
            : sizedBoxShrink
      ]);
}
