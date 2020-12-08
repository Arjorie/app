import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:app/config.dart';
import 'package:app/models/PageModel.dart';
import 'package:app/models/AccountModel.dart';
import 'package:app/helpers/Storage.dart';
import 'package:app/component/common/AlertDialog.dart';
import 'package:app/component/common/ContainerWithBlurBackground.dart';
import 'package:app/component/common/Logo.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  final LocalStorage localStorage = LocalStorage();
  BuildContext appContext;
  final PageModel data = PageModel(
    title: 'Employee Login',
    message: 'This is a message',
  );

  // ignore: slash_for_doc_comments
  /**
   * App Page on initialize
   */
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 2000), authenticate);
  }

  Future refreshToken() async {
    print(AppGlobalConfig.server);
    final String token = await localStorage.getString('accessToken');
    final String authorizationHeader = 'Basic $token';
    try {
      final response = await http.post(
        '${AppGlobalConfig.server}/employee/v1/refresh-token',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': authorizationHeader,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> record = jsonDecode(response.body);
        final accessToken = record['access_token'];
        final rawAccount = record['employee'];
        final AccountModel account = AccountModel.fromJson(rawAccount);
        AppGlobalConfig.account = account;
        localStorage.setString('accessToken', accessToken);
        Navigator.of(context).pushReplacementNamed(
          '/home',
        );
      } else {
        await localStorage.remove('accessToken');
        Navigator.of(context).pushReplacementNamed(
          '/login',
          arguments: data,
        );
      }
    } catch (error) {
      showAlertDialog(
        appContext,
        'Connection Error!',
        'Please try again later!',
        () => {authenticate()},
      );
    }
  }

  void authenticate() async {
    final String token = await localStorage.getString('accessToken');
    if (token == null) {
      Navigator.of(context).pushReplacementNamed(
        '/login',
        arguments: data,
      );
    } else {
      await refreshToken();
    }
  }

  @override
  Widget build(BuildContext context) {
    appContext = context;

    return Scaffold(
        body: ContainerWithBlurBackground(
      contentWidget: Container(
        child: Center(
          child: Logo(width: 80, height: 80),
        ),
      ),
    ));
  }
}
