import 'package:clear_orbit_app/services/API.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

}