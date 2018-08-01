import 'package:flutter/material.dart';


class AppDrawer extends StatelessWidget{

  final DrawerOnClickListener clickListener;

  AppDrawer({this.clickListener});

  @override
  Widget build(BuildContext context) {
    return new Drawer(
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
              child: new Stack(
                children: <Widget>[
                  new Positioned(child: new Text("Tikal Time Tracker", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),), left: 0.0, bottom: 0.0,),
                  new Positioned(child: new Container(
                    width: 50.0,
                    height: 50.0,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: new DecorationImage(fit: BoxFit.fill,
                            image: AssetImage('assets/logo.png'))
                    ),
                  ), left: 0.0, top: 20.0,),
                ],
              ),
            ),
            new ListTile(
              leading: new Icon(Icons.access_time),
              title: new Text("Time"),
              onTap: () {
                clickListener.onTimeClicked();
                Navigator.pop(context);
              },
            ),
            new ListTile(
              leading: new Icon(Icons.view_list),
              title: new Text("Reports"),
              onTap: () {
                clickListener.onReportClicked();
                Navigator.pop(context);
              },
            ),
            new ListTile(
              leading: new Icon(Icons.contact_mail),
              title: new Text("Users"),
              onTap: () {
                clickListener.onUsersClicked();
                Navigator.pop(context);
              },
            ),
            new ListTile(
              leading: new Icon(Icons.account_box),
              title: new Text("Profile"),
              onTap: () {
                clickListener.onProfileClicked();
                Navigator.pop(context);
              },
            ),
            new ListTile(
              leading: new Icon(Icons.close),
              title: new Text("Logout"),
              onTap: () {
                clickListener.onLogoutClicked();
                Navigator.pop(context);
              },
            )
          ],
        )
    );
  }
}

class DrawerOnClickListener  {
  void onTimeClicked() {}
  void onReportClicked() {}
  void onUsersClicked() {}
  void onProfileClicked(){}
  void onLogoutClicked() {}
}