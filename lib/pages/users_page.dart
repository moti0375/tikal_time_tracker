import 'package:flutter/material.dart';


class UsersPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return UsersPageState();
  }
}

class UsersPageState extends State<UsersPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Users"),
        elevation: 1.0,
      ),
      body: _buildBody(),
      backgroundColor: Colors.blueGrey,
    );
  }

  Widget _buildBody(){
    return Container();
  }
}