import 'dart:async';
import 'dart:convert';
import 'package:app/component/common/AlertDialog.dart';
import 'package:app/component/common/MButton.dart';
import 'package:app/component/decorators/TextStyle.dart';
import 'package:app/config.dart';
import 'package:app/helpers/Storage.dart';
import 'package:app/models/PageModel.dart';
import 'package:app/store/OrderStore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';

class OrderConfirmation extends StatefulWidget {
  @override
  _OrderConfirmationState createState() => _OrderConfirmationState();
}

class _OrderConfirmationState extends State<OrderConfirmation> {
  bool isLoading = true;
  bool canGoBack = false;
  String sendingOrderStatus = 'pending';
  String issuingBillStatus = '';
  String finalStatus = '';
  String orderId = '';
  BuildContext appContext;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 2000), () async {
      final orderStore = Provider.of<OrderStore>(appContext, listen: false);
      await getPaymentOptions(orderStore);
      sendOrders(orderStore);
    });
  }

  Future<bool> onBackPressed() {
    return canGoBack == true
        ? Future<bool>.value(true)
        : showDialog(
            context: context,
            builder: (context) => new AlertDialog(
              title: new Text('Ooops!'),
              content: new Text(
                  'Sorry but we are currently processing your order. Please wait until then, thank you!'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(
                    "Ok",
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ],
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    appContext = context;
    return WillPopScope(
      onWillPop: onBackPressed,
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: <Widget>[
                  CustomListAppBar(text: 'Processing Order'),
                  // CustomListTitle(leftText: 'Confirming Order'),
                  CustomListContent(
                    sendingOrderStatus: sendingOrderStatus,
                    issuingBillStatus: issuingBillStatus,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /* get Default Payment Option */
  Future getPaymentOptions(OrderStore orderStore) async {
    final LocalStorage localStorage = LocalStorage();
    final String token = await localStorage.getString('accessToken');
    final String authorizationHeader = 'Basic $token';

    final response = await http.get(
      '${AppGlobalConfig.server}/employee/v1/payment-options',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': authorizationHeader,
      },
    );
    setState(() {
      isLoading = false;
    });
    if (response.statusCode == 200) {
      final Map<String, dynamic> result = jsonDecode(response.body);
      final paymentOptions = result['payment_options'];
      setState(() {
        orderStore.paymentOptionId = paymentOptions[0]['payment_option_id'];
      });
    } else if (response.statusCode == 403) {
      showAlertDialog(appContext, 'Session Expired!', 'Please relogin!');
      Navigator.of(appContext).pushReplacementNamed(
        '/login',
        arguments:
            PageModel(title: 'Employee Login', message: 'This is a message'),
      );
    }
  }

  /* issue bill */
  Future issueBill(OrderStore orderStore) async {
    final LocalStorage localStorage = LocalStorage();
    final String token = await localStorage.getString('accessToken');
    final String authorizationHeader = 'Basic $token';

    final response = await http.post(
      '${AppGlobalConfig.server}/employee/v1/orders/$orderId/issue-bill',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': authorizationHeader,
      },
      body: jsonEncode(<String, dynamic>{
        'payment_option_id': orderStore.paymentOptionId,
      }),
    );
    setState(() {
      isLoading = false;
    });
    if (response.statusCode == 200) {
      final Map<String, dynamic> result = jsonDecode(response.body);
      orderStore.billId = result['bill_id'];
      setState(() {
        canGoBack = true;
        issuingBillStatus = 'success';
      });
    } else if (response.statusCode == 403) {
      showAlertDialog(appContext, 'Session Expired!', 'Please relogin!');
      Navigator.of(appContext).pushReplacementNamed(
        '/login',
        arguments:
            PageModel(title: 'Employee Login', message: 'This is a message'),
      );
    } else {
      setState(() {
        canGoBack = true;
        issuingBillStatus = 'failed';
      });
    }
  }

/* send orders */
  Future sendOrders(OrderStore orderStore) async {
    final LocalStorage localStorage = LocalStorage();
    final String token = await localStorage.getString('accessToken');
    final String authorizationHeader = 'Basic $token';

    // set up data to send
    final products = [];
    orderStore.orders
        .map(
          (product) => {
            products.add(
              <String, dynamic>{
                'product_id': product.productId,
                'quantity': product.orderCount,
              },
            )
          },
        )
        .toList();

    final response = await http.post(
      '${AppGlobalConfig.server}/employee/v1/orders',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': authorizationHeader,
      },
      body: jsonEncode(<String, dynamic>{
        'table_id': orderStore.tableId,
        'customer_count': orderStore.customerCount,
        'products': products
      }),
    );
    setState(() {
      isLoading = false;
    });
    print(response.body);
    if (response.statusCode == 200) {
      final Map<String, dynamic> result = jsonDecode(response.body);
      setState(() {
        orderId = result['order_id'];
        sendingOrderStatus = 'success';
        issuingBillStatus = 'pending';
      });

      issueBill(orderStore);
    } else if (response.statusCode == 403) {
      showAlertDialog(appContext, 'Session Expired!', 'Please relogin!');
      Navigator.of(appContext).pushReplacementNamed(
        '/login',
        arguments:
            PageModel(title: 'Employee Login', message: 'This is a message'),
      );
    } else {
      setState(() {
        canGoBack = true;
        sendingOrderStatus = 'failed';
        issuingBillStatus = 'failed';
      });
    }
  }
}

// Custom List View Content
class CustomListContent extends StatelessWidget {
  final sendingOrderStatus;
  final issuingBillStatus;

  const CustomListContent({
    Key key,
    this.sendingOrderStatus,
    this.issuingBillStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String sendingOrderStatusText = '';
    if (sendingOrderStatus == 'pending')
      sendingOrderStatusText = 'Sending Orders...';
    else if (sendingOrderStatus == 'success')
      sendingOrderStatusText = 'Order Sent!';
    else if (sendingOrderStatus == 'failed')
      sendingOrderStatusText = 'Order sending failed!';

    String sendingOrderStatusDetailsText = '';
    if (sendingOrderStatus == 'pending')
      sendingOrderStatusDetailsText =
          'Please wait while we are processing your orders. Thank you.';
    else if (sendingOrderStatus == 'success')
      sendingOrderStatusDetailsText =
          'Your order has been sent and received. Please wait while we prepare it for you.';
    else if (sendingOrderStatus == 'failed')
      sendingOrderStatusDetailsText =
          'Order sending failed! Please make sure there are no duplicate orders or out of stock orders.';

    String issuingBillStatusText = 'Issue Bill';
    if (issuingBillStatus == 'pending')
      issuingBillStatusText = 'Requesting for bill...';
    else if (issuingBillStatus == 'success')
      issuingBillStatusText = 'Bill issued!';
    else if (issuingBillStatus == 'failed')
      issuingBillStatusText = 'Request for bill failed!';

    String issuingBillStatusDetailsText =
        'We will send a request for bill as soon as your orders are received.';
    if (issuingBillStatus == 'pending')
      issuingBillStatusDetailsText =
          'Please wait while we are computing your orders.';
    else if (issuingBillStatus == 'success')
      issuingBillStatusDetailsText =
          'Order computed and ready for payment! You can pay with our supported online payments.';
    else if (issuingBillStatus == 'failed')
      issuingBillStatusDetailsText = 'Bill failed to be issued!';

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          final OrderStore orderStore =
              Provider.of<OrderStore>(context, listen: false);
          return Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                TimelineCard(
                  isFirst: true,
                  statusText: sendingOrderStatusText,
                  detailText: sendingOrderStatusDetailsText,
                  status: sendingOrderStatus,
                ),
                TimelineCard(
                  isLast: true,
                  statusText: issuingBillStatusText,
                  detailText: issuingBillStatusDetailsText,
                  status: sendingOrderStatus == 'success'
                      ? issuingBillStatus
                      : 'failed',
                ),
                Container(
                  child: issuingBillStatus == 'success'
                      ? Column(
                          children: [
                            SizedBox(height: 20),
                            Text(
                              'You can call the waiter anytime for the payment. Please wait while we prepare your order.',
                              textAlign: TextAlign.center,
                              style: AppGlobalStyles.boldParagraph,
                            ),
                            SizedBox(height: 20),
                          ],
                        )
                      : null,
                ),
                Container(
                  child: issuingBillStatus == 'success'
                      ? Row(
                          children: [
                            MButton(
                              label: 'Pay Later',
                              onPressed: () {
                                orderStore.resetOrder();
                                Navigator.of(context)
                                    .popUntil(ModalRoute.withName('/home'));
                              },
                            ),
                            MButton(
                              label: 'Pay Now',
                              onPressed: () {
                                Navigator.of(context).pushNamed(
                                  '/payment',
                                  arguments: PageModel(
                                      title: 'Payment',
                                      message: orderStore.billId),
                                );
                              },
                            ),
                          ],
                        )
                      : null,
                ),
                Container(
                  child: issuingBillStatus == 'failed'
                      ? Column(
                          children: [
                            SizedBox(height: 20),
                            Text(
                              'Some of your orders are now out of stock! Please check and choose different items if you want to.',
                              textAlign: TextAlign.center,
                              style: AppGlobalStyles.boldParagraph,
                            ),
                            SizedBox(height: 20),
                          ],
                        )
                      : null,
                ),
                Container(
                  child: issuingBillStatus == 'failed'
                      ? Row(
                          children: [
                            MButton(
                              backgroundColor: Colors.red,
                              label: 'Order Failed!',
                              onPressed: () {
                                Navigator.of(context).popUntil(
                                    ModalRoute.withName('/order-products'));
                              },
                            ),
                          ],
                        )
                      : null,
                ),
              ],
            ),
          );
        },
        childCount: 1,
      ),
    );
  }
}

