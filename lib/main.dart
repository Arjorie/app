import 'package:app/store/OrderStore.dart';
import 'package:flutter/material.dart';
import 'package:app/config.dart';
import 'package:app/router/router.dart';
import 'package:provider/provider.dart';

import 'store/Store.dart';

main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Store>.value(value: Store()),
        ChangeNotifierProvider<OrderStore>.value(value: OrderStore()),
      ],
      child: MaterialApp(
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          primaryColor: AppGlobalConfig.primaryColor,
          accentColor: AppGlobalConfig.primaryColor,
          brightness: Brightness.light,
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: AppGlobalConfig.primaryColor,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  AppGlobalConfig.primaryColor),
            ),
          ),
        ),
        debugShowCheckedModeBanner: false,
        onGenerateRoute: onGenerateRoute,
      ),
    );
  }
}
