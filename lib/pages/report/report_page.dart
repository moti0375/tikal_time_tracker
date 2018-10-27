import 'package:flutter/material.dart';
import 'package:tikal_time_tracker/pages/reports/place_holder_content.dart';
import 'package:tikal_time_tracker/data/models.dart';
import 'package:tikal_time_tracker/data/user.dart';
import 'package:tikal_time_tracker/ui/time_record_list_adapter.dart';
class ReportPage extends StatelessWidget implements ListAdapterClickListener{
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
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: TimeRecordListAdapter(items: report.report, adapterClickListener: this, intermittently: false,));
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
                  "${User.me.name}, ${User.me.company}, ${User.me.role}",
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

  @override
  onListItemClicked(TimeRecord item) {
    print("Item Clicked: $item");
  }

  @override
  onListItemLongClick(TimeRecord item) {
    print("Item LongClicked: $item");
  }
}
