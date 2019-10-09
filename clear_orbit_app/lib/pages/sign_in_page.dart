import 'package:flutter/material.dart';
import 'package:clear_orbit_app/services/account_sign_in.dart';

class LoginPage extends StatefulWidget {
  @override
  _ListPageState createState() {
    return _ListPageState();
  }
}

class _ListPageState extends State<LoginPage> {
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
                Image.asset("assets/lock.png",
                scale: 1.5),
                SizedBox(height: 30.0,),
                Text('Clear Orbit',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40
                ),)
              ],
            ),
            SizedBox(height: 100.0),
            TextField(
              decoration: InputDecoration(
                labelText: 'Username',
                filled: true,
              ),
            ),
            SizedBox(height: 12.0),
            TextField(
              decoration: InputDecoration(
                labelText: 'Password',
                filled: true,
              ),
              obscureText: true,
            ),
            FlatButton(
              child: Text('Sign In'),
              onPressed: (){
                Navigator.pushNamedAndRemoveUntil(context, '/main', (Route<dynamic> route) => false);
              },
            )
          ],
        ),
      )
    );
  }

}

