import 'dart:developer';

import 'package:flutter_plugin_playground/services/API.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin_playground/pages/camera_view.dart';
import 'package:flutter_plugin_playground/pages/connections_view.dart';
import 'package:flutter_plugin_playground/pages/card_view.dart';
import 'package:flutter_plugin_playground/services/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class app_view extends API {
  @override
  _app_view_state createState() => _app_view_state();
}

class _app_view_state extends APIState {

  final PageController controller = new PageController(initialPage: 1);
  int bottomSelectedIndex = 1;

  //List of pages
  final List<Widget> widgetList = <Widget> [
    connections_view(),
    camera_view(),
    card_view()
  ];

  void pageChanged(int index) {
    setState(() {
      bottomSelectedIndex = index;
    });
  }

  void bottomTapped(int index) {
    setState(() {
      bottomSelectedIndex = index;
      controller.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  void _logout() async {
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool("isLogged", false);
    Navigator.of(context).pushReplacementNamed('/login');
  }
  void runPlayground() async {
    var testResult = await channel.invokeMethod("test");
    setState(() {
      log(testResult);
    });
  }

  @override
  Widget build(BuildContext context) {
    //runPlayground();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Clear Orbit'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.clear),
            tooltip: 'Sign Out',
            onPressed: _logout,
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: bottomSelectedIndex,
        onTap: (index) {
          bottomTapped(index);
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.people,color: Color.fromARGB(255, 0, 0, 0)),
            title: new Text('Connections'),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.home,color: Color.fromARGB(255, 0, 0, 0)),
              title: new Text('Home')
          ),

          BottomNavigationBarItem(
              icon: Icon(Icons.person,color: Color.fromARGB(255, 0, 0, 0)),
              title: new Text('My Card')
          )
        ],
      ),
      body: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          PageView.builder(
              physics: ClampingScrollPhysics(),
              itemCount: widgetList.length,
              onPageChanged: (index){
                pageChanged(index);
              },
              controller: controller,
              itemBuilder: (context, index){
                return widgetList[index];
              }
          ),
        ],
      ),
    );
  }
}
