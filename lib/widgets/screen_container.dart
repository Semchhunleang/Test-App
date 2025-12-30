import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/utils/navigator.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/view_models/home_view_model.dart';
import 'package:umgkh_mobile/view_models/notification_view_model.dart';
import 'package:umgkh_mobile/view_models/profile_view_model.dart';
import 'package:umgkh_mobile/views/pages/notification/index.dart';
import 'package:umgkh_mobile/views/pages/profile/index.dart';
import 'package:umgkh_mobile/views/screens/attendance/index.dart';
import 'package:umgkh_mobile/views/screens/home/index.dart';
import 'package:umgkh_mobile/views/screens/setting/index.dart';
import 'package:umgkh_mobile/widgets/bottom_navigation_bar.dart';

class ScreenContainer extends StatefulWidget {
  static const routeName = '/screen-container';
  static const namePage = 'Screen Container';
  final int pageIndex;
  const ScreenContainer({Key? key, required this.pageIndex}) : super(key: key);

  @override
  State<ScreenContainer> createState() => _ScreenContainerState();
}

class BodyOption {
  Widget? page;
  String? namePage;

  BodyOption({this.page, this.namePage});
}

class _ScreenContainerState extends State<ScreenContainer> {
  int currentIndex = 0;
  List<BodyOption> body = [];

  @override
  void initState() {
    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   Provider.of<SettingViewModel>(context, listen: false).fetchUserData();
    // });
    body.add(
      BodyOption(page: const HomeScreen(), namePage: HomeScreen.screenName),
    );
    body.add(
      BodyOption(
          page: const AttendanceScreen(),
          namePage: AttendanceScreen.screenName),
    );
    body.add(
      BodyOption(
          page: const SettingsScreen(), namePage: SettingsScreen.screenName),
    );
    currentIndex = widget.pageIndex;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProfileViewModel>(context, listen: false).fetchUserData();
      Provider.of<ProfileViewModel>(context, listen: false).getProfilePicture();
      Provider.of<NotificationViewModel>(context, listen: false).fetchData();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bodySelected = body[currentIndex].page;
    final String namePage = body[currentIndex].namePage!;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Stack(
          children: [

            /// 1. Snow overlay
            Positioned.fill(
              child: Image.asset(
                'assets/images/snow-overlay-button.png',
                fit: BoxFit.cover,
              ),
            ),

            /// 2. Real AppBar content
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(namePage),
              actions: [
                if (namePage == HomeScreen.screenName) ...[
                  notificationIconBadge(context),
                  width5Space,
                  imageProfile(),
                ]
              ],
            ),
          ],
        ),
      ),
      body: bodySelected,
      bottomNavigationBar:
          BottomNavBar(currentIndex: currentIndex, onTap: onTap),
    );
  }

  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });

    Provider.of<HomeViewModel>(context, listen: false).onRemoveSearch();
  }

  Widget notificationIconBadge(BuildContext context) =>
      Consumer<NotificationViewModel>(
        builder: (context, viewModel, _) => Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
                onPressed: () => navPush(context, const NotificationListPage()),
                icon: const Icon(Icons.notifications_rounded,
                    size: 25, color: Colors.grey)),
            if (viewModel.badgeCount() > 0)
              Positioned(
                  right: 10,
                  top: 12,
                  child: IgnorePointer(
                      child: CircleAvatar(
                          radius: 6.5,
                          backgroundColor: redColor,
                          child: Text(
                              viewModel.badgeCount() > 99
                                  ? '99+'
                                  : '${viewModel.badgeCount()}',
                              style: titleStyle11.copyWith(
                                  color: whiteColor, fontSize: 6.5),
                              textAlign: TextAlign.center))))
          ],
        ),
      );

  Widget imageProfile() => Padding(
        padding: EdgeInsets.symmetric(
            horizontal: mainPadding / 2, vertical: mainPadding / 3),
        child: Consumer<ProfileViewModel>(
            builder: (context, viewModel, _) =>
                viewModel.profilePicture.isNotEmpty
                    ? GestureDetector(
                        onTap: () => navPush(
                          context,
                          const ProfilePage(),
                        ),
                        child: CircleAvatar(
                          backgroundColor: primaryColor,
                          radius: 19,
                          child: CircleAvatar(
                              backgroundImage:
                                  MemoryImage(viewModel.profilePicture),
                              backgroundColor: transparent,
                              radius: 18),
                        ),
                      )
                    : sizedBoxShrink),
      );
}
