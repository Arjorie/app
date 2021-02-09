import 'package:app/models/AccountModel.dart';
import 'package:flutter/material.dart';

import 'component/common/Categories.dart';
import 'models/CategoryModel.dart';

class AppGlobalConfig {
  static final AppGlobalConfig _singleton = AppGlobalConfig._internal();
  static AccountModel account = AccountModel();
  static String server = 'https://api.innocreativetechsolutions.com';
  // static String server = 'http://192.168.0.110:4200';

  // Colors
  static Color primaryColor = Color(0xFF5C6BC0);
  static Color warningColor = Colors.orange;
  static Color successColor = Colors.green;

  // Categories
  List<CategoryModel> categories = [
    CategoryModel(
      imgSrc: 'assets/background.png',
      text: 'All Products',
      value: null,
    ),
    CategoryModel(
      imgSrc: 'assets/img/beans.png',
      text: 'Rice & Beans',
      value: 0,
    ),
    CategoryModel(
      imgSrc: 'assets/img/fish.png',
      text: 'Fish',
      value: 1,
    ),
    CategoryModel(
      imgSrc: 'assets/img/pasta.png',
      text: 'Pasta',
      value: 2,
    ),
    CategoryModel(
      imgSrc: 'assets/img/casserole.png',
      text: 'Casserole',
      value: 3,
    ),
    CategoryModel(
      imgSrc: 'assets/img/salad.png',
      text: 'Salad',
      value: 4,
    ),
    CategoryModel(
      imgSrc: 'assets/img/bbq.png',
      text: 'Grilled',
      value: 5,
    ),
    CategoryModel(
      imgSrc: 'assets/img/dessert.png',
      text: 'Dessert',
      value: 6,
    ),
    CategoryModel(
      imgSrc: 'assets/img/meat.png',
      text: 'Meat',
      value: 7,
    ),
    CategoryModel(
      imgSrc: 'assets/img/soup.png',
      text: 'Soup',
      value: 8,
    ),
    CategoryModel(
      imgSrc: 'assets/img/pizza.png',
      text: 'Pizza',
      value: 9,
    ),
    CategoryModel(
      imgSrc: 'assets/img/veggie.png',
      text: 'Veggie',
      value: 10,
    ),
    CategoryModel(
      imgSrc: 'assets/img/softdrinks.png',
      text: 'Beverages',
      value: 11,
    ),
    CategoryModel(
      imgSrc: 'assets/img/liquor.png',
      text: 'Liquor',
      value: 12,
    ),
  ];
  List<Widget> getCategories(onTap) {
    final self = this;
    List<Widget> categoryCards = [];
    self.categories.forEach((element) {
      categoryCards.add(CategoryCard(
        imgSrc: element.imgSrc,
        text: element.text,
        value: element.value,
        onTap: onTap,
      ));
    });
    return categoryCards;
  }

  factory AppGlobalConfig() {
    return _singleton;
  }

  AppGlobalConfig._internal();
}

AppGlobalConfig globalConfig = AppGlobalConfig();
