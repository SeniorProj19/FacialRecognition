import 'package:clear_orbit_app/pages/card_view.dart';
import 'package:flutter/material.dart';
import 'package:clear_orbit_app/pages/app_view.dart';
import 'package:clear_orbit_app/pages/sign_in_page.dart';
import 'package:clear_orbit_app/pages/card_view.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Clear Orbit Prototype',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
      routes:{
        '/login':(context) => LoginPage(),
        '/main':(context) => app_view(),
        '/card':(context) => new card_view(),
      },
    );
  }
}