import 'dart:ui';

import 'package:flutter/material.dart';

class IconWithBadge extends StatelessWidget {
  final int badgeCount;
  final Widget icon;
  final Color color;
  final double fontSize;
  const IconWithBadge({
    Key key,
    this.badgeCount,
    @required this.icon,
    this.color,
    this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final badgeTextfontSize = fontSize != null ? fontSize : 14.0;
    final finalBadgeCount = badgeCount != null ? badgeCount : 0;
    final badgeColor = color != null ? color : Colors.red;
    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        icon,
        Positioned(
          right: -(badgeTextfontSize * 0.5),
          top: -(badgeTextfontSize * 0.5),
          child: Container(
            padding: EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: finalBadgeCount == 0 ? Colors.transparent : badgeColor,
              borderRadius: BorderRadius.circular(8),
            ),
            constraints: BoxConstraints(
              minWidth: badgeTextfontSize,
              minHeight: badgeTextfontSize,
            ),
            child: finalBadgeCount == 0
                ? null
                : Text(
                    finalBadgeCount.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: badgeTextfontSize,
                    ),
                    textAlign: TextAlign.center,
                  ),
          ),
        )
      ],
    );
  }
}
