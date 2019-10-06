import 'package:flutter/material.dart';
import 'package:clear_orbit_app/pages/app_view.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clear Orbit Prototype',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: app_view(),
    );
  }
}