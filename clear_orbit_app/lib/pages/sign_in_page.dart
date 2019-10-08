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
      appBar: AppBar(
          title: Text('Clear Orbit'), 
          centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            SizedBox(height: 80.0),
            Column(
              children: <Widget>[
                Image.asset("code_planet_logo.jpg"),
                SizedBox(height: 20.0,),
                Text('Clear Orbit')
              ],
            ),
            SizedBox(height: 120.0),
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

