import 'package:flutter/material.dart';
import 'package:app/pages/Page3.dart';
import 'package:app/pages/Home.dart';
import 'package:app/pages/Login.dart';
import 'package:app/pages/Splash.dart';
import 'package:app/pages/Order/SelectTable.dart';
import 'package:app/pages/Order/Products.dart';

import 'package:app/models/PageModel.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  final PageModel args = settings.arguments;

  switch (settings.name) {
    case '/':
      return SlideRightRoute(widget: Splash());
    case '/login':
      return SlideRightRoute(widget: Login(data: args));
      break;
    case '/home':
      return SlideRightRoute(widget: Home());
      break;
    case '/select-table':
      return SlideRightRoute(widget: SelectTable());
      break;
    case '/order-products':
      return SlideRightRoute(widget: OrderProduct());
      break;
    case '/page3':
      return SlideRightRoute(widget: Page3());
      break;
    default:
      return SlideRightRoute(widget: Page3());
      break;
  }
}

// Screen animation
class SlideRightRoute extends PageRouteBuilder {
  final Widget widget;
  SlideRightRoute({this.widget})
      : super(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return widget;
          },
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            var begin = Offset(1.0, 0.0);
            var end = Offset.zero;
            var curve = Curves.ease;
            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);
            return SlideTransition(
              // position: Tween<Offset>(
              //   begin: Offset(0.0, 1.0),
              //   end: Offset.zero,
              // ).animate(animation),
              position: offsetAnimation,
              child: child,
            );
          },
        );
}
