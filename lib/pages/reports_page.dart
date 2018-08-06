import 'package:flutter/material.dart';


class ReportPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return ReportPageState();
  }
}

class ReportPageState extends State<ReportPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reports"),
        elevation: 1.0,
      ),
      body: _buildBody(),
      backgroundColor: Colors.greenAccent,
    );
  }

  Widget _buildBody(){
    return Container();
  }
}