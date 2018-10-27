import 'package:flutter/material.dart';
import 'package:tikal_time_tracker/utils/utils.dart';
import 'dart:async';
import 'package:intl/intl.dart';


class TimeTrackerTimePicker extends StatelessWidget{

  var callback = (TimeOfDay time){};
  String hint;
  TimeOfDay pickedTime;
  TextEditingController startTimeController;
  RegExp timePatter;
  DateFormat timeFormat = DateFormat('H:m');


  TimeTrackerTimePicker({this.pickedTime, this.hint, this.callback}){
    timePatter = RegExp("^[0-9]{1,2}:[1-5][0-9]\$");
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
                    onChanged: _validator,
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

  void _validator(String value){
    Match match = timePatter.firstMatch(value);
    if(match != null){
      print("_validator: ${match.toString()}");
      TimeOfDay time = TimeOfDay.fromDateTime(timeFormat.parse(value));
      callback(time);
    }else{
      callback(null);
    }

  }

}