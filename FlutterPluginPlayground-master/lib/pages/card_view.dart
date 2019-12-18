import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_plugin_playground/services/API.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

//User's info page
//Andrew Weatherby
class card_view extends API {
  @override
  card_view_state createState() => card_view_state();
}

class card_view_state extends APIState {
  //locally saved data
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

    //retrieve locally saved data and put it into variables
    setState(() {
      username = sharedPreferences.getString("username") ?? "Error";
      first_name = sharedPreferences.getString("first_name") ?? "Error";
      last_name = sharedPreferences.getString("last_name") ?? "Error";
      usernum = sharedPreferences.getInt("usernum") ?? -1;
      email = sharedPreferences.getString("email") ?? "";
      company = sharedPreferences.getString("company") ?? "";
      job_title = sharedPreferences.getString("job_title") ?? "";
      base64Image = sharedPreferences.getString("base64Image") ?? "";

      //try to read in photo
      try{
        imageInBytes = base64.decode(base64Image);
      } on Exception catch (_){
        imageInBytes;
      }

    });
  }

  //log out functionality
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

  //Build Page
  //Issue reading in photos
  //build cases for each
  @override
  Widget build(BuildContext context) {
    //If can read photo use this
    if(imageInBytes != null)
      return Container(
        child: Container(
          margin: EdgeInsets.all(15.0),
          color: Colors.black,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20.0),
                child: SizedBox(
                    height: 300,
                    width: 300,
                    child: Image.memory(imageInBytes, fit: BoxFit.contain,)
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

    //if cant read photo, use this
    else
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
                  child: Text(first_name.substring(0,1) + last_name.substring(0,1),
                    style: TextStyle(fontSize: 70),),
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
              /*Container(
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
              ),*/
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
