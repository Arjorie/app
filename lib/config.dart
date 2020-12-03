import 'package:app/models/AccountModel.dart';
import 'package:flutter/material.dart';

import 'models/CategoryModel.dart';

class AppGlobalConfig {
  static final AppGlobalConfig _singleton = AppGlobalConfig._internal();
  AccountModel account = AccountModel();
  static String server = 'http://192.168.254.103:4200';
  static String tableIdToOrder = '';

  // Colors
  static Color primaryColor = Color(0xFF5C6BC0);
  static Color warningColor = Colors.orange;
  static List<CategoryModel> categories = [
    CategoryModel(imgSrc: 'assets/img/beans.png', text: 'Rice & Beans'),
    CategoryModel(imgSrc: 'assets/img/fish.png', text: 'Fish'),
    CategoryModel(imgSrc: 'assets/img/pasta.png', text: 'Pasta'),
    CategoryModel(imgSrc: 'assets/img/casserole.png', text: 'Casserole'),
    CategoryModel(imgSrc: 'assets/img/salad.png', text: 'Salad'),
    CategoryModel(imgSrc: 'assets/img/bbq.png', text: 'Grilled'),
    CategoryModel(imgSrc: 'assets/img/dessert.png', text: 'Dessert'),
    CategoryModel(imgSrc: 'assets/img/meat.png', text: 'Meat'),
    CategoryModel(imgSrc: 'assets/img/soup.png', text: 'Soup'),
    CategoryModel(imgSrc: 'assets/img/pizza.png', text: 'Pizza'),
    CategoryModel(imgSrc: 'assets/img/veggie.png', text: 'Veggie'),
  ];

  factory AppGlobalConfig() {
    return _singleton;
  }

  AppGlobalConfig._internal();
}

AppGlobalConfig globalConfig = AppGlobalConfig();
