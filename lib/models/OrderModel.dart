// Order Model
import 'package:app/models/BillModel.dart';
import 'package:app/models/OrderItemModel.dart';
import 'package:app/models/TableModel.dart';

class OrderModel {
  String orderId;
  int orderNo;
  int customerCount;
  double totalPrice;
  String orderedDate;
  List<OrderItemModel> items;
  BillModel bill;
  TableModel table;
  String status;

  OrderModel(
      {this.orderId,
      this.orderNo,
      this.customerCount,
      this.totalPrice,
      this.orderedDate,
      this.items,
      this.bill,
      this.status,
      this.table});

  factory OrderModel.fromJson(Map<String, dynamic> order) {
    List<OrderItemModel> _items = [];
    order['items']
        .map((item) => {_items.add(OrderItemModel.fromJson(item))})
        .toList();
    return OrderModel(
      orderId: order['order_id'],
      orderNo: order['order_no'],
      items: _items,
      customerCount: order['customer_count'],
      totalPrice: order['total_price'].toDouble(),
      orderedDate: order['ordered_date'],
      status: order['status'],
      bill: BillModel.fromJson(order['bill']),
      table: TableModel.fromJson(order['table']),
    );
  }
}
