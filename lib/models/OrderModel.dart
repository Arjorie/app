// Order Model
import 'package:app/models/ProductModel.dart';

class OrderModel {
  String tableId;
  int customerCount;
  List<ProductModel> products;

  OrderModel({this.tableId, this.customerCount, this.products});
}
