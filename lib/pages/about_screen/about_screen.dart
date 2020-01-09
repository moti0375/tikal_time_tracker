import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:tikal_time_tracker/services/auth/user.dart';
import 'package:tikal_time_tracker/services/locator/locator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tikal_time_tracker/resources/strings.dart';
import 'package:tikal_time_tracker/analytics/analytics.dart';
import 'package:tikal_time_tracker/analytics/events/base_event.dart';

class AboutScreen extends StatelessWidget{
  final Analytics analytics = Analytics.instance;
  @override
  Widget build(BuildContext context) {

    analytics.logEvent(BaseEvent("about_screen").setUser(User.me.name).open());
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

    final flutterLogo = CircleAvatar(
      backgroundColor: Colors.transparent,
      radius: 24.0,
      child: Image.asset('assets/flutter_logo.png'),
    );

    final dartLogo = CircleAvatar(
      backgroundColor: Colors.transparent,
      radius: 24.0,
      child: Image.asset('assets/dart_logo.png'),
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
                    Text(Strings.app_name,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                    getTextRow("${Strings.version_text}: ${locator<PackageInfo>().version}"),
                    getTextRow(Strings.about_text),
                  ],
                ),
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    getTextRow(Strings.developer_text),
                    InkWell(
                        onTap: _launchUrl,
                        child: Text(Strings.developer_email, style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),)
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 5.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          flutterLogo,
                          dartLogo,
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
    const url = 'mailto:${Strings.developer_email}?subject=${Strings.mail_subject}&body=${Strings.mail_body}';
    if (await canLaunch(url)) {
      print("can launch");
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}