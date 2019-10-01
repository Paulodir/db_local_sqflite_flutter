import 'dart:async';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import '../helper/login_helper.dart';
import 'LoginScreen.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginHelper helper = LoginHelper();
  List<Login> login = List();

  @override
  Widget build(BuildContext context) {
    return LoginScreen();
  }
}
