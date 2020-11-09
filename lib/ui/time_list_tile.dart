import 'package:flutter/material.dart';
import 'package:tikal_time_tracker/data/models.dart';
import 'package:tikal_time_tracker/utils/utils.dart';

class TimeListTile extends StatelessWidget {

  final TimeRecord timeRecord;
  final VoidCallback onTap;
  final VoidCallback onLongClick;
  const TimeListTile({Key key, this.timeRecord, this.onTap, this.onLongClick}) : super(key: key);


  List<Widget> _buildTitleRow(TimeRecord timeRecord) {
    if (timeRecord.userName != null) {
      return [
        Text("${timeRecord.userName}", style: TextStyle(fontSize: 15.0)),
        Text("${timeRecord.project.name}", style: TextStyle(fontSize: 15.0)),
        Text("${timeRecord.task.name}", style: TextStyle(fontSize: 15.0))
      ];
    } else {
      return [
        Text("${timeRecord.project.name}", style: TextStyle(fontSize: 15.0)),
        Text("${timeRecord.task.name}", style: TextStyle(fontSize: 15.0))
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
      return ListTile(
        dense: true,
        onTap: onTap,
        onLongPress: onLongClick,
        leading: Icon(Icons.work, color: Colors.black54,),
        title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: _buildTitleRow(timeRecord)),
        subtitle: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
                "${timeRecord.date.day}/${timeRecord.date.month}/${timeRecord.date.year}",
                style: TextStyle(fontSize: 12.0)),
            SizedBox(
              width: 4.0,
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 1.0, vertical: 0.0),
                child: Text(
                    timeRecord.start == null
                        ? "No Start"
                        : "${Utils.buildTimeStringFromTime(timeRecord.start)} - " +
                        (timeRecord.finish == null
                            ? "No End"
                            : "${Utils.buildTimeStringFromTime(timeRecord.finish)}"),
                    style: TextStyle(fontSize: 12.0))),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
                child: Text(",", style: TextStyle(fontSize: 12.0))),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 1.0, vertical: 1.0),
                child: timeRecord.duration == null
                    ? Text(
                  "Uncompleted",
                  style: TextStyle(color: Colors.red),
                )
                    : Text(timeRecord.getDurationString(),
                    style: TextStyle(fontSize: 12.0))),
            SizedBox(
              width: 4.0,
            ),
            Expanded(
                child: Text(timeRecord.comment,
                    style: TextStyle(
                      fontSize: 12.0,
                    ),
                    softWrap: false,
                    maxLines: 1,
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis))
          ],
        ),
      );
  }
}
