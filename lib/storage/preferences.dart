import 'package:shared_preferences/shared_preferences.dart';

class Preferences{

  static const String TAG = "Preferences";
  static const String SING_IN_USER_NAME = "sign_in_username";
  static const String SING_IN_PASSWORD = "sing_in_password";
  static const String LOGIN_IN_USER_NAME = "login_username";
  static const String LOGIN_IN_PASSWORD = "login_in_password";
  static const String USER_SAW_REPORT_ANALYSIS = "user_saw_analysis";
  static const String ANALYSIS_COUNTER = "analysis_counter";

  final int _ANALYSIS_LIMIT = 3;

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

  void setLoginUserName(String username)  {
    prefs.setString(LOGIN_IN_USER_NAME, username);
  }

  Future<String> getLoginUserName() async {
   return prefs.getString(LOGIN_IN_USER_NAME);
  }

  void setLoginPassword(String password){
    prefs.setString(LOGIN_IN_PASSWORD, password);
  }

  Future<String> getLoginPassword() async {
    return prefs.getString(LOGIN_IN_PASSWORD);
  }

  void setAnalysisCounter() async {
    var counterValue = 0;

    if(prefs.containsKey(ANALYSIS_COUNTER)){
      counterValue = prefs.getInt(ANALYSIS_COUNTER);
    }

    if(counterValue < _ANALYSIS_LIMIT){
      prefs.setInt(ANALYSIS_COUNTER, ++counterValue);
    } else if(!prefs.containsKey(USER_SAW_REPORT_ANALYSIS)){
      prefs.setBool(USER_SAW_REPORT_ANALYSIS, true);
    }
  }

  Future<bool> didUserSawAnalysis() async {
    if(prefs.containsKey(USER_SAW_REPORT_ANALYSIS)){
      return prefs.getBool(USER_SAW_REPORT_ANALYSIS);
    } else {
      return false;
    }
  }

  Future<void> signOut() async {
    await prefs.remove(SING_IN_USER_NAME);
    await prefs.remove(SING_IN_PASSWORD);
    await prefs.remove(LOGIN_IN_PASSWORD);
    await prefs.remove(LOGIN_IN_USER_NAME);
  }

}