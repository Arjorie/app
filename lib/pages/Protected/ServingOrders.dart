import 'dart:async';
import 'dart:convert';

import 'package:app/component/common/AlertDialog.dart';
import 'package:app/component/common/ConfirmDialog.dart';
import 'package:app/component/common/CustomAppBar.dart';
import 'package:app/component/common/CustomListTitle.dart';
import 'package:app/component/common/OrderCard.dart';
import 'package:app/config.dart';
import 'package:app/helpers/Storage.dart';
import 'package:app/models/BillModel.dart';
import 'package:app/models/OrderModel.dart';
import 'package:app/models/PageModel.dart';
import 'package:app/models/ResponseModel.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ServingOrders extends StatefulWidget {
  @override
  _ServingOrdersState createState() => _ServingOrdersState();
}

class _ServingOrdersState extends State<ServingOrders> {
  final LocalStorage localStorage = LocalStorage();
  bool isLoading = true;
  BuildContext appContext;
  List<OrderModel> servingOrders = [];
  Timer timer;

  // ignore: slash_for_doc_comments
  /**
   * Page Life Cycle
   */

  /* Init State - on create state of this page */
  @override
  void initState() {
    super.initState();
    final self = this;
    self.getServingOrders();
    timer = Timer.periodic(Duration(seconds: 2), (Timer _) {
      self.getServingOrders();
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

  /* API Request */
  Future<ResponseModel> requestRecord(route) async {
    final token = await localStorage.getString('accessToken');
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

  /* Get serving orders count by employee */
  void getServingOrders() async {
    final String route = '/orders/?status=SERVING&today=true';
    ResponseModel tmpOrders = await this.requestRecord(route);
    setState(() {
      isLoading = false;
      servingOrders = tmpOrders.rows != null ? tmpOrders.rows : [];
    });
  }

  /* On Serve Order */
  void onServe(id) async {
    //shows a confirm dialog
    showComfirmDialog(
      context,
      'Confirm',
      'Order is now on the table of the customer?',
      (index) {
        // reset order list
        if (index == 0) {
          this.serveOrder(id);
        }
      },
    );
  }

  /* Send a Serve order request */
  serveOrder(id) async {
    final token = await localStorage.getString('accessToken');
    final String authorizationHeader = 'Basic $token';
    setState(() {
      isLoading = true;
    });
    final response = await http.post(
      '${AppGlobalConfig.server}/employee/v1/orders/$id/served',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': authorizationHeader,
      },
    );
    setState(() {
      isLoading = false;
    });
    if (response.statusCode == 200) {
      showAlertDialog(context, 'Great!', 'Order was served!');
      this.getServingOrders();
    } else if (response.statusCode == 403) {
      showAlertDialog(appContext, 'Session Expired!', 'Please relogin!');
      Navigator.of(appContext).pushReplacementNamed(
        '/login',
        arguments:
            PageModel(title: 'Employee Login', message: 'This is a message'),
      );
    }
  }

  // ignore: slash_for_doc_comments
  /**
   * Page UI - on Render
   */
  @override
  Widget build(BuildContext context) {
    appContext = context;
    return WillPopScope(
      onWillPop: () {
        timer?.cancel();
        return Future.delayed(Duration(milliseconds: 100), () {
          Navigator.pop(context);
          return;
        });
      },
      child: Scaffold(
        body: Stack(
          children: [
            CustomScrollView(
              slivers: <Widget>[
                CustomAppBar(title: 'Serving Orders', backEnabled: true),
                CustomListTitle(text: 'List of of all serving orders'),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      if (servingOrders.length > 0) {
                        final order = servingOrders[index];
                        final tmpDate = DateTime.parse(order.orderedDate);
                        final orderedDate =
                            DateFormat.yMMMd().add_jm().format(tmpDate);
                        final statusColor = order.bill != null
                            ? BillModel.getStatusColor(order.bill.status)
                            : Colors.grey;
                        final billStatus = order.bill != null
                            ? BillModel.getStatus(order.bill.status)
                            : 'Unbilled';

                        return OrderCard(
                            onServe: onServe,
                            order: order,
                            bill: order.bill,
                            orderedDate: orderedDate,
                            statusColor: statusColor,
                            billStatus: billStatus,
                            isLoading: isLoading);
                      }
                      return Container(
                        constraints: BoxConstraints(
                            minHeight:
                                MediaQuery.of(context).size.height - 220),
                        child: Center(
                          child: Column(
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.width * 0.6,
                                child: SvgPicture.asset(
                                  'assets/svg/goods.svg',
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'No Records',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    childCount:
                        servingOrders.length == 0 ? 1 : servingOrders.length,
                  ),
                ),
              ],
            ),
            isLoading == true
                ? Stack(children: [
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Opacity(
                        opacity: 0.7,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black,
                          ),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ),
                  ])
                : Container(),
          ],
        ),
      ),
    );
  }
}
