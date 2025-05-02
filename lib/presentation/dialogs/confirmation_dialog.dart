import 'package:flutter/cupertino.dart';

class ConfirmationDialog {
  Future<bool> showConfirmationDialog(BuildContext context, String title, String message) async {
    final result = await showCupertinoDialog<bool>(
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
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text(
                "Ні",
                style: TextStyle(color: CupertinoColors.destructiveRed),
              ),
            ),
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text(
                "Так",
                style: TextStyle(color: CupertinoColors.activeBlue),
              ),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }
}