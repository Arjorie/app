import 'dart:ui';

import 'package:flutter/material.dart';

class IconWithBadge extends StatefulWidget {
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
  _IconWithBadgeState createState() => _IconWithBadgeState();
}

class _IconWithBadgeState extends State<IconWithBadge> {
  @override
  Widget build(BuildContext context) {
    final badgeTextfontSize = widget.fontSize != null ? widget.fontSize : 14.0;
    final finalBadgeCount = widget.badgeCount != null ? widget.badgeCount : 0;
    final badgeColor = widget.color != null ? widget.color : Colors.red;
    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        widget.icon,
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
