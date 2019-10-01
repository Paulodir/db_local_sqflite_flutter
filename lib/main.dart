import 'package:flutter/material.dart';
import 'ui/home.dart';
import 'ui/LoginScreen.dart';
import 'package:flutter/services.dart';
import 'helper/login_helper.dart';

void main() async{
  LoginHelper helper = LoginHelper();

  int logado = await helper.getLogado();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);

  runApp(
      MaterialApp(
      home: (logado>0)?HomePage(logado):LoginScreen(),
      debugShowCheckedModeBanner: false,
    ));


}


