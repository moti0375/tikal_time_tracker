import 'package:flutter/material.dart';

enum MenuAction { Logout, Close, SendEmail, About, ReportAnalysis }

class Choice {
  final MenuAction action;
  final String title;
  final IconData icon;
  List<TextSpan> textSpans;

  Choice({this.action, this.title, this.icon, this.textSpans});
}
