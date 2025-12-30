import 'package:flutter/material.dart';
import 'package:umgkh_mobile/utils/theme.dart';

class WidgetNoAccess extends StatelessWidget {
  final String message;
  const WidgetNoAccess(
      {super.key,
      this.message = 'You do not have any permission to access this feature.'});

  @override
  Widget build(BuildContext context) => Center(
      child: Padding(
          padding: const EdgeInsets.only(bottom: 60),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            CircleAvatar(
                radius: 50,
                backgroundColor: redColor.withOpacity(0.1),
                child: Icon(Icons.lock_rounded,
                    color: redColor.withAlpha(250), size: 50)),
            heith10Space,
            Text('No Access!',
                textAlign: TextAlign.center,
                style: primary12Bold.copyWith(
                    color: Colors.black.withOpacity(0.8),
                    fontSize: 20,
                    letterSpacing: 1)),
            heith5Space,
            Padding(
                padding: EdgeInsets.symmetric(horizontal: mainPadding * 3),
                child: Text(message,
                    textAlign: TextAlign.center,
                    style: primary12Bold.copyWith(
                        fontWeight: FontWeight.w500,
                        color: Colors.blueGrey.withOpacity(0.5)))),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: mainPadding * 5),
                child: Text('Contact your admin.',
                    textAlign: TextAlign.center,
                    style: primary12Bold.copyWith(
                        fontWeight: FontWeight.w500,
                        color: Colors.blueGrey.withOpacity(0.5))))
          ])));
}
