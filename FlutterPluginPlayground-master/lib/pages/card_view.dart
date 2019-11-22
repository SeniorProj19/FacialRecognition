import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_plugin_playground/services/API.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class card_view extends API {
  @override
  card_view_state createState() => card_view_state();
}

class card_view_state extends APIState {
  SharedPreferences sharedPreferences;

  String email;

  String username;

  String fullname;

  @override
  void initState() {
    setData();
  }

  @override
  onSuccess() async {
    // When login success, save the data ,

    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool("isLogged", true);

    print("Printing Statement: " +
        responseData.toString()); // Where is response data coming from

    sharedPreferences.setString("username", responseData["first_name"]);
    sharedPreferences.setInt("usernum", responseData["user_id"]);

    //getUser(); //causing an error
    //getGetResponse('http://54.166.243.43:8080/'+usernum.toString());
    //'http://54.166.243.43:8080/'+usernum.toString()

    // navigate to ProfilePage
    Navigator.pushReplacementNamed(context, '/main');
  }

  void setData() async {
    sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      username = sharedPreferences.getString("username") ?? "Error";
      first_name = sharedPreferences.getString("first_name") ?? "Error";
      last_name = sharedPreferences.getString("last_name") ?? "Error";
      email = sharedPreferences.getString("email") ?? "";
      company = sharedPreferences.getString("company") ?? "";
      job_title = sharedPreferences.getString("job_title") ?? "";
      base64Image = sharedPreferences.getString("base64Image") ?? "";
      imageInBytes = base64.decode(base64Image);
    });
  }

  void _logout() async {
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool("isLogged", false);
    Navigator.of(context).pushReplacementNamed('/login');
  }

  Widget getRow(String string, double textSize, double opacity) {
    return Opacity(
      opacity: opacity,
      child: new Container(
        margin: const EdgeInsets.only(top: 20.0),
        child: new Text(
          string,
          style: new TextStyle(color: Colors.white, fontSize: textSize),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
      return Container(
        child: Container(
          margin: EdgeInsets.all(15.0),
          color: Colors.black,
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(20.0),
                child: CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Image.memory(imageInBytes),
                  radius: 100,
                ),
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    Text(
                      first_name + " " + last_name,
                      style: TextStyle(color: Colors.white, fontSize: 35),
                    ),
                    Text(
                      company,
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                    Text(
                      job_title,
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Container(
                margin: EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      "LinkedIn",
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                    Text(
                      "null",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      "Email",
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                    Text(
                      email,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
  }
}
