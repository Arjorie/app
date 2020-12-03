import 'package:app/component/common/ProductPicture.dart';
import 'package:app/component/decorators/TextStyle.dart';
import 'package:app/config.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    Key key,
    @required this.product,
    @required this.onTap,
  }) : super(key: key);

  final double cardHeight = 120.0;
  final product;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    final discount =
        product['discount'] != 0 ? '${product['discount']}% Off!' : '';
    final description = product['description'].toString();
    final quantity = product['quantity'] ?? 0;
    final discountToDeduct =
        product['discount'] == 0 ? 0 : (product['discount'] / 100);
    final originalPrice = product['price'];
    final totalServings = product['servings'];
    final lastPrice = originalPrice - (originalPrice * discountToDeduct);
    final maxDescriptionLength =
        description.length > 100 ? 100 : description.length;
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(bottom: 10.0),
      height: cardHeight,
      child: Card(
        child: Opacity(
          opacity: quantity == 0 ? 0.5 : 1,
          child: InkWell(
            onTap: quantity == 0 ? null : () => {onTap()},
            child: Row(
              children: [
                ProductPicture(
                  imgSrc:
                      '${AppGlobalConfig.server}/public/products/${product['image']}',
                  width: cardHeight,
                  height: cardHeight,
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${product['name']}',
                          style: AppGlobalStyles.primaryBoldHeading,
                        ),
                        Text(
                          totalServings == 1
                              ? '$totalServings serving'
                              : '$totalServings servings',
                          style: AppGlobalStyles.orangeBoldCaption,
                        ),
                        Container(
                          child: Text(
                            '${description.substring(0, maxDescriptionLength)}',
                            style: AppGlobalStyles.paragraph,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        Text(
                          '₱${lastPrice.toStringAsFixed(2)}',
                          style: AppGlobalStyles.orangeBoldHeading,
                        ),
                        Text(
                            discount != ''
                                ? '₱${originalPrice.toStringAsFixed(2)}'
                                : '',
                            style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.redAccent.withOpacity(0.8),
                              fontWeight: FontWeight.bold,
                            )),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 50.0,
                        height: 50.0,
                        decoration: discount != ''
                            ? BoxDecoration(color: Colors.orangeAccent)
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
