import 'package:flutter/material.dart';

enum Action { Logout, Close, SendEmail, About }

class Choice {
  final Action action;
  final String title;
  final IconData icon;

  const Choice({this.action, this.title, this.icon});
}
