import 'dart:async';
import 'dart:convert';

import 'package:app/component/common/AlertDialog.dart';
import 'package:app/component/common/ContainerWithBlurBackground.dart';
import 'package:app/component/common/MenuButton.dart';
import 'package:app/component/common/ProductCard.dart';
import 'package:app/component/common/SliverTitle.dart';
import 'package:app/component/decorators/TextStyle.dart';
import 'package:app/config.dart';
import 'package:app/helpers/Storage.dart';
import 'package:app/models/PageModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  Home({
    Key key,
  }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<int> top = [];
  List<int> bottom = [0];

  bool isLoading = true;
  BuildContext appContext;
  List<dynamic> orders = [];

  // initState()
  // - on create/init hook/method of this class
  @override
  void initState() {
    super.initState();

    Timer(Duration(milliseconds: 200), () async => {this.getOrders()});
  }

  Future<bool> onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Quit App'),
            content: Text('Do you want to exit App?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text(
                  "Yes",
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text(
                  "No",
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  /* get Orders by employee */
  Future getOrders() async {
    final LocalStorage localStorage = LocalStorage();
    final String token = await localStorage.getString('accessToken');
    final String authorizationHeader = 'Basic $token';

    final response = await http.get(
      '${AppGlobalConfig.server}/employee/v1/orders/pending',
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
      setState(() {
        orders = result['orders'];
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

  @override
  Widget build(BuildContext context) {
    appContext = context;
    return WillPopScope(
        onWillPop: onBackPressed,
        child: Scaffold(
          drawer: HomeDrawer(),
          body: CustomScrollView(
            slivers: <Widget>[
              CustomAppBar(),
              CustomListTitle(orders: orders),
              CustomListContent(
                orders: orders,
                isLoading: isLoading,
                getOrders: getOrders,
              ),
              CustomListSpacer(),
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.miniEndFloat,
          floatingActionButton: FAB(),
        ));
  }
}

class CustomListSpacer extends StatelessWidget {
  const CustomListSpacer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return SizedBox(height: 60);
        },
        childCount: 1,
      ),
    );
  }
}

class FAB extends StatelessWidget {
  const FAB({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      label: Text(
        'Take Order',
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        Navigator.pushNamed(context, '/select-table');
      },
    );
  }
}

class CustomListContent extends StatelessWidget {
  const CustomListContent({
    Key key,
    @required this.orders,
    @required this.isLoading,
    @required this.getOrders,
  }) : super(key: key);

  final List orders;
  final bool isLoading;
  final Function getOrders;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          if (isLoading) {
            return Container(
              height: MediaQuery.of(context).size.height - 200,
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor),
                ),
              ),
            );
          } else {
            final order = orders[index];
            final tableSequence = order['table']['sequence'];
            final totalPrice = order['total_price'];
            final cardHeight = 150.0;
            return PendingOrderCard(
              cardHeight: cardHeight,
              tableSequence: tableSequence,
              totalPrice: totalPrice,
              order: order,
              getOrders: getOrders,
            );
          }
        },
        childCount: isLoading == true ? 1 : orders.length,
      ),
    );
  }
}

class CustomListTitle extends StatelessWidget {
  const CustomListTitle({
    Key key,
    @required this.orders,
  }) : super(key: key);

