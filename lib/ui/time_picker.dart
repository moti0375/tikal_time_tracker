import 'package:flutter/material.dart';
import 'package:tikal_time_tracker/utils/utils.dart';
import 'dart:async';
import 'package:intl/intl.dart';


class TimeTrackerTimePicker extends StatefulWidget {

  final String pickerName;
  final callback;
  final onSubmitCallback;
  final String hint;
  final TimeOfDay initialTimeValue;
  final RegExp timePattern = RegExp("^([01]?[0-9]|2[0-3]):[0-5][0-9]\$");
  final RegExp simpleTimePattern = RegExp("^([01]?[0-9]|2[0-3])\$");
  final DateFormat timeFormatter = DateFormat('H:mm');
  final DateFormat simpleTimeFormatter = DateFormat('H');

  final List<DateFormat> timeFormats = List<DateFormat>();
  final List<RegExp> timePatterns = List<RegExp>();
  final FocusNode focusNode;

  TimeTrackerTimePicker({this.pickerName, this.initialTimeValue, this.hint, this.callback, this.focusNode, this.onSubmitCallback}){
   timeFormats.add(timeFormatter);
   timeFormats.add(simpleTimeFormatter);

   timePatterns.add(timePattern);
   timePatterns.add(simpleTimePattern);
  }

  void requestFocus(BuildContext  context){
    print("${this.pickerName} requestFocus...");
    FocusScope.of(context).requestFocus(focusNode);
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

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(() {
      if (!widget.focusNode.hasFocus) {
        print("${widget.pickerName} has remove focus, calling submitValidator");
        entryValidator(buffer);
      }
    });

    _setPickerController(_pickedTime);
    if (widget.initialTimeValue != null) {
//      print("Initial time not null: ${widget.initialTimeValue}");
      _pickedTime = widget.initialTimeValue;
    }
    _setPickerController(_pickedTime);
  }

  @override
  void dispose() {
    super.dispose();
    print("dispose");
    widget.focusNode.dispose();
  }

  void _setPickerController(TimeOfDay time){
    pickerController = TextEditingController(text: time != null ? Utils.buildTimeStringFromTime(time) : "");
    pickerController.addListener((){
      buffer = pickerController.text;
      typeValidator(buffer);
    });
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
                    focusNode: widget.focusNode,
                    onFieldSubmitted: onSubmitButtonClicked,
                    decoration: InputDecoration(
                        labelText: widget.hint != null ? widget.hint : "",
                        hintText: "HH:MM",
                        contentPadding:
                        EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 12.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)
                        )
                    ),
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
    TimeOfDay time = _validator(value);
//    print("Type validator: $value, Time: ${time.toString()}");

    if(time != null){
      widget.callback(time);
    }else{
      widget.callback(null);
    }
  }

  void onSubmitButtonClicked(String value){
    widget.focusNode.unfocus();
    submitValidator(value);
  }

  void entryValidator(String value){
    TimeOfDay time = _validator(value);
    if(time != null){
      _onTimeSelected(time);
    }else{
      widget.callback(null);
    }
  }

  void submitValidator(String value){
    widget.onSubmitCallback();
//    print("submitValidator: $value");
   entryValidator(value);
  }

  TimeOfDay _validator(String value) {

    RegExp validExp = widget.timePatterns.firstWhere((tester){
       return tester.firstMatch(value) != null ;
    },orElse: (){
      return null;
    });

    if(validExp != null){
      for(final formatter in widget.timeFormats){
        try{
          TimeOfDay timeOfDay = TimeOfDay.fromDateTime(formatter.parse(value));
//          print("Parsing success: ${timeOfDay.toString()}" );
          return timeOfDay;
        }catch(e){
          print("Parsing faild: ${e.toString()}");
        }
      }
    }

    return null;
/*
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
    */
  }

  void _onTimeSelected(TimeOfDay time) {
    widget.callback(time);
    setState(() {
      _pickedTime = time;
      TextEditingValue value = TextEditingValue(text: Utils.buildTimeStringFromTime(time));
      pickerController.value = value;
    });
  }

}