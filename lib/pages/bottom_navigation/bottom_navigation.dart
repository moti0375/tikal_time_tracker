import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tikal_time_tracker/pages/bottom_navigation/tabs_helper.dart';
import 'package:tikal_time_tracker/pages/login/login_page.dart';
import 'package:tikal_time_tracker/resources/strings.dart';
import 'package:tikal_time_tracker/services/auth/auth.dart';
import 'package:tikal_time_tracker/services/auth/user.dart';

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
  StreamSubscription<User> listen;

  _onSelectedTab(int index) {
    setState(() {
      _page = index;
    });
  }

  @override
  void initState() {
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
        body: IndexedStack(
          index: _page,
          children: TabsHelper.screens,
        ), bottomNavigationBar: _buildBottomNavigation());
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
        label: tabName(tab: tab),
        );
  }
}
