import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/utils/static_state.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/view_models/notification_view_model.dart';
import 'package:umgkh_mobile/views/pages/notification/widget/item_notification_widget.dart';
import 'package:umgkh_mobile/views/pages/notification/widget/notification_drop_action_widget.dart';
import 'package:umgkh_mobile/widgets/custom_scaffold.dart';
import 'package:umgkh_mobile/widgets/list_condition.dart';

class NotificationListPage extends StatefulWidget {
  static const routeName = '/notification-list-page';
  static const pageName = 'Notifications';
  const NotificationListPage({super.key});

  @override
  State<NotificationListPage> createState() => _NotificationListPageState();
}

class _NotificationListPageState extends State<NotificationListPage> {
  @override
  void initState() {
    super.initState();
    final p = Provider.of<NotificationViewModel>(context, listen: false);
    p.resetData();
    p.fetchData();
  }

  @override
  Widget build(BuildContext context) => Consumer<NotificationViewModel>(
        builder: (context, viewModel, _) => CustomScaffold(
          title: NotificationListPage.pageName,
          action: [
            viewModel.showedData.isNotEmpty
                ? Padding(
                    padding: EdgeInsets.only(right: mainPadding),
                    child: NotificationDropActionWidget(
                        unreadCount:
                            viewModel.showedData.where((e) => !e.isRead).length,
                        allRecordCount: viewModel.showedData.length,
                        onSelected: (value) {
                          if (value == markAsRead) {
                            // MARK AS READ
                            viewModel.updateAllIsRead(context);
                          } else if (value == archiveAll) {
                            // ARCHIVED ALL
                            viewModel.updateArchiveAll(context);
                          }
                        }))
                : sizedBoxShrink
          ],
          body: Column(
            children: [
              ListCondition(
                viewModel: viewModel,
                showedData: viewModel.showedData,
                onRefresh: () => viewModel.fetchData(),
                child: ListView.builder(
                  padding: EdgeInsets.fromLTRB(
                      mainPadding / 2, 0, mainPadding / 2, mainPadding),
                  itemCount: viewModel.showedData.length,
                  itemBuilder: (context, i) =>
                      ItemNotificationWidget(data: viewModel.showedData[i]),
                ),
              )
            ],
          ),
        ),
      );
}
