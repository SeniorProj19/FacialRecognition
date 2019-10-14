import 'package:clear_orbit_app/services/global.dart';
import 'package:flutter/material.dart';
import 'package:clear_orbit_app/models/account.dart';

class connections_view extends StatefulWidget{
  @override
  connections_view_state createState() => connections_view_state();
}

class connections_view_state extends State<connections_view> {
  final List<Account> entries = getAccounts();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.only(top: 20.0),
      itemCount: entries.length,
      itemBuilder: (BuildContext context, int index){
        return Card(
          elevation: 8.0,
          margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: Container(
            decoration: (
            BoxDecoration(color: Colors.black)),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  leading: Container(
                    padding: EdgeInsets.only(right: 12.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Text(
                        entries[index].name_first.substring(0,1)+entries[index].name_last.substring(0,1),
                      ),
                    ),
                  ),
                  title: Text(entries[index].name_first + " " + entries[index].name_last,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    entries[index].company + " - " + entries[index].title,
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
                    onPressed: (){
                      account_viewing = entries[index];
                      Navigator.pushNamed(context, '/card');
                    }
                  ),
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }

}

List<Account> getAccounts(){
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