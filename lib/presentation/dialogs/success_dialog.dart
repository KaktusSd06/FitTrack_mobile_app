import 'package:flutter/cupertino.dart';

class SuccessDialog {
  void showSuccessDialog(BuildContext context, String title, String message) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17.0,
            ),
          ),
          content: Text(
            message,
            style: const TextStyle(fontSize: 13.0),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "Закрити",
                style: TextStyle(color: CupertinoColors.activeBlue),
              ),
            ),
          ],
        );
      },
    );
  }
}