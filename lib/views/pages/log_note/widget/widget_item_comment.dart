import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:umgkh_mobile/models/log_note/log_note.dart';
import 'package:umgkh_mobile/utils/constants.dart';
import 'package:umgkh_mobile/utils/navigator.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'package:umgkh_mobile/views/pages/image/index.dart';

const double localHeight = 40.0;

class WidgetItemComment extends StatelessWidget {
  final LogNote data;
  final bool isLast;
  const WidgetItemComment(
      {super.key, required this.data, required this.isLast});

  @override
  Widget build(BuildContext context) => Column(children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // imaege
          commentImage(
              id: data.employee.profile,
              onTap: () => navPush(
                  context,
                  ViewFullImagePage(
                      image: Constants.attachmentById(data.employee.profile)))),

          // text
          width10Space,
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                RichText(
                    text: TextSpan(
                        text: data.employee.name,
                        style: primary12Bold,
                        children: [
                      TextSpan(
                          text: ' • ${timeAgo(data.date)}',
                          style: hintStyle.copyWith(
                              fontSize: 9, color: blackColor.withOpacity(0.5)))
                    ])),
                HtmlWidget(data.body,
                    textStyle: primary12Bold.copyWith(
                        fontSize: 11, color: blackColor.withOpacity(0.6))),
                heith5Space,
                Text(formatReadableDT(data.date),
                    style: hintStyle.copyWith(
                        fontSize: 9, color: blackColor.withOpacity(0.5)))
              ]))
        ]),

        // comment image
        if (data.images.isNotEmpty) ...[
          heith5Space,
          SizedBox(
              height: localHeight,
              width: double.infinity,
              child: Align(
                  alignment: Alignment.centerRight,
                  child: ListView(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      physics: kBounce,
                      padding: EdgeInsets.only(left: mainPadding * 3.4),
                      children: List.generate(data.images.length,
                          (i) => evidence(context, data.images[i], i)))))
        ],

        // divide
        if (!isLast) ...[
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Divider(color: greyColor.withOpacity(0.5), height: 0.3))
        ]
      ]);

  Widget evidence(BuildContext context, int id, int index) => Padding(
      padding: EdgeInsets.only(right: mainPadding / 2),
      child: commentImage(
          id: id,
          onTap: () => navPush(
              context,
              ViewFullImagePage(
                  index: index,
                  image: data.images
                      .map((e) => Constants.attachmentById(e))
                      .toList()))));

  Widget commentImage({required int id, required Function() onTap}) => SizedBox(
      height: localHeight,
      width: localHeight,
      child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Material(
              color: greyColor.withOpacity(0.5),
              child: Image(
                  image:
                      NetworkImage(id != 0 ? Constants.attachmentById(id) : ''),
                  fit: BoxFit.cover,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return GestureDetector(onTap: onTap, child: child);
                    }
                    return Center(
                        child: Icon(Icons.photo_rounded, color: greyColor));
                  },
                  errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.person_2_outlined,
                      color: greyColor,
                      size: 25)))));
}
