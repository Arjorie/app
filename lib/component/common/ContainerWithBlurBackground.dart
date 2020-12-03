import 'dart:ui';

import 'package:flutter/material.dart';

class ContainerWithBlurBackground extends StatelessWidget {
  final Widget contentWidget;
  const ContainerWithBlurBackground({
    Key key,
    @required this.contentWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.65), BlendMode.overlay),
          image: AssetImage("assets/background.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: this.contentWidget),
    );
  }
}
