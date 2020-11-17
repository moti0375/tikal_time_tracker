import 'package:flutter/material.dart';
import 'package:tikal_time_tracker/pages/reports/generate_report_page.dart';
import 'package:tikal_time_tracker/pages/time/time_page.dart';
import 'package:tikal_time_tracker/pages/users/users_page.dart';

class TabsHelper {
  static Widget _timePage = TimePage.create();
  static Widget _reportsTab = GenerateReportPage.create();
  static Widget _usersTab = UsersPage();

  static List<Widget> screens = [
    _timePage,
    _reportsTab,
    _usersTab
  ];
}