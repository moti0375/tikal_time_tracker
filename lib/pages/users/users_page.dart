import 'package:flutter/material.dart';
import '../../data/member.dart';
import '../../data/user.dart';
import 'users_presenter.dart';
import 'users_contract.dart';
import '../../data/repository/time_records_repository.dart';

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
    return Container();
  }

  @override
  void showMembers(List<Member> users) {
    setState(() {
      _users = users;
    });
  }
}