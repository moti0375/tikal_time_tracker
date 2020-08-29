import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tikal_time_tracker/data/repository/app_repository.dart';
import 'package:tikal_time_tracker/services/auth/user.dart';
abstract class BaseAuth with ChangeNotifier{
  Stream<User> get onAuthChanged;
  Future<User> login(String userName, String password);
  Future<void> logout();
  User getCurrentUser();
  void dispose();
}


class AppAuth extends BaseAuth {

  AppRepository _appRepository;
  User _user;
  User get user => _user;
  AppAuth(this._appRepository);

  StreamController<User> authStreamController = StreamController.broadcast();
  @override
  Future<User> login(String email, String password) async {
    print("AppAuth: login called");
    User user = await  _appRepository.login(email, password);
    print("Login Success: $user");
    _user = user;
    return user;
  }

  @override
  Future<void> logout() async {
    authStreamController.add(null);
    _user = null;
    User.clear();
    notifyListeners();
    return null;
  }

  @override
  Stream<User> get onAuthChanged => authStreamController.stream;

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


