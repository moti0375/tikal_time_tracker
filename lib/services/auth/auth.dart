import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tikal_time_tracker/data/exceptions/failed_login_exception.dart';
import 'package:tikal_time_tracker/network/credentials.dart';
import 'package:tikal_time_tracker/network/requests/login_request.dart';
import 'package:tikal_time_tracker/network/time_tracker_api.dart';
import 'package:tikal_time_tracker/resources/strings.dart';
import 'package:tikal_time_tracker/services/auth/user.dart';
abstract class BaseAuth{
  Stream<User> get onAuthChanged;
  Future<User> login(String userName, String password);
  Future<void> _singIn(String userName, String password);
  Future<void> logout();
  void dispose();
}


class AppAuth extends BaseAuth{

  final TimeTrackerApi api;
  static const CONNECTION_TIMEOUT = 5000;

  AppAuth({this.api}){
    print("AppAuth: created");
  }

  StreamController<User> authStreamController = StreamController.broadcast();
  @override
  Future<User> login(String email, String password) async {
    print("AppAuth: login called");

    bool signInPassed = await _singIn(email, password);

    if(signInPassed){
        String response = await api.login(LoginForm(Login: email, Password: password));
        debugPrint("AppAuth: response: ${response.toString()}");

        if(response.isEmpty){       //This means login succeeded
          String userResponse = await api.time();
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

  @override
  Future<void> logout() {
    authStreamController.add(null);
    return null;
  }

  @override
  Stream<User> get onAuthChanged => authStreamController.stream.asBroadcastStream();

  @override
  Future<bool> _singIn(String userName, String password) async {

    print("AppAuth: _signIn: $userName:$password");

    String signInUsername = userName.split("@")[0];
    String signInPassword = "${signInUsername}tik23";

    api.updateAuthHeader(Credentials(signInUserName: signInUsername, signInPassword: signInPassword));
    String singInStatus = await api.signIn().
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
  void dispose(){
    print("AppAuth: dispose");
    authStreamController.close();
  }
}


