import 'dart:async';
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

class OnlinePaymentPage extends StatefulWidget {
  @override
  _OnlinePaymentPageState createState() => _OnlinePaymentPageState();
}

NumberFormat pesoFormat = NumberFormat.currency(locale: "en_PH", symbol: "₱");

class _OnlinePaymentPageState extends State<OnlinePaymentPage> {
  final LocalStorage localStorage = LocalStorage();
  BuildContext appContext;
  double amountPaid = 0.0;
  String accountNumber = '';
  String accountName = '';
  String bankName = '';
  final amountPaidController = TextEditingController(text: "0");
  final accountNamePaidController = TextEditingController();
  final accountNumberPaidController = TextEditingController();
  final bankNamePaidController = TextEditingController();
  FocusNode input1;
  FocusNode input2;
  FocusNode input3;
  FocusNode input4;
  bool isLoading = false;

  /* Init State - on create state of this page */
  @override
  void initState() {
    super.initState();
    input1 = FocusNode();
    input2 = FocusNode();
    input3 = FocusNode();
    input4 = FocusNode();
  }

  /* Destroy State - on dispose state of this page */
  @override
  void dispose() {
    amountPaidController.dispose();
    accountNamePaidController.dispose();
    accountNumberPaidController.dispose();
    bankNamePaidController.dispose();
    super.dispose();
  }

  /* Do payment */
  payOrder(id, paymentOptionId) async {
    final token = await localStorage.getString('accessToken');
    final String authorizationHeader = 'Basic $token';
    setState(() {
      isLoading = true;
    });
    final response = await http.post(
      '${AppGlobalConfig.server}/employee/v1/bills/$id/pay',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': authorizationHeader,
      },
      body: jsonEncode(<String, String>{
        'amount_paid': this.amountPaid.toString(),
        'bank_name': this.bankName,
        'payment_option_id': paymentOptionId,
        'account_number': this.accountNumber,
        'account_name': this.accountName,
      }),
    );
    setState(() {
      isLoading = false;
    });
    print(response.body);
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

  _nextFocus(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    // Timer(Duration(milliseconds: 4000), () {
    if (nextFocus != null) {
      FocusScope.of(context).requestFocus(nextFocus);
    }
    // });
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
                  title: orderStore.paymentName,
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
                                '${orderStore.paymentDescription}',
                                style: TextStyle(
                                  fontSize: AppGlobalStyles.subtitleFontSize,
                                  color: AppGlobalStyles.darkColor,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: Text(
                                'Account Number:',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: AppGlobalStyles.subtitleFontSize,
                                  color: AppGlobalStyles.darkColor,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 20),
                              child: Text(
                                '${orderStore.paymentAccountNumber}',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: AppGlobalStyles.subtitleFontSize,
                                  color: AppGlobalStyles.darkColor,
                                  fontWeight: FontWeight.bold,
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
                            /* Amount to Pay */
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
                                            focusNode: input1,
                                            onEditingComplete: () {
                                              _nextFocus(
                                                  context, input1, input2);
                                            },
                                            textInputAction:
                                                TextInputAction.next,
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
                            ),
                            /* Account Number */
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
                                            'Account Number',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: TextFormField(
                                            controller:
                                                accountNumberPaidController,
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return 'Please enter your account\'s last 4 digits!';
                                              }
                                              return null;
                                            },
                                            focusNode: input2,
                                            onEditingComplete: () {
                                              _nextFocus(
                                                  context, input2, input3);
                                            },
                                            textInputAction:
                                                TextInputAction.next,
                                            enableSuggestions: false,
                                            autocorrect: false,
                                            onChanged: (text) {
                                              setState(() {
                                                this.accountNumber = text;
                                              });
                                            },
                                            style: TextStyle(
                                              color: AppGlobalStyles.darkColor,
                                            ),
                                            decoration: InputDecoration(
                                                hintText:
                                                    'Enter only your last 4 digits.'),
                                            keyboardType: TextInputType.number,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            /* Account Name */
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
                                            'Account Name (optional)',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: TextFormField(
                                            controller:
                                                accountNamePaidController,
                                            focusNode: input3,
                                            onEditingComplete: () {
                                              _nextFocus(
                                                  context, input3, input4);
                                            },
                                            textInputAction:
                                                TextInputAction.next,
                                            enableSuggestions: false,
                                            autocorrect: false,
                                            onChanged: (text) {
                                              setState(() {
                                                this.accountName = text;
                                              });
                                            },
                                            style: TextStyle(
                                              color: AppGlobalStyles.darkColor,
                                            ),
                                            decoration: InputDecoration(
                                                hintText:
                                                    'Enter your account name.'),
                                            keyboardType: TextInputType.name,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            /* Account Number */
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
                                            'Bank Name (optional)',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: TextFormField(
                                            controller: bankNamePaidController,
                                            onEditingComplete: () {
                                              _nextFocus(context, input4, null);
                                            },
                                            focusNode: input4,
                                            textInputAction:
                                                TextInputAction.done,
                                            enableSuggestions: false,
                                            autocorrect: false,
                                            onChanged: (text) {
                                              setState(() {
                                                this.bankName = text;
                                              });
                                            },
                                            style: TextStyle(
                                              color: AppGlobalStyles.darkColor,
                                            ),
                                            decoration: InputDecoration(
                                                hintText:
                                                    'Enter bank used to send amount'),
                                            keyboardType: TextInputType.name,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 70,
                            ),
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
                        setState(() {
                          isLoading = true;
                        });
                        if (amountPaidController.text == '') {
                          showAlertDialog(context, 'Insufficient Funds!',
                              'Please provide the exact or greater than the amount to pay. Thank you!');
                        } else if (accountNumberPaidController.text == '') {
                          showAlertDialog(context, 'Field Required!',
                              'Please provide the last 4 digits of your account number!');
                        } else if (double.parse(amountPaidController.text) <=
                            orderStore.totalPrice) {
                          showAlertDialog(context, 'Insufficient Funds!',
                              'Please provide the exact or greater than the amount to pay. Thank you!');
                        } else {
                          this.payOrder(
                              orderStore.billId, orderStore.paymentOptionId);
                        }
                        setState(() {
                          isLoading = false;
                        });
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
