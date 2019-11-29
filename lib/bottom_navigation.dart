import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:tikal_time_tracker/data/repository/time_records_repository.dart';
import 'package:tikal_time_tracker/pages/login/login_page.dart';
import 'package:tikal_time_tracker/pages/time/time_page.dart';
import 'package:tikal_time_tracker/pages/time/time_page_bloc.dart';
import 'package:tikal_time_tracker/pages/users/users_page.dart';
import 'package:tikal_time_tracker/pages/reports/generate_report_page.dart';
import 'package:tikal_time_tracker/resources/strings.dart';
import 'package:tikal_time_tracker/services/auth/auth.dart';

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
  Tab currentTab = Tab.Time;

  _onSelectedTab(int index) {
    switch (index) {
      case 0:
        _updateCurrentTab(Tab.Time);
        break;
      case 1:
        _updateCurrentTab(Tab.Reports);
        break;
      case 2:
        _updateCurrentTab(Tab.Users);
        break;
    }
  }

  _updateCurrentTab(Tab tab) {
    setState(() {
      currentTab = tab;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    print("BottomNavigation: dispose");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    BaseAuth auth = Provider.of<BaseAuth>(context);
    auth.onAuthChanged
      ..asBroadcastStream().listen((user) {
        if (user == null) {
          print("onAuthChanged: logout");
          _logout();
        }
      });
  }

  _logout() {
    Navigator.of(context).pushReplacement(new MaterialPageRoute(
        builder: (BuildContext context) => new LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _buildBody(), bottomNavigationBar: _buildBottomNavigation());
  }

  Widget _buildBody() {
    switch (currentTab) {
      case Tab.Time:
        return _timePageWithBloc();
      case Tab.Reports:
        return GenerateReportPage();
      case Tab.Users:
        return UsersPage();
    }
    return Container();
  }

//  Widget _buildTimePage() {
//    return StatefulProvider<TimePageBloc>(
//      valueBuilder: (context) =>
//          TimePageBloc(repository: TimeRecordsRepository()),
//      child: Consumer<TimePageBloc>(
//        builder: (context, bloc) => TimePage(
//          bloc: bloc,
//        ),
//      ),
//      onDispose: (context, bloc) => bloc.dispose(),
//    );
//  }

  Widget _timePageWithBloc(){
    return BlocProvider<TimePageBloc>(
      builder: (context) => TimePageBloc(repository: TimeRecordsRepository()),
      child: TimePage(),
    );
  }

  Widget _buildBottomNavigation() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: [
        _buildItem(icon: Icons.access_time, tab: Tab.Time),
        _buildItem(icon: Icons.line_weight, tab: Tab.Reports),
        _buildItem(icon: Icons.contacts, tab: Tab.Users)
      ],
      onTap: _onSelectedTab,
    );
  }

  BottomNavigationBarItem _buildItem({IconData icon, Tab tab}) {
    return BottomNavigationBarItem(
        icon: Icon(icon, color: _colorTabMatching(item: tab)),
        title: Text(
          tabName(tab: tab),
          style: TextStyle(color: _colorTabMatching(item: tab)),
        ));
  }

  Color _colorTabMatching({Tab item}) {
    return currentTab == item ? Theme.of(context).primaryColor : Colors.grey;
  }
}
