import 'package:flutter_plugin_playground/pages/card_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin_playground/pages/app_view.dart';
import 'package:flutter_plugin_playground/pages/sign_in_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLogged = (prefs.getBool('isLogged') ?? false);

  var home;
  if(isLogged)
    home = app_view();
  else
    home = LoginPage() ;

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Clear Orbit',
    theme: ThemeData(
      primaryColor: Colors.black
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