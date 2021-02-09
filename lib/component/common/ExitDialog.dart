import 'package:flutter/material.dart';

class ExitDialog extends StatelessWidget {
  const ExitDialog({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Quit App'),
      content: Text('Do you want to exit App?'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: Text(
            "Yes",
            style: TextStyle(fontSize: 16.0),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: Text(
            "No",
            style: TextStyle(fontSize: 16.0),
          ),
        ),
      ],
    );
  }
}
