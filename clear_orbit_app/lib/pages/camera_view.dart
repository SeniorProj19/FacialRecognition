/*import 'package:clear_orbit_app/services/API.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';*/

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
//import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';

//List<CameraDescription> cameras;

class camera_view extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new camera_viewState();
}

class camera_viewState extends State<camera_view> {
  File _image;

  Future getImage() async{
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });
  }

  @override

  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      home: new Scaffold(
    body: new Center(
      child: _image == null? new Text("No Image Selected"): new Image.file(_image),
    ),
        floatingActionButton: new FloatingActionButton(onPressed: getImage,
        tooltip: 'Pick Image',
        child: new Icon(Icons.camera),),
    ));
  }
}

/*
class camera_view extends API{


  @override
  camera_view_state createState() => camera_view_state();
}

class camera_view_state extends APIState {
  SharedPreferences sharedPreferences;

  String username;

  void setData() async {
    sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      username = sharedPreferences.getString("username") ?? "Error";
    });
  }

  @override
  Widget build(BuildContext context) {

    setData();

    return Column(
      children: <Widget>[
        Text("This is the camera view"),
        Text(username),
        //Text(password)
      ],
    );
  }

}*/