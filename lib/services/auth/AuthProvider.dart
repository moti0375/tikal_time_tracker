import 'package:flutter/material.dart';
import 'package:tikal_time_tracker/services/auth/auth.dart';

class AuthProvider extends InheritedWidget{

  final BaseAuth auth;
  final Widget child;

  AuthProvider({this.auth, this.child});


  @override
  bool updateShouldNotify(InheritedWidget oldWidget) =>
     false;

  static BaseAuth of(BuildContext context){
    AuthProvider provider = context.inheritFromWidgetOfExactType(AuthProvider);
    return provider.auth;
  }
}