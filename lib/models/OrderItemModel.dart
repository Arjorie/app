import 'package:app/models/ProductModel.dart';

class OrderItemModel {
  String orderItemsId;
  int quantity;
  int category;
  double price;
  double totalPrice;
  String extras;
  ProductModel product;

  OrderItemModel({
    this.orderItemsId,
    this.quantity,
    this.category,
    this.price,
    this.totalPrice,
    this.extras,
    this.product,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> orderItem) {
    return OrderItemModel(
        orderItemsId: orderItem['order_items_id'],
        quantity: orderItem['quantity'],
        category: orderItem['category'],
        price: orderItem['price'].toDouble(),
        totalPrice: orderItem['total_price'].toDouble(),
        extras: orderItem['extras'],
        product: ProductModel.fromJson(orderItem['product']));
  }
}
