import 'package:flutter/material.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/utils/utlis.dart';

class ShowNotificationPage extends StatelessWidget {
  final String title, body;
  const ShowNotificationPage(
      {super.key, required this.title, required this.body});

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leadingWidth: 60,
          leading: IconButton(
              icon: const Icon(Icons.close, color: Colors.red),
              onPressed: () => Navigator.of(context).pop()),
          centerTitle: true,
          title: Text('Nenam Notification',
              style: titleStyle15.copyWith(fontSize: 17))),
      body: Center(
          child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(title,
                        textAlign: TextAlign.center,
                        style: primary15Bold.copyWith(fontSize: 18)),

                    // divider
                    Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: mainPadding * 2, vertical: mainPadding),
                        child: Divider(color: primaryColor, thickness: 0.2)),

                    // Body
                    Expanded(
                        child: SingleChildScrollView(
                            physics: kBounce,
                            child: Text(body,
                                textAlign: TextAlign.justify,
                                style: titleStyle15))),
                  ]))));
}
