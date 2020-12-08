class ProductModel {
  String productId;
  String productImage;
  String productName;
  int quantity;
  String discountText;
  String description;
  double finalPrice;
  double originalPrice;
  int totalServings;
  int orderCount;
  double discountToDeduct;

  ProductModel({
    this.productId,
    this.productImage,
    this.productName,
    this.quantity,
    this.discountText,
    this.description,
    this.finalPrice,
    this.originalPrice,
    this.totalServings,
    this.orderCount,
    this.discountToDeduct,
  });

  factory ProductModel.fromJson(Map<String, dynamic> product,
      {int orderCount}) {
    final originalPrice = product['price']?.toDouble() ?? 0.0;
    final discountToDeduct = product['discount'] == 0.0
        ? 0.0
        : (product['discount'].toDouble() / 100.0);

    return ProductModel(
      productId: product['product_id'] ?? null,
      productImage: product['image'] ?? null,
      productName: product['name'] ?? '',
      quantity: product['quantity'] ?? 0,
      discountText:
          product['discount'] != 0 ? '${product['discount']}% Off!' : '',
      description: product['description'].toString(),
      originalPrice: originalPrice,
      totalServings: product['servings'] ?? 0,
      discountToDeduct: discountToDeduct,
      finalPrice: originalPrice - (originalPrice * discountToDeduct),
      orderCount: orderCount ?? 0,
    );
  }
}
