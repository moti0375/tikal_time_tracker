import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class Preferences{

  static const String TAG = "Preferences";
  static const String SING_IN_USER_NAME = "sign_in_username";
  static const String SING_IN_PASSWORD = "sing_in_password";
  static const String LOGIN_IN_USER_NAME = "login_username";
  static const String LOGIN_IN_PASSWORD = "login_in_password";

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

  void setLoginUserName(String username){
    prefs.setString(LOGIN_IN_USER_NAME, username);
  }

  String getLoginUserName(){
   return prefs.getString(LOGIN_IN_USER_NAME);
  }

  void setLoginPassword(String password){
    prefs.setString(LOGIN_IN_PASSWORD, password);
  }

  String getLoginPassword(){
    return prefs.getString(LOGIN_IN_PASSWORD);
  }

  void signOut(){
    prefs.remove(SING_IN_USER_NAME);
    prefs.remove(SING_IN_PASSWORD);
  }

}