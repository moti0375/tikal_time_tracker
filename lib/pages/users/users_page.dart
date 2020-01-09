import 'package:flutter/material.dart';
import 'package:tikal_time_tracker/data/member.dart';
import 'package:tikal_time_tracker/pages/users/users_block.dart';
import 'package:tikal_time_tracker/pages/users/users_list_adapter.dart';
import 'package:tikal_time_tracker/services/auth/user.dart';
import 'package:tikal_time_tracker/ui/page_title.dart';
import 'package:tikal_time_tracker/data/repository/time_records_repository.dart';
import 'package:tikal_time_tracker/analytics/analytics.dart';
import 'package:tikal_time_tracker/analytics/events/users_event.dart';
import 'package:tikal_time_tracker/ui/platform_appbar.dart';

class UsersPage extends StatefulWidget{

  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> with AutomaticKeepAliveClientMixin<UsersPage>{
 final analytics = Analytics.instance;

 final bloc = UsersBloc(repository: TimeRecordsRepository());

  Widget build(BuildContext context) {
    analytics.logEvent(UsersEvent.impression(EVENT_NAME.USERS_SCREEN).open());

    return Scaffold(
      appBar: PlatformAppbar(
        heroTag: "UsersPage",
        title: Text("Users"),
      ).build(context),
      body: StreamBuilder<List<Member>>(
        stream: bloc.loadUsers(),
        builder: (context, snapshot) => _buildBody(context, snapshot),
      ),
      backgroundColor: Colors.black12,
    );
  }

  Widget _buildBody(BuildContext context, AsyncSnapshot snapshot){
    print("Users: _buildBody connection state: ${snapshot.connectionState}");
    if(!snapshot.hasData){
      return Center(
        child: SizedBox(
            height: 36.0,
            width: 36.0,
            child: CircularProgressIndicator(
                value: null,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue)))
      );
    } else {
      analytics.logEvent(UsersEvent.impression(EVENT_NAME.LOAD_USERS_SUCCESS).setUser(User.me.name).view());
      return Container(
        padding: const EdgeInsets.only(top: 0.0, left: 16.0, right: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
           TimeTrackerPageTitle(),
            Expanded(
              child:  UsersListAdapter(items: snapshot.data),
            )
          ],
        ),
      );
    }
  }

  @override
  bool get wantKeepAlive => true;
}