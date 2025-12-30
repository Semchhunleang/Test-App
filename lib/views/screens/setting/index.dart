import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/utils/launch_utils.dart';
import 'package:umgkh_mobile/utils/navigator.dart';
import 'package:umgkh_mobile/view_models/login_view_model.dart';
import 'package:umgkh_mobile/view_models/setting_view_model.dart';
import 'package:umgkh_mobile/views/pages/app_info/index.dart';
import 'package:umgkh_mobile/views/pages/change_password/index.dart';
import 'package:umgkh_mobile/views/pages/maps/index.dart';
import 'package:umgkh_mobile/views/pages/profile/index.dart';
import 'package:umgkh_mobile/views/pages/vision_detector/register_face/index.dart';
import 'package:umgkh_mobile/views/screens/setting/widget/widget_item_setting.dart';
import 'package:umgkh_mobile/views/screens/setting/widget/widget_umg_social_media.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = '/settings';
  static const screenName = 'Settings';

  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      const WidgetItemSectionSetting(title: 'Account'),
      WidgetItemSetting(
          icon: Icons.person_rounded,
          title: 'Profile',
          onTap: () => navPush(context, const ProfilePage())),

      WidgetItemSetting(
          icon: Icons.lock_rounded,
          title: 'Change Password',
          onTap: () => navPush(context, const ChangePasswordPage())),

      const WidgetItemSectionSetting(title: 'Attendance'),
      WidgetItemSetting(
          icon: Icons.map_rounded,
          title: 'Attendance Area',
          onTap: () => navPush(context, const AttendanceAreaPage())),

      Consumer<SettingViewModel>(
          builder: (context, viewModel, _) => WidgetItemSetting(
              icon: Icons.face_rounded,
              title: viewModel.user.faceLandmarks == null ||
                      viewModel.user.faceLandmarks!.isEmpty
                  ? 'Register Face'
                  : 'Update Face',
              onTap: () => _showConfirmationDialog(context))),

      const WidgetItemSectionSetting(title: 'About App'),
      WidgetItemSetting(
          icon: Icons.privacy_tip_rounded,
          title: 'Privacy Policy',
          onTap: () => openPrivacy()),

      WidgetItemSetting(
          icon: Icons.settings_applications_rounded,
          title: 'App Info',
          onTap: () => navPush(context, const AppInfoPage())),

      const WidgetItemSectionSetting(title: 'Session'),
      WidgetItemSetting(
          icon: Icons.logout_rounded,
          title: 'Logout',
          onTap: () => Provider.of<LoginViewModel>(context, listen: false)
              .logout(context)),

      // UMG social media
      const WidgetUMGSocialMediaLink(),
    ]);
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Warning!'),
          content: const Text('Are you sure you want to proceed?'),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FaceDetectorRFView(),
                  ),
                ); // Proceed with navigation
              },
            ),
          ],
        );
      },
    );
  }
}
