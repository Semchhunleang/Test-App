import 'package:flutter/material.dart';
import 'package:umgkh_mobile/utils/theme.dart';

class CustomDropPeriod extends StatelessWidget {
  final Function(String?) onChanged;
  final String? dropValue;
  final bool readOnly;
  const CustomDropPeriod(
      {super.key,
      required this.onChanged,
      required this.dropValue,
      this.readOnly = false});

  @override
  Widget build(BuildContext context) => Expanded(
        child: IgnorePointer(
          ignoring: readOnly,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 5),
                child: Text('Choose Period', style: titleStyle15)),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 1, color: primaryColor)),
              child: DropdownButton(
                value: dropValue,
                underline: sizedBoxShrink,
                isExpanded: true,
                borderRadius: BorderRadius.circular(10),
                padding: const EdgeInsets.symmetric(horizontal: 5),
                icon: Icon(Icons.arrow_drop_down_rounded,
                    size: 20, color: readOnly ? greyColor : primaryColor),
                onChanged: onChanged,
                items: items
                    .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e,
                            style: primary15Bold.copyWith(
                                color: readOnly ? greyColor : primaryColor))))
                    .toList(),
              ),
            )
          ]),
        ),
      );
}

var items = ["Morning", "Afternoon"];
