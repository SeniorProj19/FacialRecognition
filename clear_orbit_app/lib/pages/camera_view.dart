//import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class camera_view extends StatefulWidget{


  @override
  camera_view_state createState() => camera_view_state();
}

class camera_view_state extends State<camera_view> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text("This is the camera view")
      ],
    );
  }

}