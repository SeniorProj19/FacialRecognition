import 'package:flutter/material.dart';

class card_view extends StatefulWidget{
  @override
  card_view_state createState() => card_view_state();
}

class card_view_state extends State<card_view > {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text("This is the card view")
      ],
    );
  }

}