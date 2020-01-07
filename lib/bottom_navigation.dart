import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tikal_time_tracker/analytics/analytics.dart';
import 'package:tikal_time_tracker/data/repository/app_repository.dart';
import 'package:tikal_time_tracker/data/repository/time_records_repository.dart';
import 'package:tikal_time_tracker/pages/login/login_page.dart';
import 'package:tikal_time_tracker/pages/time/time_page.dart';
import 'package:tikal_time_tracker/pages/time/time_page_bloc.dart';
import 'package:tikal_time_tracker/pages/users/users_page.dart';
import 'package:tikal_time_tracker/pages/reports/generate_report_page.dart';
import 'package:tikal_time_tracker/resources/strings.dart';
import 'package:tikal_time_tracker/services/auth/auth.dart';
import 'package:tikal_time_tracker/services/auth/user.dart';
import 'package:tikal_time_tracker/services/locator/locator.dart';

enum Tab {
  Time,
  Reports,
  Users,
}

class BottomNavigation extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return BottomNavigationState();
  }
}

String tabName({Tab tab}) {
  switch (tab) {
    case Tab.Time:
      return Strings.time_page_title;
    case Tab.Reports:
      return Strings.reports_page_title;
    case Tab.Users:
      return Strings.users_page_title;
  }
  return null;
}

class BottomNavigationState extends State<BottomNavigation> {
  int _page = 0;
  PageController _pageController;
  StreamSubscription<User> listen;

  _onSelectedTab(int index) {
    _pageController.animateToPage(index, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
//    switch (index) {
//      case 0:
//        _updateCurrentTab(Tab.Time);
//        break;
//      case 1:
//        _updateCurrentTab(Tab.Reports);
//        break;
//      case 2:
//        _updateCurrentTab(Tab.Users);
//        break;
//    }
  }

  @override
  void initState() {
    _pageController = PageController(initialPage: _page);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    print("BototmVavigation dispose");
    listen.cancel();
    listen = null;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    BaseAuth auth = Provider.of<BaseAuth>(context);
    if(listen == null){
      listen = auth.onAuthChanged.listen((user) {
        if (user == null) {
          print("onAuthChanged: logout");
          _logout();
        }
      });
    }
  }

  _logout() {
    Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => LoginPage.create()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(
          controller: _pageController,
          onPageChanged: (i) {
            setState(() {
              _page = i;
            });
          },
          children: <Widget>[
            _buildTimePage(),
            GenerateReportPage(),
            UsersPage()
          ],
        ), bottomNavigationBar: _buildBottomNavigation());
  }

  Widget _buildTimePage() {
    return Consumer<BaseAuth>(
      builder:(context, auth, _) => Provider<TimePageBloc>(
        create: (context) =>
            TimePageBloc(locator<AppRepository>(),  auth,  locator<Analytics>()),
        child: Consumer<TimePageBloc>(
          builder: (context, bloc, _) => TimePage(
            bloc: bloc,
          ),
        ),
        dispose: (context, bloc) => bloc.dispose(),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return BottomNavigationBar(
      currentIndex: _page,
      type: BottomNavigationBarType.fixed,
      items: <BottomNavigationBarItem>[
        _buildItem(icon: Icons.access_time, tab: Tab.Time),
        _buildItem(icon: Icons.line_weight, tab: Tab.Reports),
        _buildItem(icon: Icons.contacts, tab: Tab.Users)
      ],
      onTap: _onSelectedTab,
    );
  }

  BottomNavigationBarItem _buildItem({IconData icon, Tab tab}) {
    return BottomNavigationBarItem(
        icon: Icon(icon),
        title: Text(
          tabName(tab: tab),
        ));
  }
}
