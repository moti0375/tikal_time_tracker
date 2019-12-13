import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tikal_time_tracker/data/dom/dom_parser.dart';
import 'package:tikal_time_tracker/data/exceptions/failed_login_exception.dart';
import 'package:tikal_time_tracker/data/repository/app_repository.dart';
import 'package:tikal_time_tracker/data/repository/login_data_source.dart';
import 'package:tikal_time_tracker/data/repository/time_records_repository.dart';
import 'package:tikal_time_tracker/network/credentials.dart';
import 'package:tikal_time_tracker/network/requests/login_request.dart';
import 'package:tikal_time_tracker/network/time_tracker_api.dart';
import 'package:tikal_time_tracker/resources/strings.dart';
import 'package:tikal_time_tracker/services/auth/user.dart';
import 'package:tikal_time_tracker/services/locator/locator.dart';
abstract class BaseAuth with ChangeNotifier{
  Stream<User> get onAuthChanged;
  Future<User> login(String userName, String password);
  Future<void> logout();
  User getCurrentUser();
  void dispose();
}


class AppAuth extends BaseAuth{

  AppRepository _appRepository;
  User _user;
  AppAuth(this._appRepository);

  StreamController<User> authStreamController = StreamController.broadcast();
  @override
  Future<User> login(String email, String password) async {
    print("AppAuth: login called");
    User user = await  _appRepository.login(email, password);
    print("Login Success: $user");
    _user = user;
    setUser(user);
    return user;
  }

  @override
  Future<void> logout() {
    authStreamController.add(null);
    _user = null;
    locator.unregister<User>();
    return null;
  }

  @override
  Stream<User> get onAuthChanged => authStreamController.stream.asBroadcastStream();

  @override
  void dispose() {
    authStreamController.close();
    super.dispose();
  }

  @override
  User getCurrentUser() {
    return _user;
  }
}


