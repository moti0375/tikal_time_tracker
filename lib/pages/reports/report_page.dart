import 'package:flutter/material.dart';
import 'place_holder_content.dart';
import '../../data/models.dart';
import '../../data/user.dart';

class ReportPage extends StatelessWidget {
  final Report report;

  ReportPage({this.report}) {
    print("Total: ${report.getTotalString()}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Report"),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 0,
            child: _createTitle(context),
          ),
          Expanded(flex: 1, child: _buildContent())
        ],
      ),
    );
  }

  _buildContent() {
    if (report == null || report.report.isEmpty) {
      return PlaceholderContent();
    } else {
      return Container(
          padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 10.0),
          child: _buildListView(report.report));
    }
  }

  Widget _createTitle(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 1,
      padding: const EdgeInsets.only(
          right: 32.0, left: 32.0, top: 16.0, bottom: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(bottom: 2.0),
            child: Text(
              "Report: ${report.startDate.day}/${report.startDate.month}/${report.startDate.year} - ${report.endDate.day}/${report.endDate.month}/${report.endDate.year}",
              style: TextStyle(fontSize: 20.0, color: Colors.black45),
            ),
          ),
          Container(
            height: 1.5,
            color: Colors.black26,
          ),
          Container(
            padding: EdgeInsets.only(bottom: 2.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "${User().name}, ${User().company}, ${User().role}",
                  textAlign: TextAlign.start,
                ),
                Text("Total: ${report.getTotalString()}",
                    textAlign: TextAlign.end)
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildListRow(TimeRecord timeRecord, Color color) {
    print("_buildListRow: task = ${timeRecord.task}");

    return new Card(
      color: color,
      elevation: 1.0,
      margin: EdgeInsets.symmetric(vertical: 1.0, horizontal: 1.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Flexible(
            child: Row(
              children: <Widget>[
                Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 5.0, vertical: 1.0),
                    child: Text(timeRecord.project,
                        style: TextStyle(
                            fontSize: 23.0, fontWeight: FontWeight.bold))),
                SizedBox(width: 2.0),
                Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 5.0, vertical: 1.0),
                    child: Text(timeRecord.task,
                        style: TextStyle(
                            fontSize: 23.0, fontWeight: FontWeight.bold))),
              ],
            ),
          ),
          Flexible(
            child: Row(
              children: <Widget>[
                Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 5.0, vertical: 1.0),
                    child: Text(
                        "${timeRecord.dateTime.day}/${timeRecord.dateTime.month}/${timeRecord.dateTime.year}",
                        style: TextStyle(fontSize: 12.0))),
                SizedBox(width: 2.0),
                Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 1.0, vertical: 1.0),
                    child: Text(
                        "${timeRecord.start.hour}:${timeRecord.start.minute}",
                        style: TextStyle(fontSize: 12.0))),
                Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 1.0, vertical: 1.0),
                    child: Text("-", style: TextStyle(fontSize: 12.0))),
                Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 1.0, vertical: 1.0),
                    child: Text(
                        "${timeRecord.finish.hour}:${timeRecord.finish.minute}",
                        style: TextStyle(fontSize: 12.0))),
                SizedBox(width: 2.0),
                Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.0, vertical: 1.0),
                    child: Text(",", style: TextStyle(fontSize: 12.0))),
                Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 1.0, vertical: 1.0),
                    child: Text(timeRecord.getDurationString(),
                        style: TextStyle(fontSize: 12.0))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListView(List<TimeRecord> items) {
    print("_buildListView");
    DateTime day;

    Color evenColor = Colors.white;
    Color oddColor = Colors.grey[200];
    Color color = evenColor;

    return ListView.builder(
        itemBuilder: (context, i) {
          print("$i ${items[i].dateTime.day} ");

          if (day != null && (items[i].dateTime.day != day.day)) {
            if (color == evenColor) {
              color = oddColor;
            } else {
              color = evenColor;
            }
          }

          day = items[i].dateTime;
          return _buildListRow(items[i], color);
        },
        shrinkWrap: true,
        itemCount: items == null ? 0 : items.length);
  }
}
