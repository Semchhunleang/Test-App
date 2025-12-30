import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/main.dart';
import 'package:umgkh_mobile/models/notification/notification.dart';
import 'package:umgkh_mobile/utils/launch_utils.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'package:umgkh_mobile/view_models/notification_view_model.dart';

class ItemNotificationWidget extends StatelessWidget {
  final NotificationList data;
  const ItemNotificationWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) => Consumer<NotificationViewModel>(
      builder: (context, viewModel, _) => Dismissible(
          key: ValueKey(data.id),
          direction: DismissDirection.endToStart,
          background: Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(horizontal: mainPadding),
              decoration: BoxDecoration(
                  color: redColor,
                  borderRadius: BorderRadius.circular(mainRadius)),
              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                Text("Archive",
                    style: primary13Bold.copyWith(
                        color: whiteColor, fontWeight: FontWeight.bold)),
                width10Space,
                Icon(Icons.delete_rounded, color: whiteColor)
              ])),
          onDismissed: (_) => viewModel.updateArchiveById(context, data.id),
          child: InkWell(
              onTap: () => onNavPage(context),
              borderRadius: BorderRadius.circular(mainRadius),
              child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(mainRadius)),
                  color: data.isRead
                      ? primaryColor.withOpacity(0.06)
                      : redColor.withOpacity(0.2),
                  child: Padding(
                      padding: EdgeInsets.all(mainPadding / 1.5),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            IgnorePointer(
                                child: CircleAvatar(
                                    radius: 15,
                                    backgroundColor:
                                        Colors.blueGrey.withOpacity(0.1),
                                    child: Icon(Icons.notifications_outlined,
                                        size: 15,
                                        color: data.isRead
                                            ? greenColor
                                            : redColor))),
                            width10Space,
                            Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            child: Text(data.title,
                                                style: primary13Bold,
                                                maxLines: 2,
                                                overflow:
                                                    TextOverflow.ellipsis)),
                                        width10Space,
                                        Text(timeAgo(data.createDate),
                                            style: primary12Bold.copyWith(
                                                fontSize: 8,
                                                color: data.isRead
                                                    ? Colors.blueGrey
                                                    : redColor))
                                      ]),
                                  Text(formatReadableDT(data.createDate),
                                      style: titleStyle11.copyWith(
                                          color: Colors.grey, fontSize: 10)),
                                  heith10Space,
                                  Text(data.message, style: titleStyle11)
                                ]))
                          ]))))));

  bool isNoPage() => data.page == "" || data.page == "/" || data.page == null;
  bool isNoUrl() => data.url == "" || data.url == "/" || data.url == null;

  void onNavPage(BuildContext context) async {
    final p = Provider.of<NotificationViewModel>(context, listen: false);
    if (data.isRead == false) p.updateIsRead(context, data.id);
    isNoPage()
        ? null
        : await MyApp.navigatorKey.currentState!.pushNamed(data.page!);
    isNoUrl() ? null : launchUniversalLink(data.url!);
  }
}
