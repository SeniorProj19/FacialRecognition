import 'package:flutter_plugin_playground/pages/card_view.dart';
import 'package:flutter_plugin_playground/services/API.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin_playground/models/account.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:expandable/expandable.dart';

class connections_view extends API {
  @override
  connections_view_state createState() => connections_view_state();
}

class connections_view_state extends APIState {
  @override
  void initState() {
    setData();
  }

  void setData() async {
    sharedPreferences = await SharedPreferences.getInstance();

    setState(() {});
  }

  @override
  onSuccess() async {
    /*
    // When login success, save the data ,

    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool("isLogged", true);

    print("Printing Statement: " +
        responseData.toString()); // Where is response data coming from

    sharedPreferences.setString("username", responseData["first_name"]);
    sharedPreferences.setInt("usernum", responseData["user_id"]);

    //getUser(); //causing an error
    //getGetResponse('http://54.166.243.43:8080/'+usernum.toString());
    //'http://54.166.243.43:8080/'+usernum.toString()

    // navigate to ProfilePage
    Navigator.pushReplacementNamed(context, '/main');
    */
  }

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
          return ExpandableNotifier(
              child: ScrollOnExpand(
            scrollOnExpand: false,
            scrollOnCollapse: true,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Card(
                color: Colors.black,
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: <Widget>[
                    ListTile(
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      leading: Container(
                        padding: EdgeInsets.only(right: 12.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Text("FS"),
                        ),
                      ),
                      title: Text(
                        accountList[index].fullname,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        accountList[index].company,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ScrollOnExpand(
                      scrollOnExpand: true,
                      scrollOnCollapse: false,
                      child: ExpandablePanel(
                        tapHeaderToExpand: true,
                        tapBodyToCollapse: true,
                        headerAlignment: ExpandablePanelHeaderAlignment.center,
                        header: Padding(
                          padding: EdgeInsets.all(10),
                        ),
                        //collapsed: Text('hello', softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis,),
                        expanded: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Email',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              accountList[index].email,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'LinkedIn',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              accountList[index].username,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        builder: (_, collapsed, expanded) {
                          return Padding(
                            padding: EdgeInsets.only(
                                left: 10, right: 10, bottom: 10),
                            child: Expandable(
                              collapsed: collapsed,
                              expanded: expanded,
                              crossFadePoint: 0,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ));
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      );
  }
}

/*
List<Account> getTestAccounts(){
  return[
    Account(
      name_first:"Andrew",
      name_last:"Weatherby",
      company:"Veracity Engineering",
      title: "Intern",
      account_email: "weatherba0@students.rowan.edu",
      account_linkedin: "andrew-weatherby"
    ),
    Account(
        name_first:"Shafin",
        name_last:"Siraj",
        company:"Lockheed Martin",
        title: "Manager",
        account_email: "sirajs8@students.rowan.edu",
        account_linkedin: "shafin-siraj"
    ),
    Account(
        name_first:"Tyler",
        name_last:"Fung",
        company:"NASA",
        title: "Programmer",
        account_email: "fungt5@students.rowan.edu",
        account_linkedin: "tyler-fung"
    ),
    Account(
        name_first:"Dan",
        name_last:"Vega",
        company:"Google",
        title: "Programmer",
        account_email: "vegad8@students.rowan.edu",
        account_linkedin: "dan-vega"
    ),
    Account(
        name_first:"EJ",
        name_last:"Pellot",
        company:"Google",
        title: "Programmer",
        account_email: "edwinpellot0110@gmail.com",
        account_linkedin: "E-J"
    ),
    Account(
        name_first:"Vince",
        name_last:"Williams",
        company:"Google",
        title: "Programmer",
        account_email: "williamsv8@students.rowan.edu",
        account_linkedin: "vince-williams"
    ),
  ];
}
*/
