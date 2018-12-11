import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget{

  @override
  Widget build(BuildContext context) {

    Widget getTextRow(String text){
      return Container(
        padding: EdgeInsets.symmetric(vertical: 4.0),
        child: Text(text, textAlign: TextAlign.left,),
      );
    }

    final logo = Hero(
        tag: 'hero',
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 48.0,
          child: Image.asset('assets/logo_no_background.png'),
        )
    );

    final flutter_logo = Hero(
        tag: 'flutter_logo',
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 24.0,
          child: Image.asset('assets/flutter_logo.png'),
        )
    );

    final dart_logo = Hero(
        tag: 'dart_logo',
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 24.0,
          child: Image.asset('assets/dart_logo.png'),
        )
    );
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Container(
          padding: EdgeInsets.only(top: 100, bottom: 25, left: 25, right: 25 ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    logo,
                    Text("Tikal Time Tracker",
                      textAlign: TextAlign.center,
                      maxLines: 1,
                        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                    getTextRow("Version: 1.0"),
                    getTextRow("Developed with Google's Flutter cross platform framework"),
                  ],
                ),
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    getTextRow("Moti Bartov, Tikal Mobile Group"),
                    InkWell(
                        onTap: _launchUrl,
                        child: Text("motib@tikalk.com", style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),)
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 5.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          flutter_logo,
                          dart_logo,
                        ],
                      ),
                    ),
                  ] ,
                )
              ),
            ],
          ),
        ),
      );
  }

  void _launchUrl() async{
    const url = 'mailto:motib@tikalk.com?subject=Time%20Tracker%20Issue&body=Hi%20Moti';
    if (await canLaunch(url)) {
      print("can launch");
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}