import 'package:flutter/cupertino.dart';

Future navPush<T extends Object>(BuildContext context, Widget page) {
  FocusScope.of(context).requestFocus(FocusNode(),);
  return Navigator.of(context)
      .push(CupertinoPageRoute(builder: (context) => page),);
}

Future<T> navPushAndClear<T extends Object>(BuildContext context, Widget page) {
  FocusScope.of(context).unfocus();
  return Navigator.of(context)
      .pushReplacement<T, T>(CupertinoPageRoute(builder: (_) => page),)
      .then((value) => value as T);
}

Future navPushNamed<T extends Object>(BuildContext context, String routeName,
    {Object? arguments}) {
  FocusScope.of(context).requestFocus(FocusNode(),);
  return Navigator.of(context).pushNamed<T>(routeName, arguments: arguments);
}
