import 'package:flutter/material.dart';
import 'package:client_cookie/client_cookie.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class Utils {
  static String buildTimeStringFromTime(TimeOfDay time) {
    return "${time.hour}:${time.minute % 60 < 10 ? "0${time.minute % 60}" : time.minute % 60}";
  }

  static String buildTimeStringFromDuration(Duration duration) {
    if(duration == null){
      duration = new Duration(hours: 0, minutes: 0);
    }
    return "${duration.inHours}:${duration.inMinutes % 60 < 10 ? "0${duration.inMinutes % 60}" : duration.inMinutes % 60}";
  }

  static List<ClientCookie> cookies(String cookiesString){
    String tt_login = ",tt_login";
    DateFormat dateFormat = DateFormat('EEE, d-MMM-y H:m:s');

    List<ClientCookie> cookies = List<ClientCookie>();
    if(cookiesString.contains(tt_login)){
      String sessionCookieStr = cookiesString.substring(0,cookiesString.indexOf(tt_login));
      String ttLoginCookie = cookiesString.substring(cookiesString.indexOf(tt_login) + 1);

      ClientCookie sessionCookie = _getCookieMap(sessionCookieStr);
      ClientCookie loginCookie = _getCookieMap(ttLoginCookie);

//      print("Session Cookie: ${sessionCookie.toString()}");
//      print("ttLogin Cookie: ${loginCookie.toString()}");

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


  static ClientCookie _getCookieMap(String cookieStr){
    Map<String, String> cookieMap = Map<String, String>();
    List<String> l = cookieStr.split(";");
    DateFormat dateFormat = DateFormat('EEE, d-MMM-y H:m:s');


    l.forEach((it){
      cookieMap[it.split("=")[0]] = it.split("=")[1];
    });

    String dateString = cookieMap.values.elementAt(1).substring(0, cookieMap.values.elementAt(1).indexOf(" GMT")).trim();
    print("Date: ${dateFormat.parse(dateString)}");

    ClientCookie cookie = ClientCookie.fromMap(cookieMap.keys.elementAt(0), cookieMap.values.elementAt(0), DateTime.now(), {
      "Domain" : "planet.tikal.com",
      "Expires" : dateFormat.parse(dateString),
      "Max-Age" : int.parse(cookieMap.values.elementAt(2)),
      "Path" : cookieMap.values.elementAt(3),
    });

    return cookie;
  }

  static hideSoftKeyboard(BuildContext context){
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }
}
