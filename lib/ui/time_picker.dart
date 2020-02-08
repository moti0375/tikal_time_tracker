import 'package:flutter/material.dart';
import 'package:tikal_time_tracker/analytics/analytics.dart';
import 'package:tikal_time_tracker/analytics/events/time_event.dart';
import 'package:tikal_time_tracker/resources/strings.dart';
import 'package:tikal_time_tracker/services/auth/user.dart';
import 'package:tikal_time_tracker/ui/unfocusable_input_text_field.dart';
import 'package:tikal_time_tracker/utils/utils.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class TimeTrackerTimePicker extends StatelessWidget {
  final String pickerName;
  final ValueChanged<TimeOfDay> onTimeSelected;
  final VoidCallback onNowButtonClicked;
  final String hint;
  final TimeOfDay initialTimeValue;

  TimeTrackerTimePicker(
      {this.pickerName,
      this.initialTimeValue,
      this.hint,
      this.onTimeSelected,
      this.onNowButtonClicked});

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
                Analytics.instance.logEvent(TimeEvent.click(EVENT_NAME.TIME_PICKER_ICON));
                _showStartTimeDialog(context);
              },
              child: Icon(Icons.access_time),
            ),
          ),
          Container(
            child: new Flexible(
              flex: 4,
              child: UnFocusableInputTextField(
                textValue: initialTimeValue != null
                    ? Utils.buildTimeStringFromTime(initialTimeValue)
                    : Strings.empty_string,
                hint: hint ?? Strings.empty_string,
                onTap: () => _showStartTimeDialog(context),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: RaisedButton(
                child: Text(
                  "Now",
                  style: TextStyle(fontSize: 14.0),
                ),
                textColor: Colors.white,
                shape: CircleBorder(),
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  onNowButtonClicked();
                  onTimeSelected(TimeOfDay.fromDateTime(DateTime.now()));
                }),
          ),
        ],
      ),
    );
  }

  Future<Null> _showStartTimeDialog(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
        context: context,
        initialTime:
            initialTimeValue != null ? initialTimeValue : TimeOfDay.now());
    if (picked != null) {
      onTimeSelected(picked);
    }
  }
}
