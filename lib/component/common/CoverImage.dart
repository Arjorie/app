import 'dart:ui';
import 'package:flutter/material.dart';

class CoverImage extends StatelessWidget {
  final imgSrc;
  final height;

  const CoverImage({
    Key key,
    this.imgSrc,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      constraints: BoxConstraints(minHeight: 150),
      alignment: Alignment.bottomCenter,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        image: DecorationImage(
          colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.65), BlendMode.overlay),
          image: NetworkImage(imgSrc),
          fit: BoxFit.cover,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
      ),
    );
  }
}
