import 'package:flutter/material.dart';
import 'package:clear_orbit_app/pages/camera_view.dart';
import 'package:clear_orbit_app/pages/connections_view.dart';
import 'package:clear_orbit_app/pages/card_view.dart';

class app_view extends StatelessWidget {

  final PageController controller = new PageController();

  //List of pages
  final List<Widget> widgetList = <Widget> [
    connections_view(),
    camera_view(),
    card_view()
  ];

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
          )
        ],
      ),
      body: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          PageView.builder(
              physics: ClampingScrollPhysics(),
              itemCount: widgetList.length,
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