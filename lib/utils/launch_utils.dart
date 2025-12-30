import 'package:flutter/material.dart';
import 'package:umgkh_mobile/utils/constants.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/widgets/button_custom.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> makePhoneCall(String phoneNumber) async {
  final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
  await launchUrl(launchUri);
}

Future<void> openPrivacy() async {
  await launchUrl(Uri.parse(Constants.privacyPolicy));
}

Future<void> launchUniversalLink(String link) async {
  dynamic url = Uri.parse(link);
  final bool nativeAppLaunchSucceeded =
      await launchUrl(url, mode: LaunchMode.externalNonBrowserApplication);
  if (!nativeAppLaunchSucceeded) {
    await launchUrl(url, mode: LaunchMode.inAppWebView);
  }
}

Future launchAppStoreOrPlayStore(String link) async {
  final url = Uri.parse(link);
  if (await canLaunchUrl(url)) {
    await launchUrl(url, mode: LaunchMode.externalApplication);
    // Future.delayed(const Duration(seconds: 1), () => exit(0)); // kill app
  } else {
    debugPrint('Could not launch application');
  }
}

void showCallButtomSheet(BuildContext context, String phone) =>
    showModalBottomSheet(
      backgroundColor: transparent,
      context: context,
      builder: (BuildContext context) => Padding(
        padding: EdgeInsets.all(mainPadding),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                ButtonCustom(
                  isExpan: true,
                  color: primaryColor,
                  icon: Icons.phone_rounded,
                  text: '$phone (Mr. Thea)',
                  onTap: () => makePhoneCall(phone),
                )
              ]),
              heith5Space,
              Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                ButtonCustom(
                  isExpan: true,
                  text: 'Cancel',
                  color: redColor,
                  onTap: () => Navigator.of(context).pop(),
                )
              ])
            ]),
      ),
    );

Future<void> openGoogleMap(double lat, double lng) async => await launchUrl(
    Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng'));
