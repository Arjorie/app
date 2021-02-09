import 'dart:async';
import 'dart:convert';

import 'package:app/component/common/AlertDialog.dart';
import 'package:app/component/common/CustomAppBar.dart';
import 'package:app/component/common/CustomListTitle.dart';
import 'package:app/component/common/CustomSliverSpacer.dart';
import 'package:app/component/common/DashboardCard.dart';
import 'package:app/component/common/Drawer.dart';
import 'package:app/component/common/ExitDialog.dart';
import 'package:app/component/common/OrderFAB.dart';
import 'package:app/config.dart';
import 'package:app/helpers/Storage.dart';
import 'package:app/models/OrderModel.dart';
import 'package:app/models/PageModel.dart';
import 'package:app/models/ResponseModel.dart';
import 'package:flutter/cupertino.dart';
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
  final LocalStorage localStorage = LocalStorage();
  Timer timer;
  BuildContext appContext;
  List<OrderModel> pendingOrders = [];
  List<OrderModel> servingOrders = [];
  List<OrderModel> servedOrders = [];
  List<OrderModel> cancelledOrders = [];
  List<OrderModel> completedOrders = [];
  List<OrderModel> paidOrders = [];

  // ignore: slash_for_doc_comments
  /**
   * Page Life Cycle
   */

  /* Init State - on create state of this page */
  @override
  void initState() {
    super.initState();
    final self = this;
    self.initRecords();
    timer = Timer.periodic(Duration(seconds: 2), (Timer _) {
      self.initRecords();
    });
  }

  /* Destroy State - on dispose state of this page */
  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  // ignore: slash_for_doc_comments
  /**
   * Page Methods
   */
  void initRecords() {
    this.getPendingOrders();
    this.getCancelledOrders();
    this.getServingOrders();
    this.getServedOrders();
    this.getCompletedOrders();
    this.getPaidOrders();
  }

  /* API Request */
  Future<ResponseModel> requestRecord(route) async {
    final String token = await localStorage.getString('accessToken');
    final String authorizationHeader = 'Basic $token';
    final response = await http.get(
      '${AppGlobalConfig.server}/employee/v1/$route',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': authorizationHeader,
      },
    );
    ResponseModel tmpOrders;
    if (response.statusCode == 200) {
      final Map<String, dynamic> result = jsonDecode(response.body);
      tmpOrders = ResponseModel.fromJson(result['orders']);
    } else if (response.statusCode == 403) {
      showAlertDialog(appContext, 'Session Expired!', 'Please relogin!');
      Navigator.of(appContext).pushReplacementNamed(
        '/login',
        arguments:
            PageModel(title: 'Employee Login', message: 'This is a message'),
      );
    }
    return tmpOrders;
  }

  /* Get pending orders count by employee */
  void getPendingOrders() async {
    final String route = '/orders/?status=PENDING&today=true';
    ResponseModel tmpOrders = await this.requestRecord(route);
    setState(() {
      pendingOrders = tmpOrders.rows != null ? tmpOrders.rows : [];
    });
  }

  /* Get cancelled orders count by employee */
  void getCancelledOrders() async {
    final String route = '/orders?status=CANCELLED&today=true';
    ResponseModel tmpOrders = await this.requestRecord(route);
    setState(() {
      cancelledOrders = tmpOrders.rows != null ? tmpOrders.rows : [];
    });
  }

  /* Get serving orders count by employee */
  void getServingOrders() async {
    final String route = '/orders?status=SERVING&today=true';
    ResponseModel tmpOrders = await this.requestRecord(route);
    setState(() {
      servingOrders = tmpOrders.rows != null ? tmpOrders.rows : [];
    });
  }

  /* Get served orders count by employee */
  void getServedOrders() async {
    final String route = '/orders?status=SERVED&today=true';
    ResponseModel tmpOrders = await this.requestRecord(route);
    setState(() {
      servedOrders = tmpOrders.rows != null ? tmpOrders.rows : [];
    });
  }

  /* Get completed orders count by employee */
  void getCompletedOrders() async {
    final String route = '/orders?status=COMPLETE&today=true';
    ResponseModel tmpOrders = await this.requestRecord(route);
    setState(() {
      completedOrders = tmpOrders.rows != null ? tmpOrders.rows : [];
    });
  }

  /* Get paid orders count by employee */
  void getPaidOrders() async {
    final String route = '/orders?bill_status=PAID&today=true';
    ResponseModel tmpOrders = await this.requestRecord(route);
    setState(() {
      paidOrders = tmpOrders.rows != null ? tmpOrders.rows : [];
    });
  }

  /* On back button press */
  Future<bool> onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => ExitDialog(),
        ) ??
        false;
  }

  // ignore: slash_for_doc_comments
  /**
   * Page UI - On Render
   */
  @override
  Widget build(BuildContext context) {
    appContext = context;
    return WillPopScope(
        onWillPop: onBackPressed,
        child: Scaffold(
          drawer: HomeDrawer(),
          body: CustomScrollView(
            slivers: <Widget>[
              CustomAppBar(title: 'Dashboard'),
              CustomListTitle(text: 'Today\'s Orders Overview'),
              SliverGrid.count(
                crossAxisCount: 2,
                children: [
                  OverviewCard(
                    onTap: () =>
                        {Navigator.of(context).pushNamed('/pending-orders')},
                    color: Colors.orange,
                    icon: 'assets/svg/clipboard-clock-outline.svg',
                    title: 'Pending Orders',
                    text: '${pendingOrders.length}',
                  ),
                  OverviewCard(
                    onTap: () =>
                        {Navigator.of(context).pushNamed('/cancelled-orders')},
                    color: Colors.red,
                    icon: 'assets/svg/clipboard-remove-outline.svg',
                    title: 'Cancelled Orders',
                    text: '${cancelledOrders.length}',
                  ),
                  OverviewCard(
                    onTap: () =>
                        {Navigator.of(context).pushNamed('/serving-orders')},
                    color: Colors.purple,
                    icon: 'assets/svg/food-on-deliver.svg',
                    title: 'Serving Orders',
                    text: '${servingOrders.length}',
                  ),
                  OverviewCard(
                    onTap: () =>
                        {Navigator.of(context).pushNamed('/served-orders')},
                    color: Colors.blue,
                    icon: 'assets/svg/food-delivered.svg',
                    title: 'Served Orders',
                    text: '${servedOrders.length}',
                  ),
                  OverviewCard(
                    onTap: () =>
                        {Navigator.of(context).pushNamed('/paid-orders')},
                    color: Colors.green,
                    icon: 'assets/svg/cash-check.svg',
                    title: 'Paid Orders',
                    text: '${paidOrders.length}',
                  ),
                  OverviewCard(
                    onTap: () =>
                        {Navigator.of(context).pushNamed('/complete-orders')},
                    color: Colors.green,
                    icon: 'assets/svg/clipboard-check-outline.svg',
                    title: 'Completed Orders',
                    text: '${completedOrders.length}',
                  ),
                ],
              ),
              CustomSliverSpacer(
                height: 80,
              ),
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.miniEndFloat,
          floatingActionButton: OrderFAB(),
        ));
  }
}
