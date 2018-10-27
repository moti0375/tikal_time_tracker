import 'package:flutter/material.dart';
import 'dart:async';

class TimeTrackerDatePicker extends StatelessWidget{

  DateTime dateTime;
  DatePickerOnPickedListener onPickedListener;
  TextEditingController dateInputController;
  String hint;
  var callback = (DateTime d){};


  TimeTrackerDatePicker({this.dateTime, this.callback, this.hint}){
    if(this.dateTime != null){
      dateInputController = new TextEditingController(
          text: "${dateTime.day}/${dateTime.month}/${dateTime.year}");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 2.0, bottom: 2.0),
      child: new Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                print("datPicker onTap dateInput");
                _showDatePicker(context);
              },
              child: Icon(Icons.date_range),
            ),
          ),
          Container(
            child: new Flexible(
                child: new TextField(
                    decoration: InputDecoration(
                        hintText: hint != null ? hint : "Date",
                        contentPadding:
                        EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0))),
                    maxLines: 1,
                    controller: dateInputController)),
          ),
        ],
      ),
    );
  }

  Future<Null> _showDatePicker(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year - 1, 1),
        lastDate: DateTime(DateTime.now().year, 12));
    if (picked != null) {
      callback(picked);
    }
  }
}

class DatePickerOnPickedListener{
  void onDateSelected(DateTime selectedDate){}
}