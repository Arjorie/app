import 'dart:async';
import 'dart:convert';

import 'package:app/component/common/AlertDialog.dart';
import 'package:app/component/common/CustomAppBar.dart';
import 'package:app/component/common/CustomListTitle.dart';
import 'package:app/component/decorators/TextStyle.dart';
import 'package:app/config.dart';
import 'package:app/helpers/Storage.dart';
import 'package:app/models/PageModel.dart';
import 'package:app/models/PaymentOptionModel.dart';
import 'package:app/store/OrderStore.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PaymentOptionsPage extends StatefulWidget {
  final PageModel data;
  PaymentOptionsPage({
    Key key,
    @required this.data,
  }) : super(key: key);
  @override
  PaymentOptionsPageState createState() => PaymentOptionsPageState();
}

class PaymentOptionsPageState extends State<PaymentOptionsPage> {
  final LocalStorage localStorage = LocalStorage();
  bool isLoading = true;
  BuildContext appContext;
  List<PaymentOptionModel> paymentOptions = [];

  // ignore: slash_for_doc_comments
  /**
   * Page Life Cycle
   */

  /* Init State - on create state of this page */
  @override
  void initState() {
    super.initState();
    this.getPaymentOptions();
  }

  /* Destroy State - on dispose state of this page */
  @override
  void dispose() {
    super.dispose();
  }

  // ignore: slash_for_doc_comments
  /**
   * Page Methods
   */

  /* API Request */
  void getPaymentOptions() async {
    final token = await localStorage.getString('accessToken');
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
      setState(() {
        paymentOptions =
            PaymentOptionModel.fromArray(result['payment_options']);
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

  // ignore: slash_for_doc_comments
  /**
   * Page UI - on Render
   */
  @override
  Widget build(BuildContext context) {
    final orderState = Provider.of<OrderStore>(context);
    print(orderState.totalPrice);
    // Access page data
    PageModel data = widget.data;
    appContext = context;
    return WillPopScope(
      onWillPop: () {
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
                CustomAppBar(title: 'Payment Options', backEnabled: true),
                CustomListTitle(text: 'Select payment option'),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      final paymentMethod = paymentOptions[index];
                      return Card(
                        margin: EdgeInsets.all(5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: InkWell(
                          onTap: () {
                            orderState.billId = data.message;
                            orderState.paymentName = paymentMethod.name;
                            orderState.paymentAccountNumber =
                                paymentMethod.accountNumber;
                            orderState.paymentDescription =
                                paymentMethod.description;
                            orderState.paymentOptionId =
                                paymentMethod.paymentOptionId;
                            if (paymentMethod.name == 'Cash') {
                              Navigator.of(context).pushNamed('/cash-payment');
                            } else {
                              Navigator.of(context)
                                  .pushNamed('/online-payment');
                            }
                          },
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 180,
                            child: Container(
                              child: Padding(
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(paymentMethod.name,
                                        style: TextStyle(
                                          color: AppGlobalConfig.primaryColor,
                                          fontSize:
                                              AppGlobalStyles.headingFontSize,
                                          fontWeight: FontWeight.bold,
                                        )),
                                    Text(paymentMethod.description,
                                        style: TextStyle(
                                          color: AppGlobalStyles.darkColor,
                                          fontSize:
                                              AppGlobalStyles.subtitleFontSize,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: paymentOptions.length,
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
