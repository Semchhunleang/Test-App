import 'dart:ui';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:umgkh_mobile/utils/theme.dart';

class CustomScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget? floatingBt;
  final bool resizeToAvoidBottomInset, isLoading;
  final GestureTapCallback? backAction;
  final List<Widget>? action;

  const CustomScaffold(
      {super.key,
      required this.title,
      required this.body,
      this.floatingBt,
      this.resizeToAvoidBottomInset = false,
      this.isLoading = false,
      this.backAction,
      this.action});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(
          FocusNode(),
        ),
        child: Scaffold(
            resizeToAvoidBottomInset: resizeToAvoidBottomInset,
            appBar: AppBar(
                leading: IconButton(
                  onPressed: backAction ?? () => Navigator.pop(context),
                  icon: Icon(Icons.arrow_back_rounded,
                      size: 25, color: primaryColor),
                ),
                title: Text(title, style: appBarStyle),
                actions: action),
            body: FadeIn(child: isLoading ? buildLoading() : body),
            floatingActionButton: floatingBt),
      );

  Widget buildLoading() => Stack(children: [
        body,
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
            child: Container(
              color: Colors.grey.withOpacity(0.1),
            ),
          ),
        ),
        const Center(
          child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Color(0xff273896),
              ),
              backgroundColor: Color(0xffffcb08),
              strokeWidth: 3.5),
        )
      ]);
}
