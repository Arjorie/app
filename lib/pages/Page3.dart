import 'package:app/config.dart';
import 'package:flutter/material.dart';

class Page3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(globalConfig.account.username),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('Go To Launch screen'),
          onPressed: () {
            // Navigator.pop(context);
            globalConfig.account.username = 'yo';
            // Navigator.pushNamed(context, '/');
          },
        ),
      ),
    );
  }
}
