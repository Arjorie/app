import 'package:flutter/material.dart';

class OrderFAB extends StatelessWidget {
  const OrderFAB({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      label: Text(
        'Take Order',
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        Navigator.pushNamed(context, '/select-table');
      },
    );
  }
}
