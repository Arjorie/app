import 'package:app/models/ProductModel.dart';
import 'package:flutter/foundation.dart';

class OrderStore with ChangeNotifier {
  List<ProductModel> _orders = [];
  int _totalOrders = 0;
  String _tableId = '';
  int _customerCount = 0;
  String _paymentOptionId = '';
  String _billId = '';

  // getters
  List<ProductModel> get orders => _orders;
  get totalOrders => _totalOrders;
  get tableId => _tableId;
  get customerCount => _customerCount;
  get paymentOptionId => _paymentOptionId;
  get billId => _billId;

  // setters
  set totalOrders(int val) {
    _totalOrders = val;
    notifyListeners();
  }

  set tableId(String tableId) {
    _tableId = tableId;
    notifyListeners();
  }

  set customerCount(int value) {
    _customerCount = value;
    notifyListeners();
  }

  set paymentOptionId(String value) {
    _paymentOptionId = value;
    notifyListeners();
  }

  set billId(String value) {
    _billId = value;
    notifyListeners();
  }

  // helper methods
  addOrder(ProductModel product) {
    _orders.add(product);
    _totalOrders = _totalOrders + 1;
    notifyListeners();
  }

  removeOrder(ProductModel product) {
    final bool isRemoved = _orders.remove(product);
    if (isRemoved) _totalOrders = _totalOrders - 1;
    notifyListeners();
  }

  resetOrder() {
    _orders = [];
    _totalOrders = 0;
    _tableId = '';
    _customerCount = 0;
    _paymentOptionId = '';
    _billId = '';
    notifyListeners();
  }
}
