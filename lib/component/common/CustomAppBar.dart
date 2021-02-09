import 'package:app/component/common/ContainerWithBlurBackground.dart';
import 'package:app/component/common/MenuButton.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    Key key,
    @required this.title,
    this.backEnabled,
    this.dense,
  }) : super(key: key);

  final String title;
  final bool backEnabled;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: dense == true ? 0 : 120.0,
      floating: true,
      snap: true,
      centerTitle: dense == true ? true : false,
      leading: backEnabled == true ? null : MenuButton(),
      title: dense == true ? Text(title) : null,
      flexibleSpace: dense == true
          ? null
          : FlexibleSpaceBar(
              title: Text(title),
              background: ContainerWithBlurBackground(contentWidget: null),
            ),
    );
  }
}
