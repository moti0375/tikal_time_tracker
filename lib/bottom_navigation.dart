import 'package:flutter/material.dart';
import 'package:tikal_time_tracker/pages/time/time_page.dart';
import 'package:tikal_time_tracker/pages/users/users_page.dart';
import 'package:tikal_time_tracker/pages/reports/generate_report_page.dart';

enum Tab{
  Time,
  Reports,
  Users,
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
    }
    return Container();
  }

  Widget _buildBottomNavigation() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: [_buildItem(icon: Icons.access_time, tab: Tab.Time),
              _buildItem(icon: Icons.line_weight, tab: Tab.Reports),
              _buildItem(icon: Icons.contacts, tab: Tab.Users)],
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