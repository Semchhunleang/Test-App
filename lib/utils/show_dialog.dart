import 'package:flutter/material.dart';

Future<void> showResultDialog(BuildContext context, String message,
    {bool isDone = false, bool isBackToList = true, Function()? onTap}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // Prevent closing by tapping outside
    builder: (BuildContext context) {
      return AlertDialog(
        content: Text(message, textAlign: TextAlign.center),
        actions: <Widget>[
          TextButton(
            onPressed: onTap ??
                () async {
                  Navigator.pop(context, isDone);
                  if (isBackToList) {
                    Navigator.pop(context, isBackToList ? isDone : false);
                  }
                },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}
