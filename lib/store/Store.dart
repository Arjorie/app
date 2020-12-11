import 'package:flutter/foundation.dart';

class Store with ChangeNotifier {
  String _name = 'Dashboard';

  String get name => _name;

  set setStoreName(String name) {
    _name = name;
    notifyListeners();
  }
}
