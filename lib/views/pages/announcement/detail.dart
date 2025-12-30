import 'package:flutter/material.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'package:umgkh_mobile/widgets/custom_scaffold.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class DetailAnnouncement extends StatelessWidget {
  static const routeName = '/detail-announcement';
  static const pageName = 'Detail Announcement';
  final String data;
  const DetailAnnouncement({super.key, required this.data});

  @override
  Widget build(BuildContext context) => CustomScaffold(
      title: pageName,
      body: Padding(
          padding: EdgeInsets.all(mainPadding),
          child: SizedBox(
              height: double.infinity,
              child: InteractiveViewer(
                  panEnabled: true,
                  scaleEnabled: true,
                  minScale: 1.0,
                  maxScale: 5.0,
                  child: SingleChildScrollView(
                      physics: kBounce, child: HtmlWidget(data),),),),),);
}
