import 'package:flutter/material.dart';
import 'package:tikal_time_tracker/utils/utils.dart';
import 'dart:async';


class TimeTrackerTimePicker extends StatelessWidget{

  var callback = (TimeOfDay time){};
  String hint;
  TimeOfDay pickedTime;
  TextEditingController startTimeController;

  TimeTrackerTimePicker({this.pickedTime, this.hint, this.callback}){
    if(this.pickedTime != null){
      startTimeController = new TextEditingController(
          text: Utils.buildTimeStringFromTime(pickedTime)) ;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 4.0, right: 4.0, top: 8.0),
      child: new Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                print("onTap TimePicker");
                _showStartTimeDialog(context);
              },
              child: Icon(Icons.access_time),
            ),
          ),
          Container(
            child: new Flexible(
                child: new TextField(
                    decoration: InputDecoration(
                        hintText: hint != null ? hint : "",
                        contentPadding:
                        EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0))),
                    maxLines: 1,
                    controller: startTimeController)),
          ),
        ],
      ),
    );
  }

  Future<Null> _showStartTimeDialog(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
        context: context,
        initialTime: pickedTime != null ? pickedTime : TimeOfDay.now());
    if (picked != null) {
      callback(picked);
    }
  }

}