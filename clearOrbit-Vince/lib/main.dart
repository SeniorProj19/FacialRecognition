import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:async';
import 'dart:io';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

void main() => runApp(MyApp());


List previousUsers = ["John Doe", "Jane Doe", "Macaulay Culkin", "Steve Jobs", "Gary Vaynerchuk", "Gordan Ramsay"];
List userImage = ["assets/John.jpg", "assets/jane.jpg", "assets/Culkin.jpg", "assets/jobs.jpg", "assets/Gary.jpg", "assets/ramsay.jpg"];
List userBio = ["College Student \n Lawyer in the Making", "Model \n Step 1 a stock photo, Step 2 Covergirl", "Actor \n Star of Home Alone", "CEO of Apple \n Let's create the Tech of the future!", "Marketing Guru \n With solid marketing you can sell anything!", "Chef and Tv Personality \n It's important to always provide the best food to all customers."];


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: "Clear Orbit",
      ),

    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _cIndex = 0;
  final List<Widget> _children = [
    UserList(),
    //CameraState(),
    Set(),
    //Settings(),
  ];

  void _incrementTab(index) {
    setState(() {
      _cIndex = index;
    });
  }



  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      /*appBar: new AppBar(
        title: new Text(widget.title),
          actions: <Widget>[
        new RaisedButton(

        onPressed: () {
          showAlertDialog(context);
        },
        child: new Text("Sign out",),
    ),
      ]),*/
      body:_children[_cIndex],

      bottomNavigationBar:BottomNavigationBar(
        onTap: _incrementTab,
        currentIndex: _cIndex,

        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home,color: Color.fromARGB(255, 0, 0, 0)),
              title: new Text('Home')
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.face,color: Color.fromARGB(255, 0, 0, 0)),
              title: new Text('Connections'),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings,color: Color.fromARGB(255, 0, 0, 0)),
              title: new Text('Settings')
          )
        ],

      ),

    );
  }
}

class UserList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    print("User List");

    return new Scaffold(
        appBar: new AppBar(
          title: new Text("User List"),
            backgroundColor: Colors.blue,
          actions: <Widget>[
            new RaisedButton(

              onPressed: () {
                showAlertDialog(context);
              },
              child: new Text("Sign out",),
            ),
          ]
        ),
        body:
        ListView.builder(
            itemCount: previousUsers.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                  child: ListTile(
                      title: Text(previousUsers[index]),
                      trailing: Icon(Icons.keyboard_arrow_right),
                      leading: new Image.asset(userImage[index], height: 50, width: 50),//(image: AssetImage(userImage[index], height: 20, width: 20)),
                      onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                            new UserPage(previousUsers[index], userBio[index], userImage[index])));
                  }
                  )
              );
            }
        )
    );
  }

}

class UserPage extends StatelessWidget {

  final String name;
  final String Description;
  final String image;
  UserPage(this.name, this.Description, this.image);
  @override
  Widget build(BuildContext context) {
    print("UserPage");
    var profile = new AssetImage(image);
    var finish = new Image(image: profile);


    return new Scaffold(
      appBar: new AppBar(
        title: new Text(name),
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: true,
      ),
      body:
      Container(
          padding: EdgeInsets.only(left: 15.0, right: 15.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[

                /*Text('\n' + name + '\n\n',
                  textAlign: TextAlign.left,
                  style: new TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                  ),

                ),*/

                Container(
                    child: finish
                ),

                Text("\nDescription:\n",
                    textAlign: TextAlign.left,
                    style: new TextStyle(
                      color: Colors.black,
                      fontSize: 15.0,)),

                Text(Description + '\n\n',
                    textAlign: TextAlign.left,
                    style: new TextStyle(
                      color: Colors.black,
                      fontSize: 15.0,)),


              ]
          )
      ),

    );

  }
}

class Profile extends StatelessWidget {

