import 'package:flutter/material.dart';
import 'package:umgkh_mobile/models/announcement/announcement.dart';
import 'package:umgkh_mobile/utils/navigator.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/views/pages/announcement/detail.dart';

class ItemAnnouncementWidget extends StatelessWidget {
  final Announcement data;
  const ItemAnnouncementWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: () => navPush(context, DetailAnnouncement(data: data.body),),
      child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(mainRadius / 2),),
          color: primaryColor.withOpacity(0.1),
          margin: EdgeInsets.symmetric(vertical: mainPadding / 2),
          child: Padding(
              padding: EdgeInsets.all(mainPadding * 1.2),
              child: Text(data.name, style: primary12Bold),),),);
}
