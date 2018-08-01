import 'package:flutter/material.dart';
import 'dart:async';

class TimePageTitle extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new TimePageTitleState();
  }
}


class TimePageTitleState extends State<TimePageTitle>{

  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: const EdgeInsets.all(32.0),
      child: new Row(
        children: <Widget>[
           Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          _showDateDialog();
                        },
                        child: Icon(Icons.date_range),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 2.0),
                      child: Text("Time: ${selectedDate.day}-${selectedDate.month}-${selectedDate.year}", style: TextStyle(fontWeight: FontWeight.bold)),
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

  Future<Null> _showDateDialog() async {
    final DateTime picked = await showDatePicker(context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(selectedDate.year-1, 1),
        lastDate: DateTime(selectedDate.year, 12));

    if(picked != null && picked != selectedDate){
      setState(() {
        selectedDate = picked;
      });
    }
  }
}