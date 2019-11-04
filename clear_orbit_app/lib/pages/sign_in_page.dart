import 'package:clear_orbit_app/services/API.dart';
import 'package:flutter/material.dart';
import 'package:clear_orbit_app/services/account_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert' as convert;
//import 'API.dart';

class LoginPage extends API {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends APIState {


  String URL;
  String URLSuffix = "mlogin";
  String appBarTitle = "Login";

  var messages = {
    "success" : {"dialogHead":"","dialogMessage":""} ,
    "failure" : {"dialogHead" : "Login error"}
  } ;

  @override
  void onDialogPressed() {
    if(success == false)
      Navigator.pop(context);
  }

  @override
  onSuccess() async {
    // When login success, save the data ,

    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool("isLogged", true);

    print("Printing Statement: " + responseData["data"]["user"]); // Where is response data coming from

    sharedPreferences.setString("username", responseData["data"]["user"]);
    //sharedPreferences.setString("fullname", responseData["data"]["user"]["fullname"]);
    //sharedPreferences.setString("email", responseData["data"]["user"]["email"]);

    // navigate to ProfilePage
    Navigator.pushReplacementNamed(context, '/main') ;
  }

  @override
  Map<String, String> getBody() {
    return {"username": username, "password": password};
  }

  @override
  Widget getForm() {
    return new Form(
        key: formKey,
        child: Container(
          padding: const EdgeInsets.all(32.0),
          child: new Column(
            children: <Widget>[
              SizedBox(height: 80.0),
              Column(
                children: <Widget>[
                  Image.asset("assets/lock.png", scale: 1.5),
                  SizedBox(
                    height: 30.0,
                  ),
                  Text(
                    'Clear Orbit',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
                  )
                ],
              ),
              SizedBox(height: 20.0),
              new SizedBox(
                height: 80.0,
                child: TextFormField(
                  decoration: InputDecoration(labelText: "Username"),
                  validator: (value) {
                    return value.isNotEmpty ? null : "Empty Username";
                  },
                  onSaved: (val) => username = val,
                ),
              ),
              new SizedBox(
                height: 90.0,
                child: TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(labelText: "Password"),
                    validator: (value) {
                      return value.isNotEmpty ? null : "Empty Password";
                    },
                    onSaved: (val) => password = val),
              ),
              new FlatButton(
                onPressed: super.submit ,
                child: Text('Sign In', style: TextStyle(color: Colors.white),),
                color: Color.fromRGBO(46, 108, 164, 1),
              ),
            ],
          ),
        )
    );
  }

}