import 'package:flutter/material.dart';
import 'package:umgkh_mobile/utils/theme.dart';

class ButtonTab extends StatefulWidget {
  final String title;
  final bool active;
  final Function buttonClick;
  final int dividerNumber;
  const ButtonTab(
      {Key? key,
      required this.title,
      required this.buttonClick,
      required this.active,
      required this.dividerNumber,
      })
      : super(key: key);

  @override
  State<ButtonTab> createState() => _ButtonTabState();
}

class _ButtonTabState extends State<ButtonTab> {
  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(5),
      elevation: 0,
      child: Container(
        width: MediaQuery.of(context).size.width/widget.dividerNumber,
        decoration: BoxDecoration(
          border: Border(
            left: const BorderSide(
              color: Colors.grey,
              width: 0.5,
            ),
            right: const BorderSide(
              color: Colors.grey,
              width: 0.5,
            ),
            top: const BorderSide(
              color: Colors.grey,
              width: 0.5,
            ),
            bottom: BorderSide(
              color: widget.active
                  ? Colors.white
                  : Colors
                      .grey, // Adjusted color based on the 'active' property
              width: 0.5,
            ),
          ),
          color: widget.active ? Colors.blue[50] : Colors.transparent,
        ),

        child: Material(
          borderRadius: BorderRadius.circular(5),
          color: Colors.transparent,
          child: InkWell(
            splashColor: theme().secondaryHeaderColor,
            borderRadius: BorderRadius.circular(0),
            onTap: () => widget.buttonClick(),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(5, 1, 5, 1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: primary13Bold,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
