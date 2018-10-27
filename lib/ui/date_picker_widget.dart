import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class TimeTrackerDatePicker extends StatelessWidget{

  DateTime dateTime;
  DatePickerOnPickedListener onPickedListener;
  TextEditingController dateInputController;
  String hint;
  var onSubmittedCallback = (DateTime d){};
  var onChangedCallback = (DateTime date){};
  RegExp datePattern = RegExp("^[0-3]?[0-9]/[0-1]?[0-9]/[2]?[0]?[0-9]{2}\$");
  DateFormat dateFormat = DateFormat("d/M/y");
  String dateString;

  TimeTrackerDatePicker({this.dateTime, this.onSubmittedCallback, this.hint}){
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
                    onSubmitted: (value){
                      _onSubmit();
                    },
                    onChanged: (value){
                      _validator(value);
                    },
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
      onSubmittedCallback(picked);
    }
  }
  
  void _validator(String value){
    Match match = datePattern.firstMatch(value);
    if(match != null){
      print("matched: $value");
      dateTime = dateFormat.parse(value);
      print("entered date: ${dateTime.day}-${dateTime.month}-${dateTime.year}");
      if(onChangedCallback != null){
        onChangedCallback(dateTime);
      }
    }else{
      dateTime = null;
    }
  }

  void _onSubmit(){
    onSubmittedCallback(dateTime);
  }
}

class DatePickerOnPickedListener{
  void onDateSelected(DateTime selectedDate){}
}