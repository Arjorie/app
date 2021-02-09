import 'dart:convert';

import 'package:app/component/common/AlertDialog.dart';
import 'package:app/component/common/CustomAppBar.dart';
import 'package:app/component/common/CustomListTitle.dart';
import 'package:app/component/common/LoadingScreen.dart';
import 'package:app/component/decorators/TextStyle.dart';
import 'package:app/config.dart';
import 'package:app/helpers/Storage.dart';
import 'package:app/models/PageModel.dart';
import 'package:app/store/OrderStore.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CashPaymentPage extends StatefulWidget {
  @override
  _CashPaymentPageState createState() => _CashPaymentPageState();
}

NumberFormat pesoFormat = NumberFormat.currency(locale: "en_PH", symbol: "₱");

class _CashPaymentPageState extends State<CashPaymentPage> {
  final LocalStorage localStorage = LocalStorage();
  BuildContext appContext;
  double amountPaid = 0.0;
  final amountPaidController = TextEditingController();
  bool isLoading = false;

  /* Destroy State - on dispose state of this page */
  @override
  void dispose() {
    super.dispose();
  }

  /* Do payment */
  payOrder(id) async {
    final token = await localStorage.getString('accessToken');
    final String authorizationHeader = 'Basic $token';
    setState(() {
      isLoading = true;
    });
    final response = await http.post(
      '${AppGlobalConfig.server}/employee/v1/bills/$id/pay-cash',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': authorizationHeader,
      },
      body: jsonEncode(<String, String>{
        'amount_paid': this.amountPaid.toString(),
      }),
    );
    setState(() {
      isLoading = false;
    });
    if (response.statusCode == 200) {
      showAlertDialog(context, 'Payment Success',
          'Please wait while we are processing your payment!', () {
        Navigator.of(context).popUntil(ModalRoute.withName('/home'));
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
    final orderStore = Provider.of<OrderStore>(context);
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
                CustomAppBar(
                  title: 'Cash Payment',
                  backEnabled: true,
                  dense: true,
                ),
                CustomListTitle(text: 'Fill in the following:'),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return Container(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: EdgeInsets.all(20),
                              child: Text(
                                'Collect the amount from the customer and enter the amount of payment below.',
                                style: TextStyle(
                                  fontSize: AppGlobalStyles.subtitleFontSize,
                                  color: AppGlobalStyles.darkColor,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(20),
                              child: Text(
                                'Total Amount to Pay: ${pesoFormat.format(orderStore.totalPrice)}',
                                style: TextStyle(
                                  fontSize: AppGlobalStyles.subtitleFontSize,
                                  color: AppGlobalStyles.darkColor,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Card(
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: SizedBox(
                                    height: 70,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Payment Amount',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: TextFormField(
                                            controller: amountPaidController,
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return 'Please enter your an amount!';
                                              }
                                              return null;
                                            },
                                            enableSuggestions: false,
                                            autocorrect: false,
                                            onChanged: (text) {
                                              setState(() {
                                                this.amountPaid =
                                                    double.parse(text);
                                              });
                                            },
                                            style: TextStyle(
                                              color: AppGlobalStyles.darkColor,
                                            ),
                                            decoration: InputDecoration(
                                                hintText:
                                                    'Enter Amount of Payment'),
                                            keyboardType: TextInputType.number,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                    childCount: 1,
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 5,
                    right: 5,
                    bottom: 10,
                  ),
                  child: SizedBox(
                    height: 45,
                    width: MediaQuery.of(context).size.width - 10,
                    child: ElevatedButton(
                      onPressed: () {
                        isLoading = true;
                        if (amountPaidController.text == '') {
                        } else if (double.parse(amountPaidController.text) <=
                            orderStore.totalPrice) {
                          setState(() {
                            isLoading = false;
                          });
                          showAlertDialog(context, 'Insufficient Funds!',
                              'Please provide the exact or greater than the amount to pay. Thank you!');
                        } else {
                          this.payOrder(orderStore.billId);
                        }
                        // isLoading = true;
                      },
                      child: Text(
                        "Confirm Payment",
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            isLoading == true ? LoadingScreen() : Container(),
          ],
        ),
      ),
    );
  }
}
