import 'dart:convert';

import 'package:app/component/common/AlertDialog.dart';
import 'package:app/component/common/ContainerWithBlurBackground.dart';
import 'package:app/component/common/MButton.dart';
import 'package:app/component/common/ProductOrderedCard.dart';
import 'package:app/component/common/SliverTitle.dart';
import 'package:app/component/decorators/TextStyle.dart';
import 'package:app/config.dart';
import 'package:app/helpers/Storage.dart';
import 'package:app/models/OrderItemModel.dart';
import 'package:app/models/OrderModel.dart';
import 'package:app/models/PageModel.dart';
import 'package:app/models/ProductModel.dart';
import 'package:app/store/OrderStore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class OrderSummary extends StatefulWidget {
  final PageModel data;
  OrderSummary({
    Key key,
    this.data,
  }) : super(key: key);

  @override
  OrderStateSummary createState() => OrderStateSummary();
}

class OrderStateSummary extends State<OrderSummary> {
  final LocalStorage localStorage = LocalStorage();
  BuildContext appContext;
  double totalPrice = 0.0;
  double getTotalPrice(List<OrderItemModel> items) {
    totalPrice = 0.0;
    items.map(
      (item) {
        final product = item.product;
        totalPrice = (product.finalPrice * product.quantity) + totalPrice;
      },
    ).toList();
    return totalPrice;
  }

  @override
  Widget build(BuildContext context) {
    appContext = context;
    OrderModel order = widget.data.order;
    List<OrderItemModel> items = order.items;
    totalPrice = getTotalPrice(items);

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  expandedHeight: 120.0,
                  floating: true,
                  snap: true,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text('Order Summary'),
                    background:
                        ContainerWithBlurBackground(contentWidget: null),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return SliverTitle(
                        leftText: 'Products Ordered',
                      );
                    },
                    childCount: 1,
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    final item = items[index];
                    if (items.length == 0) {
                      return Container(
                        height: MediaQuery.of(context).size.height - 200,
                        child: Center(
                          child: Text(
                            'No orders yet',
                            style: AppGlobalStyles.boldHeading,
                          ),
                        ),
                      );
                    } else {
                      final ProductModel product = item.product;
                      product.orderCount = item.quantity;
                      product.totalServings = product.totalServings;
                      return ProductOrderedCard(
                        product: product,
                        hideControls: true,
                      );
                    }
                  }, childCount: items.length == 0 ? 1 : items.length),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