  final List orders;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return SliverTitle(
            leftText: 'Pending Orders (${orders.length})',
          );
        },
        childCount: 1,
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 120.0,
      floating: true,
      snap: true,
      leading: MenuButton(),
      flexibleSpace: FlexibleSpaceBar(
        title: Text('Dashboard'),
        background: ContainerWithBlurBackground(contentWidget: null),
      ),
    );
  }
}

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LocalStorage localStorage = LocalStorage();

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height: 150,
            child: DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back ${AppGlobalConfig.account.firstName}!',
                    style: TextStyle(
                      fontSize: AppGlobalStyles.headingFontSize,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '${AppGlobalConfig.account.username}',
                    style: TextStyle(
                      fontSize: AppGlobalStyles.subtitleFontSize,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.65), BlendMode.overlay),
                  image: AssetImage("assets/background.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
            ),
            child: Text(
              'Orders',
              style: AppGlobalStyles.paragraph,
            ),
          ),
          ListTile(
            leading: SvgPicture.asset(
              'assets/svg/clipboard-clock-outline.svg',
              color: Colors.black.withOpacity(0.6),
              width: 30,
              height: 30,
            ),
            title: Text(
              'Pending Orders',
              style: AppGlobalStyles.subtitle,
            ),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            leading: SvgPicture.asset(
              'assets/svg/food-delivered.svg',
              color: Colors.black.withOpacity(0.6),
              width: 30,
              height: 30,
            ),
            title: Text(
              'Delivered Orders',
              style: AppGlobalStyles.subtitle,
            ),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            leading: SvgPicture.asset(
              'assets/svg/food-on-deliver.svg',
              color: Colors.black.withOpacity(0.6),
              width: 30,
              height: 30,
            ),
            title: Text(
              'On Deliver Orders',
              style: AppGlobalStyles.subtitle,
            ),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            leading: SvgPicture.asset(
              'assets/svg/cash-check.svg',
              color: Colors.black.withOpacity(0.6),
              width: 30,
              height: 30,
            ),
            title: Text(
              'Paid Orders',
              style: AppGlobalStyles.subtitle,
            ),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            leading: SvgPicture.asset(
              'assets/svg/clipboard-remove-outline.svg',
              color: Colors.black.withOpacity(0.6),
              width: 30,
              height: 30,
            ),
            title: Text(
              'Cancelled Orders',
              style: AppGlobalStyles.subtitle,
            ),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            leading: SvgPicture.asset(
              'assets/svg/clipboard-check-outline.svg',
              color: Colors.black.withOpacity(0.6),
              width: 30,
              height: 30,
            ),
            title: Text(
              'Completed Orders',
              style: AppGlobalStyles.subtitle,
            ),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          Divider(),
          ListTile(
            leading: SvgPicture.asset(
              'assets/svg/logout.svg',
              color: Colors.black.withOpacity(0.6),
              width: 30,
              height: 30,
            ),
            title: Text(
              'Sign Out',
              style: AppGlobalStyles.subtitle,
            ),
            onTap: () {
              return showDialog(
                    context: context,
                    builder: (context) => new AlertDialog(
                      title: new Text('Sign out'),
                      content: new Text('Are you sure?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            localStorage.setString('accessToken', '');
                            Navigator.of(context).pushReplacementNamed(
                              '/login',
                              arguments: PageModel(
                                  title: 'Employee Login',
                                  message: 'This is a message'),
                            );
                          },
                          child: Text(
                            "Yes",
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          child: Text(
                            "No",
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                      ],
                    ),
                  ) ??
                  false;
            },
          ),
        ],
      ),
    );
  }
}

class PendingOrderCard extends StatelessWidget {
  const PendingOrderCard({
    Key key,
    @required this.cardHeight,
    @required this.tableSequence,
    @required this.totalPrice,
    @required this.order,
    @required this.getOrders,
  }) : super(key: key);

