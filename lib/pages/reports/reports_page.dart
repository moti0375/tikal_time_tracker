import 'package:flutter/material.dart';
import 'list_item_builder.dart';
import '../../data/models.dart';
import '../../data/user.dart';
import '../../data/repository/time_records_repository.dart';
import 'dart:async';

class ReportPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return ReportPageState();
  }
}

class ReportPageState extends State<ReportPage>{

  @override
  initState(){
    super.initState();
  }

  Widget build(BuildContext context) {
    print("ReportPage build: ${User().name}");
    return Scaffold(
      appBar: AppBar(
        title: Text("Reports"),
        elevation: 1.0,
      ),
      body: _buildContent(),
      backgroundColor: Colors.white,
    );
  }

  Widget _buildBody() {
    return Container();
  }

  Widget _buildContent() {
    return new ListItemBuilder<TimeRecord>(
        items: null,
        itemBuilder: (context, mockReport) {
          return Center(
            child: Text(mockReport.project),
          );
        });
  }
}
