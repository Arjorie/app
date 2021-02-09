import 'package:app/component/common/BoxGradient.dart';
import 'package:app/component/common/ProductPicture.dart';
import 'package:app/component/decorators/TextStyle.dart';
import 'package:app/config.dart';
import 'package:app/models/ProductModel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

NumberFormat pesoFormat = NumberFormat.currency(locale: "en_PH", symbol: "₱");

class ProductCard extends StatelessWidget {
  const ProductCard({
    Key key,
    @required this.product,
    @required this.onTap,
  }) : super(key: key);

  final double cardHeight = 140.0;
  final ProductModel product;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    final discount = product.discountText;
    final quantity = product.quantity;
    final originalPrice = product.originalPrice;
    final totalServings = product.totalServings;
    final finalPrice = product.finalPrice;
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
            onTap: quantity == 0 ? null : () => {onTap()},
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      ProductPicture(
                        imgSrc:
                            '${AppGlobalConfig.server}/public/products/${product.productImage}',
                        // width: 120,
                        height: cardHeight,
                      ),
                      BoxGradient(
                        height: 50.0,
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
                            '$quantity left',
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
                              '${product.productName}',
                              overflow: TextOverflow.ellipsis,
                              style: AppGlobalStyles.primaryBoldTitle,
                            ),
                            Container(
                              child: Text(
                                totalServings == 1
                                    ? '$totalServings Serving'
                                    : '$totalServings Servings',
                                style: AppGlobalStyles.paragraph,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${pesoFormat.format(finalPrice)}',
                              style: AppGlobalStyles.orangeBoldHeading,
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
                            Container(
                              height: quantity == 0
                                  ? AppGlobalStyles.titleFontSize
                                  : 0,
                              child: quantity == 0
                                  ? Text(
                                      'Not Available',
                                      style: TextStyle(
                                        fontSize: AppGlobalStyles.titleFontSize,
                                        color:
                                            Colors.redAccent.withOpacity(0.8),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  : null,
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: (cardHeight * 0.5) - 4,
                        decoration: discount != ''
                            ? BoxDecoration(
                                color: Colors.orangeAccent,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(20)))
                            : null,
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            '$discount',
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
