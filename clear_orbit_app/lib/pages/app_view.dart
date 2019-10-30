import 'package:clear_orbit_app/services/global.dart';
import 'package:flutter/material.dart';
import 'package:clear_orbit_app/pages/camera_view.dart';
import 'package:clear_orbit_app/pages/connections_view.dart';
import 'package:clear_orbit_app/pages/card_view.dart';
import 'package:clear_orbit_app/services/global.dart';

class app_view extends StatefulWidget {
  @override
  _app_view_state createState() => _app_view_state();
}

class _app_view_state extends State<app_view> {

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

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Clear Orbit Prototype'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.clear),
            tooltip: 'Sign Out',
            onPressed: (){},
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