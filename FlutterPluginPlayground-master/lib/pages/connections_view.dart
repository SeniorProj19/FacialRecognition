import 'package:flutter_plugin_playground/services/API.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin_playground/models/account.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:expandable/expandable.dart';

class connections_view extends API {
  @override
  connections_view_state createState() => connections_view_state();
}

class connections_view_state extends APIState {
  @override
  void initState() {
    print("Connections View of " + usernum.toString());
    setData();
  }

  void setData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    usernum = sharedPreferences.getInt("usernum") ?? -1;

    await getConnections(usernum);

    accountList = AccountsList.fromJson(responseData3).accounts;

    accountList;

    for (Account user in accountList) {
      print(user.email);
      print(user.first_name);
      print(user.last_name);
      print(user.company);
      print(user.job);
    }

    setState(() {});
  }

  @override
  onSuccess() async {}

  @override
  Widget build(BuildContext context) {
    if (accountList == null)
      return Center(
        child: Container(
          alignment: Alignment.center,
          child: Text("Make Some Connections!"),
        ),
      );
    else
      return ListView.separated(
        padding: const EdgeInsets.only(top: 20.0),
        itemCount: accountList.length,
        itemBuilder: (BuildContext context, int index) {
          base64Image = accountList[index].base64Image;
          try {
            imageInBytes = base64.decode(base64Image);
            accountList[index].loaded = true;
          } on Exception catch (_) {
            imageInBytes;
          }


          Widget userid;
          if (accountList[index].loaded)
            userid = Container(
              padding: EdgeInsets.only(right: 12.0),
              child: SizedBox(
                  height: 80,
                  width: 80,
                  child: Image.memory(
                    imageInBytes,
                    fit: BoxFit.contain,
                  )),
            );
          else
            Container(
              padding: EdgeInsets.only(right: 12.0),
              child: CircleAvatar(
                backgroundColor: Colors.black,
                child: Text(accountList[index].first_name.substring(0, 1) +
                    accountList[index].last_name.substring(0, 1),style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            );

          List <Widget> children = [];

          Account temp = accountList[index];
          if(temp.about != "")
            children.add(Padding(
              padding: EdgeInsets.only(top: 15, bottom: 5),
              child: Text(
                accountList[index].about,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ));
          if(temp.age != 0 || temp.age != "")
            children.add(Text(
              'Age: '+ accountList[index].age.toString(),
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ));

          if(temp.job != "" && temp.company != "")
            children.add(Text(
              'Occupation: ' + accountList[index].job + " at " + accountList[index].company,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ));
          else if(temp.job != "")
            children.add(Text(
              'Occupation: ' + accountList[index].job,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ));
          else
            children.add(Text(
              'Company: ' + accountList[index].company,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ));

          if(temp.education != "")
            children.add(Text(
              'Education: '+ accountList[index].education,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ));
          if(temp.email != "")
            children.add(Text(
              'Email: ' + accountList[index].email,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ));


          if(temp.city != "" && temp.state != "")
            children.add(Text(
              'Location: ' + accountList[index].city + ", " + accountList[index].state,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ));
          else if(temp.city != "")
            children.add(Text(
              'Location: ' + accountList[index].city,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ));
          else
            children.add(Text(
              'Location: ' + accountList[index].state,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ));


          return Card(
            color: Color.fromRGBO(46, 108, 164, 1),
            child: Padding(
              padding: EdgeInsets.only(
                  top: 15.0, left: 6.0, right: 6.0, bottom: 15.0),
              child: ExpansionTile(
                leading: userid,
                title: Text(
                  accountList[index].first_name + " " + accountList[index].last_name,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                trailing: Icon(Icons.info_outline),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: children
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      );
  }
}
