import 'package:app/config.dart';
import 'package:flutter/material.dart';

showComfirmDialog(BuildContext context, String title, String message,
    [Function onPressed]) {
  // set up the button
  Widget okButton = FlatButton(
    child: Text("Yes"),
    onPressed: () {
      Navigator.of(context).pop();
      if (onPressed != null) {
        onPressed(0);
      }
    },
  );
  // set up the button
  Widget cancelButton = FlatButton(
    child: Text("Cancel"),
    minWidth: 90,
    color: AppGlobalConfig.primaryColor,
    onPressed: () {
      Navigator.of(context).pop();
      if (onPressed != null) {
        onPressed(1);
      }
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(message),
    actions: [
      okButton,
      cancelButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
