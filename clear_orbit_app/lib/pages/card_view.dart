import 'package:clear_orbit_app/services/global.dart';
import 'package:flutter/material.dart';
import 'package:clear_orbit_app/models/account.dart';

class card_view extends StatefulWidget{
  @override
  card_view_state createState() => card_view_state();
}

class CardArguments {
  final Account account;

  CardArguments(this.account);
}

class card_view_state extends State<card_view > {

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
                child: Text(
                  account_signedin.getInitials(),
                style: TextStyle(fontSize: 70),
                ),
                radius: 100,
              ),
            ),
            Container(
              child: Column(
                children: <Widget>[
                  Text(
                    account_signedin.name_first + " " + account_signedin.name_last,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 35
                    ),
                  ),
                  Text(
                    account_signedin.company,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25
                    ),
                  ),
                  Text(
                    account_signedin.title,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25
                    ),
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
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25
                    ),
                  ),
                  Text(
                    account_signedin.account_linkedin,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20
                    ),
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
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25
                  ),
                  ),
                  Text(
                    account_signedin.account_email,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20
                    ),
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