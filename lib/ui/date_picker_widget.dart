import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class TimeTrackerDatePicker extends StatelessWidget {
  static const weekendDay = DateTime.saturday;
  final DateTime initializedDateTime;
  final String hint;
  final Function(DateTime dateTime) onSubmittedCallback;
  final RegExp datePattern = RegExp("^[0-3]?[0-9]/[0-1]?[0-9]/[2]?[0]?[0-9]{2}\$");
  final DateFormat dateFormat = DateFormat("d/M/y");
  final TextEditingController dateInputController = TextEditingController();

  TimeTrackerDatePicker({this.initializedDateTime, this.onSubmittedCallback, this.hint}){
    dateInputController.text = dateFormat.format(initializedDateTime);
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
                print("datePicker onTap dateInput");
                _showDatePicker(context);
              },
              child: Icon(Icons.date_range),
            ),
          ),
          Container(
            child: new Flexible(
                child: new TextField(
                    keyboardType: TextInputType.datetime,
                    onSubmitted: (value) {
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
        initialDate: initializedDateTime.weekday == weekendDay ? DateTime(DateTime.now().year, DateTime.now().month, 1) :  initializedDateTime ,
        selectableDayPredicate: (DateTime val) =>
        val.weekday == weekendDay ? false : true,
        firstDate: DateTime(DateTime.now().year - 1, 1),
        lastDate: DateTime(DateTime.now().year + 1, 12));
    if (picked != null) {
      _onDateSelected(picked);
    }
  }

  DateTime getDefaultWeekday(){
    var firstDayOfMonth  = DateTime(DateTime.now().year, DateTime.now().month, 1);
    if(firstDayOfMonth.weekday == weekendDay){
      return DateTime(DateTime.now().year, DateTime.now().month, 2);
    } else {
      return firstDayOfMonth;
    }
  }

  void _validator(String value) {
    Match match = datePattern.firstMatch(value);
    if (match != null) {
      print("matched: $value");
      DateTime date = dateFormat.parse(value);
      print("entered date: ${date.day}:${date.month}:${date.year}");
      _onDateSelected(date);
      SystemChannels.textInput.invokeMethod('TextInput.hide');
    } else {
      onSubmittedCallback(null);
    }
  }

  void _onDateSelected(DateTime date) {
    onSubmittedCallback(date);
  }
}

class DatePickerOnPickedListener {
  void onDateSelected(DateTime selectedDate) {}
}
