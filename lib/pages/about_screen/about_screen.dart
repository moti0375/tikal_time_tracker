import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:tikal_time_tracker/services/auth/auth.dart';
import 'package:tikal_time_tracker/services/locator/locator.dart';
import 'package:tikal_time_tracker/ui/text_link_item.dart';
import 'package:tikal_time_tracker/utils/utils.dart';
import 'package:tikal_time_tracker/resources/strings.dart';
import 'package:tikal_time_tracker/analytics/analytics.dart';
import 'package:tikal_time_tracker/analytics/events/base_event.dart';

class AboutScreen extends StatelessWidget {
  final Analytics analytics = Analytics.instance;

  @override
  Widget build(BuildContext context) {
    analytics.logEvent(BaseEvent("about_screen").setUser(Provider.of<BaseAuth>(context).getCurrentUser().name).open());
    Widget getTextRow(String text) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 4.0),
        child: Text(
          text,
          textAlign: TextAlign.left,
        ),
      );
    }

    final logo = Hero(
        tag: 'logo',
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 48.0,
          child: Image.asset('assets/logo_no_background.png'),
        ));

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
        padding: EdgeInsets.only(top: 100, bottom: 25, left: 25, right: 25),
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
                  Text(
                    Strings.app_name,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
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
                TextLinkItem(
                  text: Strings.developer_email,
                  onPressed: () async => await Utils.mailTo(emailAddress: Strings.developer_email, subject: Strings.mail_subject, body: Strings.mail_body),
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
              ],
            )),
          ],
        ),
      ),
    );
  }
}
