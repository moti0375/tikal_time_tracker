import 'package:flutter/material.dart';
import 'package:tikal_time_tracker/utils/utils.dart';
import 'dart:async';
import 'package:intl/intl.dart';


class TimeTrackerTimePicker extends StatefulWidget {

  var callback = (TimeOfDay time) {};
  String hint;
  TimeOfDay initialTimeValue;
  RegExp timePattern;
  RegExp simpleTimePattern;
  DateFormat timeFormatter = DateFormat('H:m');
  DateFormat simpleTimeFormatter = DateFormat('H');


  TimeTrackerTimePicker({this.initialTimeValue, this.hint, this.callback}) {
    timePattern = RegExp("^([01]?[0-9]|2[0-3]):[0-5][0-9]\$");
    simpleTimePattern = RegExp("^([01]?[0-9]|2[0-3])\$");
  }


  @override
  State<StatefulWidget> createState() {
    return TimePickerState();
  }
}


class TimePickerState extends State<TimeTrackerTimePicker> {
  TextEditingController startTimeController;
  TimeOfDay _pickedTime;
  FocusNode focusNode;
  String buffer;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        submitValidator(buffer);
      }
    });
    if (widget.initialTimeValue != null) {
      print("Initial time not null");
      _pickedTime = widget.initialTimeValue;
      startTimeController = TextEditingController(
          text: Utils.buildTimeStringFromTime(_pickedTime));

      // _onTimeSelected(widget.initialTimeValue);
    }
  }

  @override
  void dispose() {
    super.dispose();
    focusNode.dispose();
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
                    onSubmitted: submitValidator,
                    onChanged: (value){
                      buffer = value;
                      typeValidator(value);
                    },
                    focusNode: focusNode,
                    decoration: InputDecoration(
                        hintText: widget.hint != null ? widget.hint : "",
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
        initialTime: widget.initialTimeValue != null
            ? widget.initialTimeValue
            : TimeOfDay.now());
    if (picked != null) {
      _onTimeSelected(picked);
    }
  }

  void typeValidator(String value){
    TimeOfDay time = _validator(value);
    if(time != null){
      widget.callback(time);
    }
  }

  void submitValidator(String value){
    print("submitValidator: $value");
    TimeOfDay time = _validator(value);
    if(time != null){
      _onTimeSelected(time);
    }else{
      widget.callback(null);
    }
  }

  TimeOfDay _validator(String value) {
    print("validating: $value");
    var simpleMatch = widget.simpleTimePattern.firstMatch(value);
    Match match = widget.timePattern.firstMatch(value);

    if (simpleMatch != null) {
      print("_validator: simpleMatch ${simpleMatch.toString()}");
      TimeOfDay time = TimeOfDay.fromDateTime(
          widget.simpleTimeFormatter.parse(value));
      return time;
    } else if (match != null) {
      print("_validator: ${match.toString()}");
      TimeOfDay time = TimeOfDay.fromDateTime(
          widget.timeFormatter.parse(value));
      return time;
    } else {
      print("_validator: no match");
      return null;
    }
  }


  void _handleSimpleTimeMatch() {

  }

  void _handleTimeMatch() {

  }

  void _onTimeSelected(TimeOfDay time) {
    widget.callback(time);
    setState(() {
      _pickedTime = time;
      startTimeController =
          TextEditingController(
              text: Utils.buildTimeStringFromTime(_pickedTime));
    });
  }
}