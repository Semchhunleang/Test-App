import 'package:flutter/material.dart';
import 'package:umgkh_mobile/utils/static_state.dart';
import 'package:umgkh_mobile/utils/theme.dart';

class NotificationDropActionWidget extends StatelessWidget {
  final Function(String) onSelected;
  final int unreadCount;
  final int allRecordCount;

  const NotificationDropActionWidget({
    super.key,
    required this.onSelected,
    this.unreadCount = 0,
    this.allRecordCount = 0,
  });

  @override
  Widget build(BuildContext context) => PopupMenuButton<String>(
      onSelected: (value) => onSelected(value),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(mainRadius)),
      color: whiteColor,
      offset: const Offset(0, 50),
      tooltip: 'Notification Actions',
      splashRadius: mainRadius,
      elevation: 0,
      surfaceTintColor: transparent,
      child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: mainPadding / 1.5, vertical: mainPadding / 3),
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                primaryColor.withOpacity(0.6),
                primaryColor.withOpacity(0.7)
              ]),
              borderRadius: BorderRadius.circular(mainRadius),
              boxShadow: [
                BoxShadow(
                    color: greyColor, blurRadius: 4, offset: const Offset(0, 2))
              ]),
          child: Icon(Icons.more_horiz_rounded, color: whiteColor)),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            // MARK AS READ
            PopupMenuItem<String>(
                value: markAsRead,
                child: Row(children: [
                  Icon(Icons.mark_email_read_rounded, color: primaryColor),
                  width10Space,
                  Flexible(
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Text.rich(TextSpan(children: [
                      TextSpan(text: 'Mark as Read', style: titleStyle13),
                      if (unreadCount > 0) ...[
                        TextSpan(
                            text: ' ($unreadCount)',
                            style: titleStyle11.copyWith(
                                color: redColor, fontWeight: FontWeight.bold))
                      ]
                    ]))
                  ]))
                ])),

            // REMOVE ALL
            PopupMenuItem<String>(
                value: archiveAll,
                child: Row(children: [
                  Icon(Icons.delete_rounded, color: redColor),
                  width10Space,
                  Flexible(
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Text.rich(TextSpan(children: [
                      TextSpan(text: 'Archive All', style: titleStyle13),
                      if (allRecordCount > 0) ...[
                        TextSpan(
                            text: ' ($allRecordCount)',
                            style: titleStyle11.copyWith(
                                color: redColor, fontWeight: FontWeight.bold))
                      ]
                    ]))
                  ]))
                ]))
          ]);
}
