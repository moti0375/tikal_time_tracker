import 'package:flutter/material.dart';
import '../data/user.dart';

class TimeTrackerPageTitle extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new PageTitleState();
  }
}


class PageTitleState extends State<TimeTrackerPageTitle>{

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
                      child: Text("${User.me.name}, ${User.me.role.toString().split(".").last}, ${User.me.company}"),
                    )
                  ],
                ),
                Container(
                  height: 1.5,
                  color: Colors.black26,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}