// Timeline Card
class TimelineCard extends StatelessWidget {
  final String statusText;
  final String status;
  final bool isFirst;
  final bool isLast;
  final String detailText;
  const TimelineCard({
    Key key,
    this.statusText,
    this.status,
    this.isFirst,
    this.isLast,
    this.detailText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget indicator;
    if (status == 'pending' || status == '')
      indicator = Container(
        width: 30,
        height: 30,
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: status == '' ? Colors.grey : AppGlobalConfig.primaryColor,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: CircularProgressIndicator(
            strokeWidth: 1,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      );
    else
      indicator = null;
    return TimelineTile(
      lineXY: 0.3,
      indicatorStyle: IndicatorStyle(
          width: 30,
          height: 30,
          color: status == 'failed' ? Colors.red : AppGlobalConfig.primaryColor,
          indicatorXY: 0.3,
          iconStyle: status == 'success'
              ? IconStyle(
                  color: Colors.white,
                  iconData: Icons.check,
                )
              : (status == 'failed'
                  ? IconStyle(
                      color: Colors.white,
                      iconData: Icons.close,
                    )
                  : null),
          indicator: indicator),
      isFirst: isFirst ?? false,
      isLast: isLast ?? false,
      endChild: Container(
        constraints: BoxConstraints(
          minWidth: double.infinity,
          maxHeight: 220,
        ),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(statusText, style: AppGlobalStyles.boldHeading),
                  Text(detailText, style: AppGlobalStyles.subtitle),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Custom List View Appbar
class CustomListAppBar extends StatelessWidget {
  final text;
  const CustomListAppBar({Key key, @required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      // expandedHeight: 120.0,
      centerTitle: true,
      floating: true,
      title: Text(text),
      snap: true,
      // flexibleSpace: FlexibleSpaceBar(
      // title: Text(text),
      // background: ContainerWithBlurBackground(contentWidget: null),
      // ),
    );
  }
}
