import 'package:flutter/material.dart';
import 'package:tikal_time_tracker/data/member.dart';
import 'package:tikal_time_tracker/pages/users/users_presenter.dart';
import 'package:tikal_time_tracker/pages/users/users_contract.dart';
import 'package:tikal_time_tracker/pages/users/users_list_adapter.dart';
import 'package:tikal_time_tracker/services/auth/user.dart';
import 'package:tikal_time_tracker/ui/page_title.dart';
import 'package:tikal_time_tracker/data/repository/time_records_repository.dart';
import 'package:tikal_time_tracker/analytics/analytics.dart';
import 'package:tikal_time_tracker/analytics/events/users_event.dart';
import 'package:tikal_time_tracker/ui/platform_appbar.dart';

class UsersPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
   // print("U
    //users: ${User.me.name}, Projects: ${User.me.projects}");
    return UsersPageState();
  }
}

class UsersPageState extends State<UsersPage> implements MembersViewContract{

  Analytics analytics = Analytics.instance;
  UsersPresenter presenter = UsersPresenter(repository: TimeRecordsRepository());
  bool loading = false;
  List<Member> _users;
  @override
  void initState() {
    super.initState();
    presenter.subscribe(this);
    analytics.logEvent(UsersEvent.impression(EVENT_NAME.USERS_SCREEN).open());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PlatformAppbar(
        title: Text("Users"),
      ).build(context),
      body: _buildBody(),
      backgroundColor: Colors.black12,
    );
  }

  Widget _buildBody(){

    if(loading){
      return Center(
        child: SizedBox(
            height: 36.0,
            width: 36.0,
            child: CircularProgressIndicator(
                value: null,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue)))
      );
    }else{
      return Container(
        padding: const EdgeInsets.only(top: 0.0, left: 16.0, right: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
           TimeTrackerPageTitle(),
            Expanded(
              child:  UsersListAdapter(items: _users),
            )
          ],
        ),
      );
    }
  }

  @override
  void showMembers(List<Member> users) {
    analytics.logEvent(UsersEvent.impression(EVENT_NAME.LOAD_USERS_SUCCESS).setUser(User.me.name).view());
    setState(() {
      _users = users;
    });
  }

  @override
  void setLoadingIndicator(bool loading) {
    setState(() {
      this.loading = loading;
    });
  }
}