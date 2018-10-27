import 'package:flutter/material.dart';
import 'package:tikal_time_tracker/data/member.dart';
import 'package:tikal_time_tracker/data/user.dart';
import 'package:tikal_time_tracker/pages/users/users_presenter.dart';
import 'package:tikal_time_tracker/pages/users/users_contract.dart';
import 'package:tikal_time_tracker/pages/users/users_list_adapter.dart';
import 'package:tikal_time_tracker/data/repository/time_records_repository.dart';

class UsersPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
   // print("U
    //users: ${User.me.name}, Projects: ${User.me.projects}");
    return UsersPageState();
  }
}

class UsersPageState extends State<UsersPage> implements MembersViewContract{

  UsersPresenter presenter = UsersPresenter(repository: TimeRecordsRepository());
  bool loading = false;
  List<Member> _users;
  @override
  void initState() {
    super.initState();
    presenter.subscribe(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Users"),
        elevation: 1.0,
      ),
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
        padding: const EdgeInsets.only(top: 32.0, left: 16.0, right: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 1.5,
              color: Colors.black26,
            ),
            Container(
              padding: EdgeInsets.only(bottom: 2.0),
              child: Text("${User.me.name}, ${User.me.role}, ${User.me.company}"),
            ),
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