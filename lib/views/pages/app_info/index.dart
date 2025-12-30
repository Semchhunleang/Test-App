import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'package:umgkh_mobile/view_models/app_info_view_model.dart';
import 'package:umgkh_mobile/widgets/custom_scaffold.dart';

class AppInfoPage extends StatefulWidget {
  static const routeName = '/app-info';
  static const pageName = 'App Information';

  const AppInfoPage({super.key});

  @override
  State<AppInfoPage> createState() => _AppInfoPageState();
}

class _AppInfoPageState extends State<AppInfoPage> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    final vm = Provider.of<AppInfoiewModel>(context, listen: false);
    vm.checkCameraStatus();
    vm.checkLocationStatus();
    vm.checkNotificationStatus();
    vm.getAppVersion();
    vm.fetchNenamVersion();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      final vm = Provider.of<AppInfoiewModel>(context, listen: false);
      // this updates the UI when returning from settings
      vm.checkCameraStatus();
      vm.checkLocationStatus();
      vm.checkNotificationStatus();
    }
  }

  @override
  Widget build(BuildContext context) => Consumer<AppInfoiewModel>(
      builder: (context, viewModel, _) => CustomScaffold(
          title: AppInfoPage.pageName,
          resizeToAvoidBottomInset: true,
          body: ListView(physics: kBounce, children: [
            widgetSectionCard('Nenam Permission'),
            widgetItemCard(
                isOn: viewModel.isCameraEnable,
                icon: Icons.camera_alt_rounded,
                title: 'Camera',
                trailing: widgetSwitch(
                    isOn: viewModel.isCameraEnable,
                    onChanged: viewModel.onSwitchCamera)),
            widgetItemCard(
                isOn: viewModel.isLocationEnable,
                icon: Icons.share_location_rounded,
                title: 'Location',
                trailing: widgetSwitch(
                    isOn: viewModel.isLocationEnable,
                    onChanged: viewModel.onSwitchLocation)),
            widgetItemCard(
                isOn: viewModel.isNotifEnable,
                icon: Icons.notifications_rounded,
                title: 'Notification',
                trailing: widgetSwitch(
                    isOn: viewModel.isNotifEnable,
                    onChanged: viewModel.onSwitchNotification)),
            heith10Space,
            widgetSectionCard('About Nenam'),
            heith10Space,
            widgetItemCard(
                icon: Icons.rotate_90_degrees_cw_rounded,
                title: 'Version',
                trailing:
                    widgetVersion(viewModel.version, viewModel.releaseDT)),
          ])));

  Widget widgetSectionCard(String title) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: greyColor.withOpacity(0.1)),
      child: Text(title,
          style: titleStyle13.copyWith(fontWeight: FontWeight.bold)));

  Widget widgetItemCard(
          {bool isOn = true,
          required IconData icon,
          required String title,
          required Widget trailing}) =>
      Padding(
          padding: EdgeInsets.only(left: mainPadding, right: mainPadding),
          child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            CircleAvatar(
                radius: 15,
                backgroundColor: isOn
                    ? primaryColor.withOpacity(0.1)
                    : redColor.withOpacity(0.8),
                child: Icon(icon,
                    color: isOn ? primaryColor : whiteColor, size: 15)),
            width10Space,
            Text(title, style: titleStyle13),
            const Spacer(),
            trailing
          ]));

  Widget widgetVersion(String version, DateTime? date) => RichText(
          text: TextSpan(text: version, style: hintStyle, children: [
        if (date != null) ...[
          TextSpan(text: ' • ', style: titleStyle12),
          TextSpan(
              text: formatReadableDate(date),
              style:
                  hintStyle.copyWith(fontStyle: FontStyle.italic, fontSize: 10))
        ]
      ]));

  Widget widgetSwitch(
          {required bool isOn, required Function(bool) onChanged}) =>
      Transform.scale(
          scale: 0.7,
          child: Switch(
              value: isOn,
              onChanged: onChanged,
              activeColor: primaryColor,
              inactiveThumbColor: greyColor,
              inactiveTrackColor: greyColor.withOpacity(0.2)));
}
