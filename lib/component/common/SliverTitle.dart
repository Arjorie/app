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
        Expanded(
          child: Text(
            leftText,
            style: AppGlobalStyles.boldTitle,
          ),
        ),
      );
    }
    if (rightText != null) {
      titleWidgets.add(
        Expanded(
          child: Text(
            rightText,
            style: AppGlobalStyles.primarySubtitle,
          ),
        ),
      );
    }
    return Container(
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: titleWidgets,
            ),
          ),
        ],
      ),
    );
  }
}
