import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class TimeTrackerDatePicker extends StatefulWidget{

  DateTime initializedDateTime;
  DatePickerOnPickedListener onPickedListener;
  String hint;
  var onSubmittedCallback = (DateTime d){};
  RegExp datePattern = RegExp("^[0-3]?[0-9]/[0-1]?[0-9]/[2]?[0]?[0-9]{2}\$");
  DateFormat dateFormat = DateFormat("d/M/y");
  String dateString;

  TimeTrackerDatePicker({this.initializedDateTime, this.onSubmittedCallback, this.hint});

  @override
  State<StatefulWidget> createState() {
    return DatePickerState();
  }
}


class DatePickerState extends State<TimeTrackerDatePicker>{
  TextEditingController dateInputController;
  DateTime _dateTime;
  @override
  void initState() {
    super.initState();
    if(widget.initializedDateTime != null){
      _dateTime = widget.initializedDateTime;
      dateInputController = new TextEditingController(
          text: "${_dateTime.day}/${_dateTime.month}/${_dateTime.year}");
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
                      _validator(value);
                    },
                    decoration: InputDecoration(
                        hintText: widget.hint != null ? widget.hint : "Date",
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
        initialDate: _dateTime,
        firstDate: DateTime(DateTime.now().year - 1, 1),
        lastDate: DateTime(DateTime.now().year, 12));
    if (picked != null) {
      _onDateSelected(picked);
    }
  }

  void _validator(String value){
    Match match = widget.datePattern.firstMatch(value);
    if(match != null){
      print("matched: $value");
      DateTime date = widget.dateFormat.parse(value);
      print("entered date: ${date.day}:${date.month}:${date.year}");
      _onDateSelected(date);
    }else{
      _dateTime = null;
      widget.onSubmittedCallback(null);
    }
  }

  void _onDateSelected(DateTime date){
    widget.onSubmittedCallback(date);
    setState(() {
      _dateTime = date;
      dateInputController = new TextEditingController(
          text: "${_dateTime.day}/${_dateTime.month}/${_dateTime.year}");
    });
  }

}

class DatePickerOnPickedListener{
  void onDateSelected(DateTime selectedDate){}
}