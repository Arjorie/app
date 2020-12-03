import 'dart:async';
import 'dart:convert';

import 'package:app/component/common/Categories.dart';
import 'package:app/component/decorators/TextStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';

import 'package:app/component/common/AlertDialog.dart';
import 'package:app/component/common/ProductCard.dart';
import 'package:app/component/common/ContainerWithBlurBackground.dart';
import 'package:app/component/common/IconWithBadge.dart';
import 'package:app/component/common/MButton.dart';
import 'package:app/component/common/MenuButton.dart';
import 'package:app/helpers/Storage.dart';
import 'package:app/models/PageModel.dart';
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
  int badgeCount = 0;
  List<Widget> categoryCards = [];
  BuildContext appContext;

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
    AppGlobalConfig.categories.forEach((element) {
      categoryCards
          .add(CategoryCard(imgSrc: element.imgSrc, text: element.text));
    });

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Product Drawer'),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
            ),
            ListTile(
              title: Text('Item 1'),
              onTap: () {
                // Update the state of the app.
                setState(() {
                  badgeCount += 1;
                });
                // ...
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                    expandedHeight: 120.0,
                    floating: true,
                    snap: true,
                    leading: MenuButton(),
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
                      IconButton(
                        icon: IconWithBadge(
                          icon: SvgPicture.asset(
                            'assets/svg/shopping.svg',
                            color: Colors.white,
                          ),
                          badgeCount: badgeCount,
                        ),
                        tooltip: 'Add new entry',
                        onPressed: () {},
                      ),
                    ]),
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
                            height: 100,
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
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('All Products',
                                    style: AppGlobalStyles.boldTitle),
                                // Text('View All',
                                // style: AppGlobalStyles.primarySubtitle),
                              ],
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
                      final product = products[index];
                      return ProductCard(
                          product: product,
                          onTap: () => {print(product['product_id'])});
                    },
                    childCount: products.length ?? 0,
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
                onPressed: () => {},
                trailingIcon: IconWithBadge(
                  icon: SvgPicture.asset(
                    'assets/svg/shopping.svg',
                    color: Colors.white,
                  ),
                  badgeCount: 20,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
