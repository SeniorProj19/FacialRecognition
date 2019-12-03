/*import 'package:clear_orbit_app/services/API.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';*/
import 'dart:math';

import 'package:flutter_plugin_playground/services/main.dart';
import 'package:flutter_plugin_playground/services/API.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future checkDir() async{
    runPlayground();
    //20191202_064624.jpg
    String pafth = '/storage/emulated/0/ClearOrbit/COpic.jpg';
    if (await File(pafth).existsSync()){
      File image = new File(pafth);
      usernum = sharedPreferences.getInt("usernum");
      //usernum = await responseData["user_id"];
      //showPrev(image);
      setState(() {
        print(usernum.toString());

        _image = image;
        print(_image.path);
        //Temp code for request. Need help from Andrew for implementing API Class
        if (_image == null) return;
        String base64Image = base64Encode(_image.readAsBytesSync());
        String fileName = _image.path.split("/").last;
        String route = 'http://54.163.9.99:8080/photocomparsion/'+usernum.toString();
        print(route);
        http.post(route, body: {
          "image": base64Image,
          "name": fileName,
        }).then((res) {
          print(res.body);
          var data = json.decode(res.body);
          var match = data['match'];
          if(match == null)
            matchNotfoundDialog();
          else
            matchFounddialog(match);
        }).catchError((err) {
          print(err);
        });

      });
    }
    else
      print('no');
  }

  Future matchFounddialog(name){
    return showDialog(context: context,
        builder: (BuildContext context){
          return SimpleDialog(title: Text('You Matched With $name. Check Your Connections'));
        });

  }
  Future showPrev(image){
    return showDialog(context: context,
        builder: (BuildContext context){
          return SimpleDialog(title:Image.file(image));
        });}
  Future matchNotfoundDialog(){
    return showDialog(context: context,
        builder: (BuildContext context){
          return SimpleDialog(title: Text('Match Not Found'));
        });
  }

  getImage() async{

    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    this.setState(() {
      _image = image;
      //Temp code for request. Need help from Andrew for implementing API Class
      if (_image == null) return;
      String base64Image = base64Encode(_image.readAsBytesSync());
      String fileName = _image.path.split("/").last;
      http.post('http://54.163.9.99:8080/photocomparsion', body: {
        "image": base64Image,
        "name": fileName,
      }).then((res) {
        var data = json.decode(res.body);
        var match = data['match'];
        if(match == null)
          matchNotfoundDialog();
        else
          matchFounddialog(match);
      }).catchError((err) {
        print(err);
      });

    });
  }

  test() async{
    print('Top');
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    print(image.path);
    if(image == null)
      print('no picture');
    this.setState((){
      _image = image;
    });
    showPreview(image);
  }
  Future<void> showPreview(image){
    return showDialog(context: context,
        builder: (BuildContext context){
          return SimpleDialog(title: Image.file(image));
        });
  }
  @override

  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
        home: new Scaffold(
          body: new Center(
              child: new FlatButton(onPressed:(){
                //checkDir()
                print('Tedt');
                runPlayground();
              }, child: Text('Check For Matches', style: TextStyle(color: Colors.white),),
                color: Color.fromRGBO(46, 108, 164, 1),)
          ),
          floatingActionButton: new FloatingActionButton(onPressed:test,
            tooltip: 'Pick Image',
            child: new Icon(Icons.camera),),
        ));
  }
  void runPlayground() async {
    print('t');
    var testResult = await channel.invokeMethod("test");

    setState(() {
      //log(testResult);
    });
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
