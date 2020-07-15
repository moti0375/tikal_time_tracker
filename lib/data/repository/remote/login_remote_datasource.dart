import 'package:tikal_time_tracker/data/exceptions/failed_login_exception.dart';
import 'package:tikal_time_tracker/data/repository/login_data_source.dart';
import 'package:tikal_time_tracker/network/credentials.dart';
import 'package:tikal_time_tracker/network/requests/login_request.dart';
import 'package:tikal_time_tracker/network/time_tracker_api.dart';
import 'package:tikal_time_tracker/resources/strings.dart';
import 'package:tikal_time_tracker/services/auth/user.dart';
import 'dart:async';

class LoginRemoteDataSource implements LoginDataSource{
  static const CONNECTION_TIMEOUT = 5000;

  final TimeTrackerApi _api;
  LoginRemoteDataSource(this._api);



  Future<bool> _singIn(String userName, String password) async {

    print("LoginRemoteDataSource: _signIn: $userName:$password");
    String signInUsername = userName.split("@")[0];
    String signInPassword = "${signInUsername}tik23";

    _api.updateAuthHeader(Credentials(signInUserName: signInUsername, signInPassword: signInPassword));
    String singInStatus = await _api.signIn().
    timeout(Duration(milliseconds: CONNECTION_TIMEOUT), onTimeout: (){
      print("There was a timeout:");
    });
//    print("singInStatus: $singInStatus");
    if(singInStatus == null || singInStatus.contains("401 Unauthorized")){
      throw AppException(cause: Strings.signin_error);
    } else {
      print("SignIn success");
      return true;
    }
  }

  @override
  Future<User> login(String email, String password) async {
    bool signInPassed = await _singIn(email, password);
    if(signInPassed) {
      String response = await _api.login(LoginForm(Login: email, Password: password));

      if(response.isEmpty){  //This means login succeeded
        //It's time to create user, this is done by navigating to time page and parsing the user details.
        String userResponse = await _api.time();
        return User.init(userResponse);
      } else {
        if(response.contains("Incorrect login or password")){
          throw AppException(cause: Strings.incorrect_credentials);
        } else {
          throw AppException(cause: Strings.login_failure);
        }
      }
    }
    return null;
  }


}