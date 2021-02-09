import 'package:flutter/material.dart';

class CustomSliverSpacer extends StatelessWidget {
  const CustomSliverSpacer({
    Key key,
    @required this.height,
  }) : super(key: key);

  final double height;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return SizedBox(
            height: height,
          );
        },
        childCount: 1,
      ),
    );
  }
}
