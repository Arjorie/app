import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final double width;
  final double height;
  const Logo({Key key, this.width, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        image: DecorationImage(
          image: AssetImage('assets/logo.png'),
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
