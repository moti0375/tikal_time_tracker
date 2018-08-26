import 'package:flutter/material.dart';
import 'pages/time_page.dart';
import 'pages/reports/reports_page.dart';
import 'pages/users_page.dart';
import 'pages/profile_page.dart';
import 'data/user.dart';
import 'pages/reports/generate_report_page.dart';

enum Tab{
  Time,
  Reports,
  Users,
  Profile
}

class BottomNavigation extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return BottomNavigationState();
  }
}

String tabName({Tab tab}){
  switch(tab){
    case Tab.Time:
      return "Time";
    case Tab.Reports:
      return "Reports";
    case Tab.Users:
      return "Users";
    case Tab.Profile:
      return "Profile";
  }
  return null;
}

class BottomNavigationState extends State<BottomNavigation>{

  Tab currentTab = Tab.Time;

  _onSelectedTab(int index){
    switch(index){
      case 0:
        _updateCurrentTab(Tab.Time);
        break;
      case 1:
        _updateCurrentTab(Tab.Reports);
        break;
      case 2:
        _updateCurrentTab(Tab.Users);
        break;
      case 3:
        _updateCurrentTab(Tab.Profile);
        break;
    }
  }

  _updateCurrentTab(Tab tab){
    setState(() {
      currentTab = tab;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigation()
    );
  }

  Widget _buildBody() {
    switch(currentTab){
      case Tab.Time:
        return TimePage();
      case Tab.Reports:
        return GenerateReportPage();
      case Tab.Users:
        return UsersPage();
      case Tab.Profile:
        return ProfilePage();
    }
    return Container();
  }

  Widget _buildBottomNavigation() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: [_buildItem(icon: Icons.access_time, tab: Tab.Time),
              _buildItem(icon: Icons.line_weight, tab: Tab.Reports),
              _buildItem(icon: Icons.contacts, tab: Tab.Users),
              _buildItem(icon: Icons.account_box, tab: Tab.Profile)],
      onTap: _onSelectedTab,
    );
  }

  BottomNavigationBarItem _buildItem({IconData icon, Tab tab}) {
    return BottomNavigationBarItem(
      icon: Icon(icon, color: _colorTabMatching(item: tab)),
      title: Text(tabName(tab: tab), style: TextStyle(color: _colorTabMatching(item: tab)),)
    );
  }


  Color _colorTabMatching({Tab item}) {
    return currentTab == item ? Theme.of(context).primaryColor : Colors.grey;
  }

}