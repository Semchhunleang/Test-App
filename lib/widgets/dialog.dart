import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:umgkh_mobile/utils/launch_utils.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/widgets/float_bt.dart';

void showBottomRightDialog(BuildContext context,
        {Function()? onGallery, Function()? onCapture, Function()? onFile}) =>
    showDialog(
        context: context,
        barrierColor: whiteColor.withOpacity(0.4),
        builder: (context) => FadeInRight(
            animate: true,
            duration: const Duration(milliseconds: 300),
            delay: const Duration(milliseconds: 50),
            from: 300,
            curve: Curves.easeOut,
            child: Stack(children: [
              Positioned(
                  bottom: 20,
                  right: 20,
                  child: Material(
                      color: transparent,
                      elevation: 0,
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        if (onGallery != null) ...[
                          DefaultFloatButton(
                              onTap: onGallery,
                              icon: Icons.photo_rounded,
                              height: 40,
                              width: 40,
                              iconSize: 20,
                              toolTip: 'From gallery'),
                        ],
                        if (onGallery != null && onCapture != null) heithSpace,
                        if (onCapture != null) ...[
                          DefaultFloatButton(
                              onTap: onCapture,
                              icon: Icons.camera_alt_rounded,
                              height: 40,
                              width: 40,
                              iconSize: 20,
                              toolTip: 'Take photo')
                        ],
                        if (onCapture != null && onFile != null) heithSpace,
                        if (onFile != null) ...[
                          DefaultFloatButton(
                              onTap: onFile,
                              icon: Icons.attach_file_rounded,
                              height: 40,
                              width: 40,
                              iconSize: 20,
                              toolTip: 'From File')
                        ]
                      ])))
            ])));

void showLoadingDialog(BuildContext context) => showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: whiteColor.withOpacity(0.5),
    builder: (context) => Stack(alignment: Alignment.center, children: [
          CircularProgressIndicator(strokeWidth: 2, color: primaryColor)
        ]));

void showWarningUpdateNenamDialog(BuildContext context, String localVersion,
        String apiVersion, String link) =>
    showGeneralDialog(
        context: context,
        barrierColor: Colors.black.withOpacity(0.3),
        barrierDismissible: false,
        barrierLabel: 'Required Update Nenam',
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (context, animation1, animation2) => sizedBoxShrink,
        transitionBuilder: (context, animation1, animation2, _) {
          final curved =
              CurvedAnimation(parent: animation1, curve: Curves.easeOut);
          return WillPopScope(
              onWillPop: () async => false, // block back button
              child: SlideTransition(
                  position: Tween<Offset>(
                          begin: const Offset(0, -1), end: Offset.zero)
                      .animate(curved),
                  child: FadeTransition(
                      opacity: curved,
                      child: Align(
                          alignment: Alignment.topCenter,
                          child: Material(
                              color: transparent,
                              child: Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: mainPadding,
                                      vertical: mainPadding * 4),
                                  padding: EdgeInsets.all(mainPadding),
                                  decoration: BoxDecoration(
                                      color: redColor,
                                      borderRadius:
                                          BorderRadius.circular(mainRadius),
                                      boxShadow: [
                                        BoxShadow(
                                            color: primaryColor, blurRadius: 10)
                                      ]),
                                  child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.warning_amber_rounded,
                                            size: 50,
                                            color: Colors.yellowAccent),
                                        heith5Space,
                                        Text('Nenam Update Required!',
                                            textAlign: TextAlign.center,
                                            style: primary15Bold.copyWith(
                                                color: whiteColor,
                                                fontSize: 18)),
                                        Text.rich(
                                            textAlign: TextAlign.center,
                                            TextSpan(
                                                text:
                                                    'Your current Nenam version: ',
                                                style: titleStyle12.copyWith(
                                                    color: whiteColor),
                                                children: [
                                                  TextSpan(
                                                      text: '($localVersion)',
                                                      style: primary15Bold
                                                          .copyWith(
                                                              color:
                                                                  whiteColor))
                                                ])),
                                        Text.rich(
                                            textAlign: TextAlign.center,
                                            TextSpan(
                                                text:
                                                    'It is outdated and does not match the requirement of latest Nenam release: ',
                                                style: titleStyle12.copyWith(
                                                    color: whiteColor),
                                                children: [
                                                  TextSpan(
                                                      text: '($apiVersion)',
                                                      style: primary15Bold
                                                          .copyWith(
                                                              color:
                                                                  whiteColor))
                                                ])),
                                        heithSpace,
                                        Text(
                                            'Please update the app immediately to continue using Nenam.',
                                            textAlign: TextAlign.center,
                                            style: titleStyle12.copyWith(
                                                color: Colors.red[100])),
                                        heithSpace,
                                        ElevatedButton.icon(
                                            onPressed: () =>
                                                launchAppStoreOrPlayStore(link),
                                            label: Text('Update Now',
                                                style: titleStyle12.copyWith(
                                                    color: whiteColor)),
                                            style: ElevatedButton.styleFrom(
                                                foregroundColor: whiteColor,
                                                backgroundColor: greenColor,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: mainPadding * 2,
                                                    vertical: mainPadding / 2),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            mainRadius))))
                                      ])))))));
        });

void showCustomConfirmDialog(
  BuildContext context, {
  String? title,
  String? message,
  String? cancelTitle,
  String? confirmTitle,
  VoidCallback? onCancel,
  VoidCallback? onConfirm,
  bool barrierDismissible = true,
  bool hasActionCancel = true,
}) {
  showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return AlertDialog(
            actionsPadding: const EdgeInsets.only(bottom: 5, right: 5),
            title: Text(title ?? 'Warning !',
                style: titleStyle15.copyWith(fontSize: 18)),
            content: Text(message ?? 'Are you sure you want to proceed ?',
                style: hintStyle),
            actions: [
              if (hasActionCancel) ...[
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      if (onCancel != null) onCancel();
                    },
                    child: Text(cancelTitle ?? 'No',
                        style: primary13Bold.copyWith(color: redColor)))
              ],
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (onConfirm != null) onConfirm();
                  },
                  child: Text(confirmTitle ?? 'Yes', style: primary13Bold))
            ]);
      });
}

void showCustomConfirmOdometerDialog(
  BuildContext context, {
  required String odometer,
  required VoidCallback onConfirm,
}) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            actionsPadding: const EdgeInsets.only(bottom: 5, right: 5),
            title: Text('Odometer Confirmation !',
                style: titleStyle15.copyWith(
                    fontSize: 18, fontWeight: FontWeight.w600)),
            content: Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: 'You have entered', style: titleStyle15),
                  TextSpan(
                      text: ' $odometer ',
                      style: titleStyle15.copyWith(
                          fontWeight: FontWeight.bold, color: redColor)),
                  TextSpan(text: 'km', style: titleStyle15),
                  TextSpan(
                      text:
                          '\n\nPlease confirm that this is the correct odometer before continuing.',
                      style: titleStyle15),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('No',
                      style: primary13Bold.copyWith(color: greyColor))),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onConfirm();
                  },
                  child: Text('Yes', style: primary13Bold))
            ]);
      });
}
