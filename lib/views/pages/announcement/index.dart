import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/view_models/announcement_view_model.dart';
import 'package:umgkh_mobile/views/pages/announcement/widget/item_announcement_widget.dart';
import 'package:umgkh_mobile/widgets/list_condition.dart';
import 'package:umgkh_mobile/widgets/custom_scaffold.dart';
import 'package:umgkh_mobile/widgets/textfield.dart';

class AnnouncementPage extends StatefulWidget {
  static const routeName = '/announcement';
  static const pageName = 'Announcement';
  const AnnouncementPage({super.key});

  @override
  State<AnnouncementPage> createState() => _AnnouncementPageState();
}

class _AnnouncementPageState extends State<AnnouncementPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AnnouncementViewModel>(context, listen: false).fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AnnouncementViewModel>(
      builder: (context, viewModel, _) => CustomScaffold(
        title: AnnouncementPage.pageName,
        body: Column(
          children: [
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: primaryColor.withOpacity(0.1),
              margin: EdgeInsets.symmetric(
                horizontal: mainPadding,
                vertical: mainPadding / 2,
              ),
              child: Padding(
                padding: EdgeInsets.all(mainPadding),
                child: Column(
                  children: [
                    // Search bar
                    SearchTextfield(
                      ctrl: viewModel.searchCtrl,
                      onChanged: viewModel.onSearchChanged,
                    ),
                  ],
                ),
              ),
            ),

            // Loading or data display section
            ListCondition(
              viewModel: viewModel,
              showedData: viewModel.showedData,
              onRefresh: () async {
                await viewModel.fetchData();
                viewModel.searchCtrl.clear();
              },
              child: ListView.builder(
                padding: EdgeInsets.fromLTRB(
                  mainPadding,
                  0,
                  mainPadding,
                  mainPadding * 5.5,
                ),
                itemCount: viewModel.showedData.length,
                itemBuilder: (context, i) => ItemAnnouncementWidget(
                  data: viewModel.showedData[i],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
