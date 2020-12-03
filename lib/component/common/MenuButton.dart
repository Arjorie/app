import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MenuButton extends StatelessWidget {
  const MenuButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: SvgPicture.asset(
        'assets/ic_menu.svg',
        width: 30,
        height: 30,
      ),
      onPressed: () => Scaffold.of(context).openDrawer(),
    );
  }
}
