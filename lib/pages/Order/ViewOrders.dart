import 'package:app/component/common/ContainerWithBlurBackground.dart';
import 'package:app/component/common/MButton.dart';
import 'package:app/component/common/ProductOrderedCard.dart';
import 'package:app/component/common/SliverTitle.dart';
import 'package:app/component/decorators/TextStyle.dart';
import 'package:app/config.dart';
import 'package:app/models/ProductModel.dart';
import 'package:flutter/material.dart';

class ViewOrders extends StatefulWidget {
  ViewOrders({Key key}) : super(key: key);

  @override
  _ViewOrdersState createState() => _ViewOrdersState();
}

class _ViewOrdersState extends State<ViewOrders> {
  double totalPrice = 0.0;
  double getTotalPrice() {
    totalPrice = 0.0;
    AppGlobalConfig.orders.products
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
    totalPrice = getTotalPrice();
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
                      if (AppGlobalConfig.orders.products.length == 0) {
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
                        final product = AppGlobalConfig.orders.products[index];
                        return ProductOrderedCard(
                          product: product,
                          onIncrementOrder: () => {
                            setState(() {
                              totalPrice = getTotalPrice();
                            })
                          },
                          onDecrementOrder: () => {
                            setState(() {
                              totalPrice = getTotalPrice();
                            })
                          },
                          onRemoveOrder: (ProductModel orderToRemove) {
                            setState(() {
                              AppGlobalConfig.orders.products
                                  .remove(orderToRemove);
                            });
                          },
                        );
                      }
                    },
                    childCount: AppGlobalConfig.orders.products.length == 0
                        ? 1
                        : AppGlobalConfig.orders.products.length,
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
                child: AppGlobalConfig.orders.products.length == 0
                    ? null
                    : Column(
                        children: [
                          SizedBox(
                            height: 55,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  20.0, 8.0, 20.0, 8.0),
                              child: Text(
                                  'You have ${AppGlobalConfig.orders.products.length} ' +
                                      '${AppGlobalConfig.orders.products.length == 1 ? 'item' : 'items'} ' +
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
                                'Total of: ${pesoFormat.format(getTotalPrice())}',
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
