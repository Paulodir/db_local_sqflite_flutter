import 'package:flutter/material.dart';
import 'ui/home.dart';
import 'ui/login.dart';
import 'helper/login_helper.dart';

void main() async{
  LoginHelper helper = LoginHelper();

  int logado = await helper.getLogado();

  runApp(MaterialApp(
      home: (logado>0)?HomePage(logado):LoginPage(),
      debugShowCheckedModeBanner: false,
    ));


}


