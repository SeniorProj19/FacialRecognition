import 'package:flutter/material.dart';

class connections_view extends StatefulWidget{
  @override
  connections_view_state createState() => connections_view_state();
}

class connections_view_state extends State<connections_view> {
  final List<String> entries = <String>['A', 'B', 'C'];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.only(top: 20.0),
      itemCount: entries.length,
      itemBuilder: (BuildContext context, int index){
        return Container(
          height: 50,
          color: Colors.blue,
          child: Center(child: Text(entries[index]),),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }

}