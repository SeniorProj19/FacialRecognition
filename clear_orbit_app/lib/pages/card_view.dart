import 'package:flutter/material.dart';

class card_view extends StatefulWidget{
  @override
  card_view_state createState() => card_view_state();
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
                  "AW",
                style: TextStyle(fontSize: 70),
                ),
                radius: 100,
              ),
            ),
            Container(
              child: Column(
                children: <Widget>[
                  Text(
                    "Andrew Weatherby",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 35
                    ),
                  ),
                  Text(
                    "Veracity Engineering",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25
                    ),
                  ),
                  Text(
                    "Summer-Fall Intern",
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
                    "andrew-h-weatherby",
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
                  "weatherba0@students.rowan.edu",
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