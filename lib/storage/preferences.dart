import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class Preferences{

  static const String TAG = "Preferences";
  static const String SING_IN_USER_NAME = "sign_in_username";
  static const String SING_IN_PASSWORD = "sing_in_password";

  static Preferences _singleton;
  SharedPreferences prefs;

  static Preferences init(SharedPreferences preferences)  {
    if (_singleton == null){
      print("$TAG : init");
      _singleton = Preferences._internal(preferences);
    }
    return _singleton;
  }

  factory Preferences() {
    return _singleton;
  }

  Preferences._internal(SharedPreferences prefs){
      this.prefs = prefs;
  }

  void setSingInUserName(String userName){
    prefs.setString(SING_IN_USER_NAME, userName);
  }

  String getSingInUserName() {
    return prefs.getString(SING_IN_USER_NAME);
  }

  void setSingInPassword(String password){
    prefs.setString(SING_IN_PASSWORD, password);
  }

  String getSingInPassword() {
    return prefs.getString(SING_IN_PASSWORD);
  }


}