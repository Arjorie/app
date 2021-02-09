import 'package:app/models/ProductModel.dart';
import 'package:flutter/foundation.dart';

class OrderStore with ChangeNotifier {
  List<ProductModel> _orders = [];
  int _totalOrders = 0;
  String _tableId = '';
  int _customerCount = 0;
  String _paymentOptionId = '';
  String _billId = '';
  double _totalAmount = 0.00;
  double _totalPrice = 0.00;
  String _paymentName = '';
  String _paymentDescription = '';
  String _paymentAccountNumber = '';

  // getters
  List<ProductModel> get orders => _orders;
  get totalOrders => _totalOrders;
  get tableId => _tableId;
  get customerCount => _customerCount;
  get paymentOptionId => _paymentOptionId;
  get billId => _billId;
  get totalAmount => _totalAmount;
  get totalPrice => _totalPrice;
  get paymentName => _paymentName;
  get paymentDescription => _paymentDescription;
  get paymentAccountNumber => _paymentAccountNumber;

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

  set totalAmount(double value) {
    _totalAmount = value;
    notifyListeners();
  }

  set totalPrice(double value) {
    _totalPrice = value;
    notifyListeners();
  }

  set paymentName(String value) {
    _paymentName = value;
    notifyListeners();
  }

  set paymentDescription(String value) {
    _paymentDescription = value;
    notifyListeners();
  }

  set paymentAccountNumber(String value) {
    _paymentAccountNumber = value;
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