  final double cardHeight;
  final tableSequence;
  final totalPrice;
  final order;
  final Function getOrders;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: cardHeight,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 8.0,
          right: 8.0,
          bottom: 8.0,
        ),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                flex: 5,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: SizedBox(width: 20),
                    ),
                    Expanded(
                      flex: 3,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          SvgPicture.asset(
                            'assets/svg/table-chair-colored.svg',
                            width: 50,
                            height: 50,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: SizedBox(width: 20),
                    ),
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Table: #$tableSequence',
                                    style: AppGlobalStyles.boldTitle,
                                  ),
                                  Text(
                                    'Price: ${pesoFormat.format(totalPrice)}',
                                    style: AppGlobalStyles.orangeSubtitle,
                                  ),
                                  Text(
                                    'Total Items: ${order['items'].length}',
                                    style: AppGlobalStyles.subtitle,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Divider(),
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CancelButton(order: order, onSuccess: getOrders),
                    const SizedBox(width: 8),
                    DeliverButton(order: order, onSuccess: getOrders),
                    const SizedBox(width: 8),
                    TextButton(
                      child: Text('PAYMENT',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                          )),
                      onPressed: () {/* ... */},
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DeliverButton extends StatefulWidget {
  final order;
  final Function onSuccess;
  const DeliverButton({
    Key key,
    this.order,
    this.onSuccess,
  }) : super(key: key);

  @override
  _DeliverButtonState createState() => _DeliverButtonState();
}

class _DeliverButtonState extends State<DeliverButton> {
  BuildContext buttonContext;

  Future deliverOrder(dynamic order, Function onSuccess) async {
    final LocalStorage localStorage = LocalStorage();
    final String token = await localStorage.getString('accessToken');
    final String authorizationHeader = 'Basic $token';

    // show a loading dialog
    showDialog(
      context: buttonContext,
      builder: (buttonContext) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: Text('Please wait...'),
          content: Container(
            height: 80,
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(buttonContext).primaryColor),
              ),
            ),
          ),
        ),
      ),
    );

    // send request
    final response = await http.post(
      '${AppGlobalConfig.server}/employee/v1/orders/${order['order_id']}/deliver',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': authorizationHeader,
      },
    );

    // hide loading dialog
    Navigator.of(buttonContext).pop(false);

    if (response.statusCode == 200) {
      showAlertDialog(buttonContext, 'Success!', 'Order is now on deliver!');
      onSuccess();
    } else if (response.statusCode == 403) {
      showAlertDialog(buttonContext, 'Session Expired!', 'Please relogin!');
      Navigator.of(buttonContext).pushReplacementNamed(
        '/login',
        arguments:
            PageModel(title: 'Employee Login', message: 'This is a message'),
      );
    } else {
      showAlertDialog(buttonContext, 'Ooops!', 'Something went wrong!');
    }
  }

  @override
  Widget build(BuildContext context) {
    buttonContext = context;
    return TextButton(
      child: Text('DELIVER',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          )),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Change order status'),
            content: Text('Are you sure to mark this order as ON_DELIVER?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                  deliverOrder(widget.order, widget.onSuccess);
                },
                child: Text(
                  "Yes",
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              FlatButton(
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text(
                  "No",
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CancelButton extends StatefulWidget {
  final order;
  final Function onSuccess;
  const CancelButton({
    Key key,
    this.order,
    this.onSuccess,
  }) : super(key: key);

  @override
  _CancelButtonState createState() => _CancelButtonState();
}

class _CancelButtonState extends State<CancelButton> {
  BuildContext buttonContext;

  Future cancelOrder(dynamic order, Function onSuccess) async {
    final LocalStorage localStorage = LocalStorage();
    final String token = await localStorage.getString('accessToken');
    final String authorizationHeader = 'Basic $token';

    // show a loading dialog
    showDialog(
      context: buttonContext,
      builder: (buttonContext) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: Text('Please wait...'),
          content: Container(
            height: 80,
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(buttonContext).primaryColor),
              ),
            ),
          ),
        ),
      ),
    );

    // send request
    final response = await http.post(
      '${AppGlobalConfig.server}/employee/v1/orders/${order['order_id']}/cancel',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': authorizationHeader,
      },
    );

    // hide loading dialog
    Navigator.of(buttonContext).pop(false);

    if (response.statusCode == 200) {
      showAlertDialog(buttonContext, 'Success!', 'Order is cancelled!');
      onSuccess();
    } else if (response.statusCode == 403) {
      showAlertDialog(buttonContext, 'Session Expired!', 'Please relogin!');
      Navigator.of(buttonContext).pushReplacementNamed(
        '/login',
        arguments:
            PageModel(title: 'Employee Login', message: 'This is a message'),
      );
    } else {
      showAlertDialog(buttonContext, 'Ooops!', 'Something went wrong!');
    }
  }

  @override
  Widget build(BuildContext context) {
    buttonContext = context;
    return TextButton(
      child: Text('CANCEL',
          style: TextStyle(
            color: Colors.red,
          )),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Change order status'),
            content: Text('Are you sure to cancel this order?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                  cancelOrder(widget.order, widget.onSuccess);
                },
                child: Text(
                  "Yes",
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              FlatButton(
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text(
                  "No",
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
