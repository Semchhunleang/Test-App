import 'package:flutter/material.dart';
import 'package:umgkh_mobile/utils/theme.dart';

class SelectApprovalOTListWidget extends StatelessWidget {
  final GestureTapCallback? onTap;
  final bool isSelected;
  const SelectApprovalOTListWidget(
      {super.key, this.onTap, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(mainRadius)),
        color: primaryColor.withOpacity(0.4),
        margin: EdgeInsets.symmetric(vertical: mainPadding / 2),
        child: Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Icon(
                      isSelected ? Icons.check_circle : Icons.circle,
                      color: isSelected ? Colors.green : Colors.grey.shade400,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
