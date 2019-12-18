import 'package:flutter_plugin_playground/pages/card_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin_playground/pages/app_view.dart';
import 'package:flutter_plugin_playground/pages/sign_in_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


/*
  Main page for mobile application
 */
void main() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLogged = (prefs.getBool('isLogged') ?? false);

  //shows different page depending on whether or not an account is logged in
  var home;
  if(isLogged)
    home = app_view();
  else
    home = LoginPage() ;

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Clear Orbit Prototype',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: home,
    routes:{
      '/login':(context) => LoginPage(),
      '/main':(context) => app_view(),
      '/card':(context) => new card_view(),
    },
  )
  );
}