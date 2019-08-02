import 'package:flutter/material.dart';

enum MenuAction { Logout, Close, SendEmail, About }

class Choice {
  final MenuAction action;
  final String title;
  final IconData icon;

  const Choice({this.action, this.title, this.icon});
}
