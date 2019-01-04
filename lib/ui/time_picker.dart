import 'package:flutter/material.dart';
import 'package:tikal_time_tracker/utils/utils.dart';
import 'dart:async';
import 'package:intl/intl.dart';


class TimeTrackerTimePicker extends StatefulWidget {

  final callback;
  final onSubmitCallback;
  final String hint;
  final TimeOfDay initialTimeValue;
  final RegExp timePattern = RegExp("^([01]?[0-9]|2[0-3]):[0-5][0-9]\$");
  final RegExp simpleTimePattern = RegExp("^([01]?[0-9]|2[0-3])\$");
  final DateFormat timeFormatter = DateFormat('H:m');
  final DateFormat simpleTimeFormatter = DateFormat('H');


  TimeTrackerTimePicker({this.initialTimeValue, this.hint, this.callback, this.onSubmitCallback});

  void requestFocus(BuildContext  context){

  }

  void revokeFocus(){
  }

  @override
  State<StatefulWidget> createState() {
    return TimePickerState();
  }
}


class TimePickerState extends State<TimeTrackerTimePicker> {
  TextEditingController pickerController;
  TimeOfDay _pickedTime;
  String buffer;
  FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    print("TimePicker init state");
    focusNode.addListener(() {
      print("TimePickerFocus: ${focusNode.hasFocus}");
      if (!focusNode.hasFocus) {
        submitValidator(buffer);
      }
    });
    if (widget.initialTimeValue != null) {
      print("Initial time not null");
      _pickedTime = widget.initialTimeValue;
    }
    _setPickerController(_pickedTime);
  }

  @override
  void dispose() {
    super.dispose();
    print("dispose");
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
//                print("onTap TimePicker");
                _showStartTimeDialog(context);
              },
              child: Icon(Icons.access_time),
            ),
          ),
          Container(
            child: new Flexible(
                child: new TextFormField(
                    textInputAction: TextInputAction.next,
                    focusNode: focusNode,
                    onFieldSubmitted: onSubmitButtonClicked,
                    decoration: InputDecoration(
                        hintText: widget.hint != null ? widget.hint : "",
                        contentPadding:
                        EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0))),
                    maxLines: 1,
                    controller: pickerController)),
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
//    print("Type validator: $value");
    TimeOfDay time = _validator(value);
    if(time != null){
      widget.callback(time);
    }
  }

  void onSubmitButtonClicked(String value){
    focusNode.unfocus();
    submitValidator(value);
  }

  void submitValidator(String value){
    widget.onSubmitCallback();
//    print("submitValidator: $value");
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
//      print("_validator: simpleMatch ${simpleMatch.toString()}");
      TimeOfDay time = TimeOfDay.fromDateTime(
          widget.simpleTimeFormatter.parse(value));
      return time;
    } else if (match != null) {
//      print("_validator: ${match.toString()}");
      TimeOfDay time = TimeOfDay.fromDateTime(
          widget.timeFormatter.parse(value));
      return time;
    } else {
//      print("_validator: no match");
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
      _setPickerController(_pickedTime);
    });
  }

  void _setPickerController(TimeOfDay time){
    if(time != null){
      pickerController =
          TextEditingController(
              text: Utils.buildTimeStringFromTime(time));
    }else{
      pickerController = TextEditingController();
    }
    pickerController.addListener((){
      buffer = pickerController.text;
      typeValidator(buffer);
    });
  }
}