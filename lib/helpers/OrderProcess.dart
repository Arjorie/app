import 'package:app/component/common/BoxGradient.dart';
import 'package:app/component/common/CoverImage.dart';
import 'package:app/component/common/MButton.dart';
import 'package:app/component/decorators/TextStyle.dart';
import 'package:app/config.dart';
import 'package:app/models/ProductModel.dart';
import 'package:app/store/OrderStore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

Future onTapProductCard(BuildContext context, product) {
  return showMaterialModalBottomSheet(
    backgroundColor: Colors.transparent,
    enableDrag: true,
    duration: Duration(milliseconds: 200),
    bounce: true,
    context: context,
    builder: (context) => BottomSheetContent(
      product: product,
      rawProductData: product,
    ),
  );
}

class BottomSheetContent extends StatefulWidget {
  const BottomSheetContent({
    Key key,
    @required this.product,
    @required this.rawProductData,
  }) : super(key: key);

  final product;
  final rawProductData;

  @override
  _BottomSheetContentState createState() => _BottomSheetContentState(product);
}

class _BottomSheetContentState extends State<BottomSheetContent> {
  // class data/property members
  ProductModel product;
  double finalPrice;
  int orderCount = 1;
  double totalPrice = 0.0;
  BuildContext appContext;
  _BottomSheetContentState(this.product);
  NumberFormat pesoFormat = NumberFormat.currency(locale: "en_PH", symbol: "₱");

  @override
  void initState() {
    super.initState();
    finalPrice = product.finalPrice;
    totalPrice = finalPrice.toDouble() * orderCount.toDouble();
  }

  // Place order locally
  onPlaceOrder(BuildContext context, int orderCount, dynamic product) {
    final orderStore = Provider.of<OrderStore>(context, listen: false);
    product.orderCount = orderCount;

    orderStore.addOrder(product);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    appContext = context;
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height - 120.0,
        constraints: BoxConstraints(minHeight: 480),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.bottomLeft,
              children: [
                CoverImage(
                  imgSrc:
                      '${AppGlobalConfig.server}/public/products/${product.productImage}',
                  height: MediaQuery.of(context).size.height * 0.35,
                ),
                BoxGradient(
                  height: 100.0,
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0),
                    Colors.black.withOpacity(0.8),
                    Colors.black.withOpacity(0.9),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Text(
                        widget.product.productName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: Text(
                            '${pesoFormat.format(finalPrice)}',
                            style: TextStyle(
                              fontSize: AppGlobalStyles.headingFontSize,
                              fontWeight: FontWeight.bold,
                              color: AppGlobalConfig.warningColor,
                            ),
                          ),
                        ),
                        Container(
                          height: product.discountText != ''
                              ? AppGlobalStyles.captionFontSize
                              : 0,
                          child: product.discountText != ''
                              ? Text(
                                  '${pesoFormat.format(product.originalPrice)}',
                                  style: TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    fontSize: AppGlobalStyles.captionFontSize,
                                    color: Colors.redAccent.withOpacity(0.8),
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : null,
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                            left: 8.0,
                            right: 8.0,
                          ),
                          margin: const EdgeInsets.only(
                            left: 8.0,
                            right: 8.0,
                          ),
                          decoration: product.discountText != ''
                              ? BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  color: Colors.orangeAccent,
                                )
                              : null,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              '${product.discountText}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 8.0,
                        right: 8.0,
                        bottom: 8.0,
                      ),
                      child: Text(
                        product.totalServings == 1
                            ? '${product.totalServings} Serving'
                            : '${product.totalServings} Servings',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: AppGlobalStyles.titleFontSize,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Expanded(
              flex: 3,
              child: Container(
                height: 300,
                constraints: BoxConstraints(minHeight: 300),
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Description:',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
                      child: Text(
                        product.description,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
              child: Column(
                children: [
                  SizedBox(
                    height: 40,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('How many would you like to order?',
                          style: TextStyle(
                            fontSize: 20,
                            color: AppGlobalConfig.primaryColor,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ),
                  Container(
                    width: (MediaQuery.of(context).size.width * 0.7),
                    child: Center(
                      child: Row(
                        children: [
                          MButton(
                            label: '-',
                            flex: 2,
                            disabled: orderCount == 1,
                            onPressed: () => {
                              setState(() {
                                if (orderCount > 1) orderCount = orderCount - 1;
                                totalPrice = finalPrice.toDouble() *
                                    orderCount.toDouble();
                              })
                            },
                          ),
                          Expanded(
                            flex: 4,
                            child: Container(
                              height: 40,
                              constraints: BoxConstraints(minHeight: 40),
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.5),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  '$orderCount',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black.withOpacity(0.6),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          MButton(
                            label: '+',
                            flex: 2,
                            disabled: orderCount == product.quantity,
                            onPressed: () => {
                              setState(() {
                                if (orderCount < product.quantity)
                                  orderCount = orderCount + 1;
                                totalPrice = finalPrice.toDouble() *
                                    orderCount.toDouble();
                              })
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    child: Center(
                        child:
                            Text('Total of: ${pesoFormat.format(totalPrice)}',
                                style: TextStyle(
                                  color: AppGlobalConfig.warningColor,
                                  fontSize: AppGlobalStyles.headingFontSize,
                                  fontWeight: FontWeight.bold,
                                ))),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      MButton(
                        label: 'Order',
                        flex: 2,
                        backgroundColor: AppGlobalConfig.primaryColor,
                        onPressed: () => {
                          onPlaceOrder(
                              context, orderCount, widget.rawProductData)
                        },
                      ),
                      MButton(
                        label: 'Cancel',
                        flex: 2,
                        backgroundColor: Colors.red,
                        onPressed: () => {Navigator.pop(context)},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
