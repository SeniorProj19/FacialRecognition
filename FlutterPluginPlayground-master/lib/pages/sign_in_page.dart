import 'dart:developer';

import 'package:flutter_plugin_playground/services/API.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin_playground/services/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;

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

    print("Printing Statement: " + responseData.toString()); // Where is response data coming from

    usernum = await responseData["data"]["user_id"];

    sharedPreferences.setInt("usernum", usernum);

    await getUser(usernum);
    print("done getUser()");

    await getConnections(usernum);

    await saveInfo();

    // navigate to ProfilePage
    print("logged in");
    sharedPreferences.setBool("isLogged", true);
    Navigator.pushReplacementNamed(context, '/main') ;
  }

  void saveInfo() async {
    print("saving info");
    sharedPreferences.setString("first_name", responseData2["first_name"]);
    sharedPreferences.setString("last_name", responseData2["last_name"]);
    sharedPreferences.setString("company", responseData2["curr_company"]);
    sharedPreferences.setString("job_title", responseData2["job_title"]);
    sharedPreferences.setString("email", responseData2["email"]);
    sharedPreferences.setString("base64Image", responseData2["profile_pic"]);
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
              SizedBox(height: 20.0),
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
                onPressed: runPlayground,//.submit,
                child: Text('Sign In', style: TextStyle(color: Colors.white),),
                color: Color.fromRGBO(46, 108, 164, 1),
              ),
            ],
          ),
        )
    );
  }

  void runPlayground() async {
    var testResult = await channel.invokeMethod("test");

    setState(() {
      log(testResult);
    });
  }

}
