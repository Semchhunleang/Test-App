import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/models/umg/umg_social_media.dart';
import 'package:umgkh_mobile/utils/launch_utils.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'package:umgkh_mobile/view_models/selections_view_model.dart';

class WidgetUMGSocialMediaLink extends StatelessWidget {
  const WidgetUMGSocialMediaLink({super.key});

  @override
  Widget build(BuildContext context) => Center(
      child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: kBounce,
          padding: EdgeInsets.symmetric(
              horizontal: mainPadding * 2, vertical: mainPadding * 2.5),
          child: Consumer<SelectionsViewModel>(
              builder: (context, viewModel, _) => Row(
                  children: viewModel.umgSocialMedia
                      .map((data) => itemSocialMedia(context, data))
                      .toList()))));
}

Widget itemSocialMedia(BuildContext context, UMGSocialMedia data) =>
    GestureDetector(
        onTap: () => data.links.length > 1
            ? showDialogUMGSocialMedia(context, data.name, data.links)
            : launchUniversalLink(data.links[0].link),
        child: Container(
            padding: const EdgeInsets.all(2.5),
            margin: EdgeInsets.only(right: mainPadding / 2),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade300, width: 2),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.shade200,
                      blurRadius: 8,
                      spreadRadius: 4)
                ]),
            child: ClipOval(
                child: Image.asset(imageSocialMeida(data.code),
                    width: 25, height: 25, fit: BoxFit.cover))));

String imageSocialMeida(String code) {
  switch (code) {
    case 'umg':
      return 'assets/icons/social/umg.jpg';
    case 'mtd':
      return 'assets/icons/social/matador.jpg';
    case 'fb':
      return 'assets/icons/social/fb.png';
    case 'ig':
      return 'assets/icons/social/ig.png';
    case 'yt':
      return 'assets/icons/social/yt.png';
    case 'tt':
      return 'assets/icons/social/tiktok.jpg';
    case 'li':
      return 'assets/icons/social/linkedin.png';
    default:
      return 'assets/icons/social/umg.jpg';
  }
}

void showDialogUMGSocialMedia(
        BuildContext context, String title, List<UMGSocialMedia> data) =>
    showDialog(
        context: context,
        builder: (BuildContext context) => Dialog(
            child: SingleChildScrollView(
                physics: kBounce,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: mainPadding * 1.2,
                              vertical: mainPadding),
                          child: Text(title,
                              style: titleStyle15.copyWith(fontSize: 20))),
                      Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: mainPadding),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: data
                                  .asMap()
                                  .entries
                                  .map((item) => itemDialog(
                                      item.value, item.key == data.length - 1))
                                  .toList())),
                      Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                              padding: EdgeInsets.all(mainPadding / 3),
                              child: TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text('Close',
                                      style: primary12Bold.copyWith(
                                          color: redColor)))))
                    ]))));

Widget itemDialog(UMGSocialMedia data, bool isLast) => GestureDetector(
      onTap: () => launchUniversalLink(data.link),
      child: Column(
        children: [
          Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(mainRadius / 2),
                child: Image.asset(imageSocialMeida(data.code),
                    height: 35,
                    width: 35,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.error, color: Colors.grey.shade400))),
            width10Space,
            Expanded(
                child: Text(data.name,
                    maxLines: 2,
                    style:
                        primary12Bold.copyWith(fontWeight: FontWeight.w400))),
            Icon(Icons.arrow_forward_rounded,
                color: Colors.blueGrey.shade200, size: 12)
          ]),
          if (!isLast)
            Padding(
                padding: const EdgeInsets.only(left: 46),
                child: Divider(color: primaryColor.withOpacity(0.1)))
        ],
      ),
    );
