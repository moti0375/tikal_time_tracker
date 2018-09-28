import 'package:flutter/material.dart';


class ProfilePage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return ProfilePageState();
  }
}

class ProfilePageState extends State<ProfilePage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        elevation: 1.0,
      ),
      body: _buildBody(),
      backgroundColor: Colors.black12,
    );
  }

  Widget _buildBody(){
    return Container();
  }
}