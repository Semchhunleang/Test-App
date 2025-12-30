import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/models/crm/activity/activity.dart';
import 'package:umgkh_mobile/utils/constants.dart';
import 'package:umgkh_mobile/utils/navigator.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'package:umgkh_mobile/view_models/activity_view_model.dart';
import 'package:umgkh_mobile/views/pages/crm/activity/form.dart';
import 'package:umgkh_mobile/views/pages/image/index.dart';
import 'package:umgkh_mobile/widgets/widget_image.dart';

class ItemActivityWidget extends StatelessWidget {
  final Activity data;
  final int leadId;
  final bool canEdit, isRefreshSchedule;

  const ItemActivityWidget(
      {super.key,
      required this.data,
      required this.leadId,
      this.canEdit = false,
      this.isRefreshSchedule = false});

  @override
  Widget build(BuildContext context) => Consumer<ActivityViewModel>(
      builder: (context, p, _) => GestureDetector(
          onTap: canEdit
              ? () async {
                  await navPush(context, ActivityFormPage(id: 0, data: data),);
                  isRefreshSchedule
                      ? {p.fetchSchedule(leadId), p.fetchActivity(leadId)}
                      : p.fetchActivityOrSchedule(true);
                }
              : () {},
          child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(mainRadius),),
              color: primaryColor.withOpacity(0.1),
              margin: EdgeInsets.symmetric(vertical: mainPadding / 2),
              child: Padding(
                  padding: EdgeInsets.all(mainPadding * 1.2),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(formatDate(data.date), style: primary13Bold),
                              Material(
                                  borderRadius:
                                      BorderRadius.circular(mainRadius / 3),
                                  child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 3),
                                      child: Text('${data.type?.name}',
                                          style: primary13Bold.copyWith(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600),),),)
                            ]),
                        heith5Space,
                        heith5Space,
                        HtmlWidget(data.body.toString(),
                            textStyle: titleStyle12),
                        if (data.images.isNotEmpty) ...[heithSpace, buildImg()]
                      ]),),),));

  Widget buildImg() => Consumer<ActivityViewModel>(
      builder: (context, p, _) => GridView.builder(
          shrinkWrap: true,
          physics: neverScroll,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: mainPadding / 2,
              mainAxisSpacing: mainPadding / 2),
          itemCount: data.images.length,
          itemBuilder: (context, i) => GestureDetector(
              onTap: () => navPush(
                  context,
                  ViewFullImagePage(
                      index: i,
                      image: data.images
                          .map((e) => Constants.leadActivityPictureSeto(
                              leadId.toString(), e.toString(),),)
                          .toList(),),),
              child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(20),),
                  child: Image.network(
                      Constants.leadActivityPictureSeto(
                          leadId.toString(), data.images[i].toString(),),
                      fit: BoxFit.cover, loadingBuilder: (BuildContext context,
                          Widget child, ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return const Center(child: WidgetLoadImage(),);
                  }, errorBuilder: (context, error, stackTrace) {
                    return Container(color: Colors.white);
                  }),),),));
}
