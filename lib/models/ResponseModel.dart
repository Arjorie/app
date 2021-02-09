// Response Model
import 'package:app/models/OrderModel.dart';

class ResponseModel {
  List<OrderModel> rows;
  int count;
  ResponseModel({
    this.rows,
    this.count,
  });

  factory ResponseModel.fromJson(Map<String, dynamic> response) {
    List<OrderModel> orderData = [];
    response['rows']
        .map((order) => {orderData.add(OrderModel.fromJson(order))})
        .toList();
    return ResponseModel(
      rows: orderData,
      count: response['count'] as int,
    );
  }
}
