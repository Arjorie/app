import 'dart:async';
import 'dart:convert';
import 'package:app/component/common/ConfirmDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';

import 'package:app/component/common/SliverTitle.dart';
import 'package:app/component/common/AlertDialog.dart';
import 'package:app/component/common/ProductCard.dart';
import 'package:app/component/common/ContainerWithBlurBackground.dart';
import 'package:app/component/common/IconWithBadge.dart';
import 'package:app/component/common/MButton.dart';
import 'package:app/helpers/Storage.dart';
import 'package:app/helpers/OrderProcess.dart';
import 'package:app/models/PageModel.dart';
import 'package:app/models/ProductModel.dart';
import 'package:app/component/decorators/TextStyle.dart';
import 'package:app/config.dart';

class OrderProduct extends StatefulWidget {
  @override
  _OrderProductState createState() => _OrderProductState();
}

class _OrderProductState extends State<OrderProduct> {
  // ignore: slash_for_doc_comments
  /**
   * Page Data
   */
  bool isLoading = true;
  List<dynamic> products = [];
  int badgeCount = AppGlobalConfig.orders.products?.length ?? 0;
  List<Widget> categoryCards = AppGlobalConfig().getCategories();
  BuildContext appContext;
  double appBarHeight = 120.0;
  double categoryHeight = 100;
  double loadingContainerHeight;

  // initState()
  // - on create/init hook/method of this class
  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 2400), () async => {this.getProductsData()});
  }

  /* Retrieve products data */
  Future getProductsData() async {
    final LocalStorage localStorage = LocalStorage();
    final String token = await localStorage.getString('accessToken');
    final String authorizationHeader = 'Basic $token';
    final response = await http.get(
      '${AppGlobalConfig.server}/employee/v1/products',
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
        products = result['data'];
      });
    } else if (response.statusCode == 403) {
      showAlertDialog(appContext, 'Session Expired!', 'Please relogin!');
      Navigator.of(appContext).pushReplacementNamed(
        '/login',
        arguments:
            PageModel(title: 'Employee Login', message: 'This is a message'),
      );
    } else {
      showAlertDialog(appContext, 'Ooops!', 'Something went wrong!');
    }
  }

  @override
  Widget build(BuildContext context) {
    appContext = context;
    loadingContainerHeight = MediaQuery.of(appContext).size.height -
        appBarHeight -
        categoryHeight -
        160;
    CircularProgressIndicator progressCircle = CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
    );

    return WillPopScope(
      onWillPop: () {
        return showComfirmDialog(
          context,
          'Are you sure?',
          'This will reset your current order. Please proceed with caution.',
          (index) {
            if (index == 0) {
              AppGlobalConfig.orders.products = [];
              AppGlobalConfig.orders.tableId = '';
              AppGlobalConfig.orders.customerCount = 0;
              Navigator.pop(context);
            }
          },
        );
      },
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    expandedHeight: appBarHeight,
                    floating: true,
                    snap: true,
                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      background:
                          ContainerWithBlurBackground(contentWidget: null),
                      title: Text('Food Menu'),
                    ),
                    actions: <Widget>[
                      IconButton(
                        icon: Icon(Icons.search_rounded),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Category',
                                  style: AppGlobalStyles.boldTitle),
                            ),
                            SizedBox(
                              height: categoryHeight,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: categoryCards,
                              ),
                            ),
                          ],
                        );
                      },
                      childCount: 1,
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return SliverTitle(
                          leftText: 'All Products',
                        );
                      },
                      childCount: 1,
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext productContext, int index) {
                        ProductModel product;
                        if (isLoading == true) {
                          return Container(
                            height: loadingContainerHeight,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Center(
                                    child: progressCircle,
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          product = ProductModel.fromJson(products[index]);
                          return ProductCard(
                            product: product,
                            onTap: () => {
                              onTapProductCard(
                                productContext,
                                product,
                                (orderedProductCount) => {
                                  setState(
                                    () {
                                      badgeCount = orderedProductCount;
                                    },
                                  ),
                                },
                              ),
                            },
                          );
                        }
                      },
                      childCount: isLoading == true ? 1 : products.length,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                MButton(
                  label: 'Checkout',
                  onPressed: () => {},
                  trailingIcon: IconWithBadge(
                    icon: SvgPicture.asset(
                      'assets/svg/cash-register.svg',
                      color: Colors.white,
                    ),
                    color: Colors.green,
                  ),
                ),
                MButton(
                  label: 'View Orders',
                  onPressed: () =>
                      {Navigator.pushNamed(context, '/view-orders')},
                  trailingIcon: IconWithBadge(
                    icon: SvgPicture.asset(
                      'assets/svg/shopping.svg',
                      color: Colors.white,
                    ),
                    badgeCount: badgeCount,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
