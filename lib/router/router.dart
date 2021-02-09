import 'package:app/pages/Payment/CashPayment.dart';
import 'package:app/pages/Payment/OnlinePayment.dart';
import 'package:app/pages/Payment/PaymentOptionsPage.dart';
import 'package:app/pages/Protected/CancelledOrders.dart';
import 'package:app/pages/Protected/CompleteOrders.dart';
import 'package:app/pages/Protected/OrderSummary.dart';
import 'package:app/pages/Protected/PaidOrders.dart';
import 'package:app/pages/Protected/PendingOrders.dart';
import 'package:app/pages/Protected/ServedOrders.dart';
import 'package:app/pages/Protected/ServingOrders.dart';
import 'package:flutter/material.dart';
import 'package:app/pages/Home.dart';
import 'package:app/pages/Login.dart';
import 'package:app/pages/Splash.dart';
import 'package:app/pages/Order/SelectTable.dart';
import 'package:app/pages/Order/OrderProducts.dart';
import 'package:app/pages/Order/ViewOrders.dart';
import 'package:app/pages/Order/PaymentOptions.dart';
import 'package:app/pages/Order/OrderConfirmation.dart';

import 'package:app/models/PageModel.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  final PageModel args = settings.arguments;

  switch (settings.name) {
    case '/':
      return SlideRightRoute(widget: Splash(), name: '/');
    case '/login':
      return SlideRightRoute(widget: Login(data: args), name: '/login');
      break;
    case '/home':
      return SlideRightRoute(widget: Home(), name: '/home');
      break;
    case '/select-table':
      return SlideRightRoute(widget: SelectTable(), name: '/select-table');
      break;
    case '/order-products':
      return SlideRightRoute(widget: OrderProducts(), name: '/order-products');
      break;
    case '/view-orders':
      return SlideRightRoute(widget: ViewOrders(), name: '/view-orders');
      break;
    case '/payment-options':
      return SlideRightRoute(
          widget: PaymentOptions(), name: '/payment-options');
      break;
    case '/order-confirmation':
      return SlideRightRoute(
          widget: OrderConfirmation(), name: '/order-confirmation');
      break;
    case '/pending-orders':
      return SlideRightRoute(widget: PendingOrders(), name: '/pending-orders');
      break;
    case '/cancelled-orders':
      return SlideRightRoute(
          widget: CancelledOrders(), name: '/cancelled-orders');
      break;
    case '/serving-orders':
      return SlideRightRoute(widget: ServingOrders(), name: '/serving-orders');
      break;
    case '/served-orders':
      return SlideRightRoute(widget: ServedOrders(), name: '/served-orders');
      break;
    case '/complete-orders':
      return SlideRightRoute(
          widget: CompleteOrders(), name: '/complete-orders');
      break;
    case '/paid-orders':
      return SlideRightRoute(widget: PaidOrders(), name: '/paid-orders');
      break;
    case '/payment':
      return SlideRightRoute(
          widget: PaymentOptionsPage(data: args), name: '/payment');
      break;
    case '/cash-payment':
      return SlideRightRoute(widget: CashPaymentPage(), name: '/cash-payment');
      break;
    case '/online-payment':
      return SlideRightRoute(
          widget: OnlinePaymentPage(), name: '/online-payment');
      break;
    case '/order-summary':
      return SlideRightRoute(
          widget: OrderSummary(data: args), name: '/order-summary');
      break;
    default:
      return SlideRightRoute(widget: Login(data: args));
      break;
  }
}

// Screen animation
class SlideRightRoute extends PageRouteBuilder {
  final Widget widget;
  final String name;
  SlideRightRoute({this.widget, this.name})
      : super(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return widget;
          },
          settings: RouteSettings(name: name),
          transitionDuration: Duration(milliseconds: 400),
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            var begin = Offset(1.0, 0.0);
            var end = Offset.zero;
            var curve = Curves.ease;
            var tween =
                // Tween(begin: begin, end: end);
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
