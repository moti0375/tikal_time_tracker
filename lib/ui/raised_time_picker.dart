import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tikal_time_tracker/analytics/analytics.dart';
import 'package:tikal_time_tracker/analytics/events/time_event.dart';
import 'package:tikal_time_tracker/services/auth/user.dart';

class RaisedTimePicker extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.only(left: 4.0, right: 4.0, top: 8.0),
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                },
                child: Icon(Icons.access_time),
              ),
            ),
            Container(
              child: new Flexible(
                  flex: 4,
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.pink[800],// set border color
                            width: 3.0)
                    ),
                    child: Text(
                      "",
                    textAlign: TextAlign.start,
                    ),
                  ),
              ),
            ),
            Flexible(
              flex: 1,
              child: RaisedButton(
                  child: Text(
                    "Now",
                    style: TextStyle(fontSize: 12.0),
                  ),
                  textColor: Colors.white,
                  shape: CircleBorder(),
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    Analytics.instance
                        .logEvent(TimeEvent.click(EVENT_NAME.TIME_PICKER_NOW).
                    setUser(User.me.name));
//                    _onTimeSelected(TimeOfDay.fromDateTime(DateTime.now()));
                  }),
            ),
          ],
        ),
      ),
    );
  }
}