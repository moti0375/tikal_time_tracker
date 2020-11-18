import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:tikal_time_tracker/network/client_cookie.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {
  static String buildTimeStringFromTime(TimeOfDay time) {
    return "${time.hour}:${time.minute % 60 < 10 ? "0${time.minute % 60}" : time.minute % 60}";
  }

  static String buildTimeStringFromDuration(Duration duration) {
    if (duration == null) {
      duration = new Duration(hours: 0, minutes: 0);
    }
    return "${duration.inHours}:${duration.inMinutes % 60 < 10 ? "0${duration.inMinutes % 60}" : duration.inMinutes % 60}";
  }

  static List<ClientCookie> cookies(String cookiesString) {
    String tt_login = ",tt_login";

    List<ClientCookie> cookies = List<ClientCookie>();
    if (cookiesString.contains(tt_login)) {
      String sessionCookieStr = cookiesString.substring(0, cookiesString.indexOf(tt_login));
      String ttLoginCookie = cookiesString.substring(cookiesString.indexOf(tt_login) + 1);

      ClientCookie sessionCookie = _getCookieMap(sessionCookieStr);
      ClientCookie loginCookie = _getCookieMap(ttLoginCookie);

      cookies.add(sessionCookie);
      cookies.add(loginCookie);
//      print("session cookie: $sessionCookieStr\n ttLoginCookie: $ttLoginCookie");
    } else {
      ClientCookie sessionCookie = _getCookieMap(cookiesString);
//      print("Session Cookie: ${sessionCookie.toString()}");
      cookies.add(sessionCookie);
    }

    return cookies;
  }

  static ClientCookie _getCookieMap(String cookieStr) {
    Map<String, String> cookieMap = Map<String, String>();
    List<String> l = cookieStr.split(";");
    DateFormat dateFormat = DateFormat('EEE, d-MMM-y H:m:s');

    l.forEach((it) {
      cookieMap[it.split("=")[0]] = it.split("=")[1];
    });

    String dateString = cookieMap.values.elementAt(1).substring(0, cookieMap.values.elementAt(1).indexOf(" GMT")).trim();
    print("Date: ${dateFormat.parse(dateString)}");

    ClientCookie cookie = ClientCookie.fromMap(cookieMap.keys.elementAt(0), cookieMap.values.elementAt(0), DateTime.now(), {
      "Domain": "planet.tikal.com",
      "Expires": dateFormat.parse(dateString),
      "Max-Age": int.parse(cookieMap.values.elementAt(2)),
      "Path": cookieMap.values.elementAt(3),
    });

    return cookie;
  }

  static hideSoftKeyboard(BuildContext context) {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  static int getDaysInMonth(int year, int month) {
    if (month == 4 || month == 6 || month == 9 || month == 11) return 30;
    if (month == 2) {
      if (year % 4 == 0 && year % 100 != 0 || year % 400 == 0) {
        return 29;
      } else {
        return 28;
      }
    }
    return 31;
  }

  static Future mailTo({String emailAddress, String subject, String body}) async {
    final String url = 'mailto:$emailAddress?subject=$subject&body=$body';
    Uri uri = Uri.parse(url);
    print("mailTo: ${uri.toString()}");
    try{
      if (await canLaunch(uri.toString())) {
        await launch(url);
      }
    } catch(e){
      print("Something went wrong: ${e.toString()}");
    }
  }
}