  final String name;
  final String Description;
  final String image;
  Profile(this.name, this.Description, this.image);
  @override
  Widget build(BuildContext context) {
    print("Profile");
    var profile = new AssetImage(image);
    var finish = new Image(image: profile);


    return new Scaffold(
      appBar: new AppBar(
        title: new Text(name),
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: true,
      ),
      body:
      Container(
          padding: EdgeInsets.only(left: 15.0, right: 15.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[

                Text('\n' + name + '\n\n',
                  textAlign: TextAlign.left,
                  style: new TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                  ),

                ),

                Container(child: finish),

                Text("Description:\n",
                    textAlign: TextAlign.left,
                    style: new TextStyle(
                      color: Colors.black,
                      fontSize: 15.0,)),

                Text(Description + '\n\n',
                    textAlign: TextAlign.left,
                    style: new TextStyle(
                      color: Colors.black,
                      fontSize: 15.0,)),


              ]
          )
      ),

    );

  }
}

class Settings extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    print("Settings");

    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Settings"),
          backgroundColor: Colors.blue,
            actions: <Widget>[
              new RaisedButton(

                onPressed: () {
                  showAlertDialog(context);
                },
                child: new Text("Sign out",),
              ),
            ]
        ),
        body:
        /*ListView.builder(
            itemCount: previousUsers.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                  child: ListTile(
                      title: Text(previousUsers[index]), onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                            new UserPage(previousUsers[index], userBio[index], userImage[index])));
                  }
                  )
              );
            }
        )*/

        ListView(
          children: const <Widget>[
            Card(
              child: ListTile(
                //leading: FlutterLogo(),
                title: Text('My Profile'),

                //trailing: Icon(Icons.more_vert),
              ),
            ),
            /*Card(
              child: ListTile(
                title: Text('One-line dense ListTile'),
                //dense: true,
              ),
            ),*/
            Card(
              child: ListTile(
                //leading: FlutterLogo(size: 56.0),
                title: Text('Report a Bug'),
                //onTap: ,
                //subtitle: Text('Here is a second line'),
                //trailing: Icon(Icons.more_vert),
              ),
            ),
            /*Card(
              child: ListTile(
                //leading: FlutterLogo(size: 72.0),
                title: Text('Sign Out'),
                //onTap: () {},
                //subtitle: Text('A sufficiently long subtitle warrants three lines.'),
                //trailing: Icon(Icons.more_vert),
                //isThreeLine: true,
              ),
            ),*/
          ],
        )
    );
  }

}

class Set extends StatelessWidget {
  Widget getListView(BuildContext context) {
    var listView = ListView(
      children: <Widget>[
        ListTile(
          //leading: Icon(Icons.location_city),
          title: Text("Profile"),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    Profile("Vince Williams", "Software Engineer", ""),
              ),
            );
          },
        ),
        ListTile(
          //leading: Icon(Icons.location_city),
          title: Text("Report a Bug"),
          /*onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Profile("Vince Williams", "Software Engineer", ""),
              ),
            );
          },*/
        ),
        ListTile(
          //leading: Icon(Icons.location_city),
          title: Text("Sign Out"),
          onTap: () {
            showAlertDialog(context);
          },
        ),
      ],
    );
    return listView;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
            title: new Text("Settings"),
            backgroundColor: Colors.blue,
            actions: <Widget>[
              new RaisedButton(

                onPressed: () {
                  showAlertDialog(context);
                },
                child: new Text("Sign out",),
              ),
            ]
        ),
        body: getListView(context));
  }
}

showAlertDialog(BuildContext context) {

  // set up the button
  Widget noButton = FlatButton(
    child: Text("No"),
    onPressed:  () {},
  );
  Widget yesButton = FlatButton(
    child: Text("Yes"),
    onPressed:  () {},
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("AlertDialog"),
    content: Text("Would you like to sign out?"),
    actions: [
      noButton,
      yesButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

