import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MainPageState();
  }
}


class MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    Drawer drawer = new Drawer(
      child:
      new ListView(
        children: <Widget>[
          new Container(
            constraints: new BoxConstraints.expand(
              height: 180.0,
            ),
            alignment: Alignment.bottomLeft,
            padding: new EdgeInsets.only(left: 16.0, bottom: 8.0),
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage('assets/drawer.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: new Text('Tikal Time Tracker',
                style: new TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                )
            ),
          ),
          new ListTile(
            leading: new Icon(Icons.access_time),
            title: new Text("Time"),
            onTap: () {

            },
          ),
          new ListTile(
            leading: new Icon(Icons.view_list),
            title: new Text("Reports"),
            onTap: () {},
          ),
          new ListTile(
            leading: new Icon(Icons.contact_mail),
            title: new Text("Users"),
            onTap: () {},
          ),
          new ListTile(
            leading: new Icon(Icons.account_box),
            title: new Text("Profile"),
            onTap: () {},
          ),
          new ListTile(
            leading: new Icon(Icons.close),
            title: new Text("Logout"),
            onTap: () {},
          )
        ],
      )
    );

    return new MaterialApp(
      title: "Tikal Time Tracker",
      theme: new ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: Scaffold(
        drawer: drawer,
        appBar: new AppBar(
          title: new Text("Tikal Time Tracker" , style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}


