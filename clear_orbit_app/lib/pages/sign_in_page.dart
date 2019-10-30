import 'package:flutter/material.dart';
import 'package:clear_orbit_app/services/account_sign_in.dart';


class LoginPage extends StatefulWidget {
  @override
  _ListPageState createState() {
    return _ListPageState();
  }
}

class _ListPageState extends State<LoginPage> {
  TextEditingController  usernameController = new TextEditingController(); 
  TextEditingController  passwordController = new TextEditingController();
  bool _password = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
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
          SizedBox(height: 75.0),
          Visibility(
            visible: _password,
            child: Padding(
            padding: EdgeInsets.only(bottom: 15.0),
            child: Text(
              "Username or Password is incorrect",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red, fontSize: 17),
            ),
          ),),
          TextField(
            controller: usernameController,
            decoration: InputDecoration(
              labelText: 'Username',
              filled: true,
            ),
          ),
          SizedBox(height: 12.0),
          TextField(
            controller: passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
              filled: true,
            ),
            obscureText: true,
          ),
          FlatButton(
            child: Text('Sign In', style: TextStyle(color: Colors.white),),
            color: Color.fromRGBO(46, 108, 164, 1),
            onPressed: () async {
              Post newPost = new Post(
                username: this.usernameController.text,
                password: this.passwordController.text);
              Post info = await fetchPost(body: newPost.toMap());
              
              Navigator.pushNamedAndRemoveUntil(
                  context, '/main', (Route<dynamic> route) => false);
              // } else
              // setState(() {
              //   _password = false;
              // });
            },
          )
        ],
      ),
    ));
  }
}
