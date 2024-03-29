/*import 'package:clear_orbit_app/services/API.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';*/
import 'package:clear_orbit_app/services/API.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:clear_orbit_app/services/glass_support.dart';
//import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';

//List<CameraDescription> cameras;



class camera_view extends API {
  @override
  Camera_viewState createState() => new Camera_viewState();
}

class Camera_viewState extends APIState {
  //Need a client call
  //Method that gets image path from server and returns image 
  File _image;


  Future getImage() async{
    //if statement Mobile Camera Source or Image file from bluetooth server
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
      //Temp code for request. Need help from Andrew for implementing API Class
      if (_image == null) return;
      String base64Image = base64Encode(_image.readAsBytesSync());
      String fileName = _image.path.split("/").last;
      http.post('http://54.166.243.43:8080/photocomparsion', body: {
     "image": base64Image,
     "name": fileName,
        }).then((res) {
              print(res.body);
                }).catchError((err) {
                              print(err);
                                        });
 
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