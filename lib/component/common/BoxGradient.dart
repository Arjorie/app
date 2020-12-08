import 'package:flutter/material.dart';

class BoxGradient extends StatelessWidget {
  final width;
  final height;
  final begin;
  final end;
  final colors;

  const BoxGradient({
    Key key,
    this.width,
    this.height,
    this.begin,
    this.end,
    this.colors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: begin,
          end: end,
          colors: colors,
          tileMode: TileMode.mirror,
        ),
      ),
    );
  }
}
