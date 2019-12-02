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

    setState(() {

    });
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
                        accountList[index].first_name + " " + accountList[index].last_name,
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
                              accountList[index].job,
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