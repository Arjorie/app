import 'dart:ui';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'package:app/config.dart';
import 'package:app/component/decorators/InputDecorator.dart';
import 'package:app/component/common/AlertDialog.dart';
import 'package:app/component/common/ContainerWithBlurBackground.dart';
import 'package:app/component/common/Logo.dart';
import 'package:app/models/PageModel.dart';
import 'package:app/models/AccountModel.dart';
import 'package:app/helpers/Storage.dart';

class Login extends StatefulWidget {
  final PageModel data;
  Login({
    Key key,
    @required this.data,
  }) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // CLASS STATES
  // - All data or states accesible for this class
  LocalStorage localStorage = LocalStorage();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _passwordKey = GlobalKey<FormFieldState>();
  final _usernameKey = GlobalKey<FormFieldState>();
  final usernameTFController = TextEditingController();
  final passwordTFController = TextEditingController();
  String username = '';
  String password = '';
  bool passwordVisible = false;
  Icon passwordIcon = Icon(Icons.visibility);
  bool loginButtonDisabled = false;
  bool isLoading = false;

  // CLASS LIFE CYCLE METHODS
  // The life cycle hooks for this class

  // initState()
  // - on create/init hook/method of this class
  @override
  void initState() {
    super.initState();

    // Start listening to changes.
    // usernameTFController.addListener(_printLatestValue);
  }

  // dispose()
  // - on destroy hook/method of this class
  @override
  void dispose() {
    usernameTFController.dispose();
    passwordTFController.dispose();
    super.dispose();
  }

  // CLASS METHODS
  // - All methods and functions for this class

  void togglePassword() {
    setState(() {
      if (passwordVisible) {
        passwordVisible = false;
        passwordIcon = Icon(Icons.visibility);
      } else {
        passwordVisible = true;
        passwordIcon = Icon(Icons.visibility_off);
      }
    });
  }

  Future<http.Response> loginEmployee() async {
    final response = await http.post(
      '${AppGlobalConfig.server}/employee/v1/login',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': this.username,
        'password': this.password,
      }),
    );
    setState(() {
      isLoading = false;
    });
    print(response.body);
    if (response.statusCode == 200) {
      final Map<String, dynamic> result = jsonDecode(response.body);
      final record = result['record'];
      final accessToken = record['access_token'];
      final rawAccount = record['employee'];
      AccountModel.fromJson(rawAccount);
      localStorage.setString('accessToken', accessToken);
      Navigator.of(context).pushReplacementNamed(
        '/home',
      );
      return response;
    } else {
      showAlertDialog(context, 'Oops!', 'Username or password is incorrect!');
      return response;
    }
  }

  void onLogin() {
    final isUsernameValid = _usernameKey.currentState.validate();
    final isPasswordValid = _passwordKey.currentState.validate();
    if (isUsernameValid && isPasswordValid) {
      isLoading = true;
      loginEmployee();
    }
  }

  // BUILD METHOD
  // - Builds the widget to display [equivalent to on render in other frameworks]
  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    PageModel data = widget.data;
    final Color textColor = Theme.of(context).primaryColor;
    final TextStyle textFieldStyle =
        TextStyle(fontSize: 18.0, color: textColor);

    TextFormField usernameTextField = TextFormField(
      controller: usernameTFController,
      key: _usernameKey,
      enabled: !isLoading,
      textInputAction: TextInputAction.next,
      onEditingComplete: () => node.nextFocus(),
      onChanged: (text) {
        setState(() {
          this.username = text;
          _usernameKey.currentState.validate();
        });
      },
      decoration: getInputDecoration(context: context, label: 'Username'),
      style: textFieldStyle,
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter your username!';
        }
        return null;
      },
    );

    TextFormField passwordTextField = TextFormField(
      enabled: !isLoading,
      key: _passwordKey,
      controller: passwordTFController,
      textInputAction: TextInputAction.done,
      onEditingComplete: () {
        onLogin();
        node.unfocus();
      },
      obscureText: !passwordVisible,
      enableSuggestions: false,
      autocorrect: false,
      onChanged: (text) {
        setState(() {
          this.password = text;
          _passwordKey.currentState.validate();
        });
      },
      decoration: getInputDecoration(
          context: context,
          label: 'Password',
          suffixIcon: IconButton(
              icon: passwordIcon,
              color: Theme.of(context).primaryColor,
              enableFeedback: true,
              onPressed: () {
                togglePassword();
              })),
      style: textFieldStyle,
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter your password!';
        }
        return null;
      },
    );

    Container loginButton = Container(
        height: 50,
        child: ElevatedButton(
          onPressed: loginButtonDisabled
              ? null
              : () {
                  onLogin();
                },
          child: isLoading
              ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
              : Text(
                  "Login",
                  style: TextStyle(fontSize: 20.0),
                ),
        ));

    return Scaffold(
        key: scaffoldKey,
        body: ContainerWithBlurBackground(
          contentWidget: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: Center(
                child: Container(
                  constraints: BoxConstraints(minWidth: 380, maxWidth: 400),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.fromLTRB(10, 46, 10, 10),
                          child: Logo(width: 100, height: 100)),
                      ListTile(
                        title: Text(
                          data.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 30.0),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Form(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: usernameTextField),
                              Padding(
                                padding: EdgeInsets.all(5.0),
                                child: passwordTextField,
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              loginButton,
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
