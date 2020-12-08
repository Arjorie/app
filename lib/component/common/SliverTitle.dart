import 'package:app/component/decorators/TextStyle.dart';
import 'package:flutter/material.dart';

class SliverTitle extends StatelessWidget {
  final leftText;
  final rightText;

  const SliverTitle({
    Key key,
    this.leftText,
    this.rightText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> titleWidgets = [];
    if (leftText != null) {
      titleWidgets.add(
        Text(
          leftText,
          style: AppGlobalStyles.boldTitle,
        ),
      );
    }
    if (rightText != null) {
      titleWidgets.add(
        Text(
          rightText,
          style: AppGlobalStyles.primarySubtitle,
        ),
      );
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: titleWidgets,
          ),
        ),
      ],
    );
  }
}
