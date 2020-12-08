import 'package:app/component/common/BoxGradient.dart';
import 'package:app/component/common/ProductPicture.dart';
import 'package:app/component/decorators/TextStyle.dart';
import 'package:app/config.dart';
import 'package:app/models/ProductModel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

NumberFormat pesoFormat = NumberFormat.currency(locale: "en_PH", symbol: "₱");

class ProductOrderedCard extends StatefulWidget {
  const ProductOrderedCard({
    Key key,
    @required this.product,
    this.onTap,
    this.onIncrementOrder,
    this.onDecrementOrder,
    this.onRemoveOrder,
  }) : super(key: key);

  final ProductModel product;
  final Function onTap;
  final Function onDecrementOrder;
  final Function onIncrementOrder;
  final Function onRemoveOrder;

  @override
  _ProductOrderedCardState createState() => _ProductOrderedCardState();
}

class _ProductOrderedCardState extends State<ProductOrderedCard> {
  final double cardHeight = 150.0;

  @override
  Widget build(BuildContext context) {
    final discount = widget.product.discountText;
    final quantity = widget.product.quantity;
    final originalPrice = widget.product.originalPrice;
    final totalServings = widget.product.totalServings;
    final finalPrice = widget.product.finalPrice;
    final orderTotalPrice = finalPrice * widget.product.orderCount.toDouble();
    return Container(
      alignment: Alignment.center,
      height: cardHeight,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: quantity == 0 ? 0 : 2,
        child: Opacity(
          opacity: quantity == 0 ? 0.4 : 1,
          child: InkWell(
            onTap: quantity == 0 || widget.onTap == null
                ? null
                : () => {if (widget.onTap != null) widget.onTap()},
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      ProductPicture(
                        imgSrc:
                            '${AppGlobalConfig.server}/public/products/${widget.product.productImage}',
                        width: 120,
                        height: cardHeight,
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        width: 30,
                        height: 30,
                        child: IconButton(
                          icon: Icon(
                            Icons.remove_circle,
                            color: Colors.redAccent,
                            size: 30.0,
                          ),
                          onPressed: () {
                            if (widget.onRemoveOrder != null) {
                              widget.onRemoveOrder(widget.product);
                            }
                          },
                        ),
                      ),
                      BoxGradient(
                        height: 90.0,
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0),
                          Colors.black.withOpacity(0.7),
                          Colors.black.withOpacity(0.9),
                        ],
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '${widget.product.orderCount} Order${widget.product.orderCount == 1 ? '' : 's'}' +
                                '\n${widget.product.orderCount * totalServings} Serving${totalServings == 1 ? '' : 's'}',
                            style: TextStyle(
                              fontSize: AppGlobalStyles.subtitleFontSize,
                              color: Colors.white.withOpacity(0.8),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              '${widget.product.productName}',
                              style: AppGlobalStyles.primaryBoldHeading,
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${pesoFormat.format(finalPrice)}',
                              style: AppGlobalStyles.primaryBoldHeading,
                            ),
                            Container(
                              height: discount != ''
                                  ? AppGlobalStyles.captionFontSize
                                  : 0,
                              child: discount != ''
                                  ? Text(
                                      '${pesoFormat.format(originalPrice)}',
                                      style: TextStyle(
                                        decoration: TextDecoration.lineThrough,
                                        fontSize:
                                            AppGlobalStyles.captionFontSize,
                                        color:
                                            Colors.redAccent.withOpacity(0.8),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  : null,
                            ),
                            Text(
                              '${pesoFormat.format(orderTotalPrice)}',
                              style: TextStyle(
                                color: AppGlobalConfig.warningColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 32.0,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (widget.product.orderCount <=
                                widget.product.quantity) {
                              widget.product.orderCount =
                                  widget.product.orderCount + 1;
                              if (widget.onIncrementOrder != null)
                                widget.onIncrementOrder();
                            }
                          });
                        },
                        child: Opacity(
                          opacity: widget.product.quantity <
                                  widget.product.orderCount
                              ? 0.5
                              : 1,
                          child: Container(
                            height: (cardHeight * 0.34) - 8,
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppGlobalConfig.primaryColor,
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                '+',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: (cardHeight * 0.34) - 8,
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            '${widget.product.orderCount}',
                            textAlign: TextAlign.center,
                            style: AppGlobalStyles.primaryBoldTitle,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (widget.product.orderCount > 1) {
                              widget.product.orderCount =
                                  widget.product.orderCount - 1;
                              if (widget.onDecrementOrder != null)
                                widget.onDecrementOrder();
                            }
                          });
                        },
                        child: Opacity(
                          opacity: widget.product.orderCount == 1 ? 0.5 : 1,
                          child: Container(
                            height: (cardHeight * 0.34) - 8,
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: AppGlobalConfig.primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                '-',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
