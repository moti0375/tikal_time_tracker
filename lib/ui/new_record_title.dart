import 'package:flutter/material.dart';
import 'dart:async';

class NewRecordTitle extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new PageTitleState();
  }
}


class PageTitleState extends State<NewRecordTitle>{

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: const EdgeInsets.only(right: 32.0, left: 32.0, top: 32.0),
      child: new Row(
        children: <Widget>[
           Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(left: 2.0),
                      child: Text("Editing Time Record", style: TextStyle(fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
                Container(
                  height: 1.5,
                  color: Colors.black26,
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 2.0),
                  child: Text("Moti Bartov, User, Tikal"),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}