import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:tikal_time_tracker/pages/users/users_store.dart';
import 'package:tikal_time_tracker/pages/users/users_list_adapter.dart';
import 'package:tikal_time_tracker/services/auth/auth.dart';
import 'package:tikal_time_tracker/services/auth/user.dart';
import 'package:tikal_time_tracker/services/locator/locator.dart';
import 'package:tikal_time_tracker/ui/page_title.dart';
import 'package:tikal_time_tracker/data/repository/time_records_repository.dart';
import 'package:tikal_time_tracker/analytics/analytics.dart';
import 'package:tikal_time_tracker/ui/platform_appbar.dart';

class UsersPage extends StatefulWidget{

  @override
  _UsersPageState createState() => _UsersPageState();

  static Widget create() {
    return Provider<UsersStore>(
      create: (_) => UsersStore(locator<TimeRecordsRepository>(), locator<Analytics>()),
      child: UsersPage(),
    );
  }

}

class _UsersPageState extends State<UsersPage> with AutomaticKeepAliveClientMixin<UsersPage>{
 final analytics = Analytics.instance;

 User _user;
 UsersStore _store;

 @override
  void initState() {
    super.initState();
 }

 @override
 void didChangeDependencies() {
   super.didChangeDependencies();
   _user ??= Provider.of<BaseAuth>(context).getCurrentUser();
   if(_store == null){
     _store = Provider.of<UsersStore>(context);
     _store.initPage();
     _store.loadUsers(_user);
   }
 }

  Widget build(BuildContext context)  {
   super.build(context);

    return Scaffold(
      appBar: PlatformAppbar(
        heroTag: "UsersPage",
        title: Text("Users"),
      ).build(context),
      body: Observer(
        builder: (context) => _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context){
    if(_store.users == null){
      return Center(
        child: SizedBox(
            height: 36.0,
            width: 36.0,
            child: CircularProgressIndicator(
                value: null,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue)))
      );
    } else {
      return Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
           TimeTrackerPageTitle(),
            Expanded(
              child:  UsersListAdapter(items: _store.users),
            )
          ],
        ),
      );
    }
  }


  @override
  bool get wantKeepAlive => true;
}