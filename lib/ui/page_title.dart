import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tikal_time_tracker/resources/colors.dart';
import 'package:tikal_time_tracker/services/auth/auth.dart';
import 'package:tikal_time_tracker/services/auth/user.dart';

class TimeTrackerPageTitle extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new PageTitleState();
  }
}


class PageTitleState extends State<TimeTrackerPageTitle>{

  User _user;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _user ??= Provider.of<BaseAuth>(context).getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: const EdgeInsets.only(right: 16.0, left: 16.0, top: 8.0, bottom: 8.0),
      child: new Row(
        children: <Widget>[
           Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(bottom: 2.0),
                      child: Text("${_user.name}, ${_user.role.toString().split(".").last}, ${_user.company}"),
                    )
                  ],
                ),
                Container(
                  height: 1.5,
                  color: AppColors.GeneralDividerGray,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}