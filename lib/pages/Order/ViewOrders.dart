import 'package:app/component/common/ContainerWithBlurBackground.dart';
import 'package:app/component/common/MButton.dart';
import 'package:app/component/common/ProductOrderedCard.dart';
import 'package:app/component/common/SliverTitle.dart';
import 'package:app/component/decorators/TextStyle.dart';
import 'package:app/config.dart';
import 'package:app/models/ProductModel.dart';
import 'package:app/store/OrderStore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewOrders extends StatefulWidget {
  ViewOrders({Key key}) : super(key: key);

  @override
  _ViewOrdersState createState() => _ViewOrdersState();
}

class _ViewOrdersState extends State<ViewOrders> {
  double totalPrice = 0.0;
  double getTotalPrice(OrderStore orderStore) {
    totalPrice = 0.0;
    orderStore.orders
        .map(
          (product) => {
            totalPrice = (product.finalPrice * product.orderCount) + totalPrice
          },
        )
        .toList();
    return totalPrice;
  }

  @override
  Widget build(BuildContext context) {
    final orderStore = Provider.of<OrderStore>(context);
    totalPrice = getTotalPrice(orderStore);
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
                    title: Text('Orders'),
                    background:
                        ContainerWithBlurBackground(contentWidget: null),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return SliverTitle(
                        leftText: 'All Orders',
                      );
                    },
                    childCount: 1,
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      if (orderStore.totalOrders == 0) {
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
                        final product = orderStore.orders[index];
                        return ProductOrderedCard(
                          product: product,
                          onIncrementOrder: () => {
                            setState(() {
                              totalPrice = getTotalPrice(orderStore);
                            })
                          },
                          onDecrementOrder: () => {
                            setState(() {
                              totalPrice = getTotalPrice(orderStore);
                            })
                          },
                          onRemoveOrder: (ProductModel orderToRemove) {
                            setState(() {
                              orderStore.removeOrder(orderToRemove);
                            });
                          },
                        );
                      }
                    },
                    childCount: orderStore.totalOrders == 0
                        ? 1
                        : orderStore.totalOrders,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      offset: Offset.zero,
                      blurRadius: 5.0,
                    )
                  ],
                  color: Colors.white,
                ),
                child: orderStore.totalOrders == 0
                    ? null
                    : Column(
                        children: [
                          SizedBox(
                            height: 65,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  20.0, 8.0, 20.0, 8.0),
                              child: Text(
                                  'You have ${orderStore.totalOrders} ' +
                                      '${orderStore.totalOrders == 1 ? 'item' : 'items'} ' +
                                      ' in your list. Please confirm to proceed.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: AppGlobalConfig.primaryColor,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            child: Center(
                              child: Text(
                                'Total of: ${pesoFormat.format(getTotalPrice(orderStore))}',
                                style: TextStyle(
                                  color: AppGlobalConfig.warningColor,
                                  fontSize: AppGlobalStyles.headingFontSize,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              MButton(
                                label: 'Confirm Order',
                                flex: 2,
                                backgroundColor: AppGlobalConfig.primaryColor,
                                onPressed: () => {
                                  Navigator.pushNamed(
                                      context, '/order-confirmation')
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
