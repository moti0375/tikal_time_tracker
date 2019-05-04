import 'package:flutter/material.dart';
import 'package:tikal_time_tracker/pages/reports/place_holder_content.dart';
import 'package:tikal_time_tracker/data/models.dart';
import 'package:tikal_time_tracker/data/user.dart';
import 'package:tikal_time_tracker/ui/platform_appbar.dart';
import 'package:tikal_time_tracker/ui/time_record_list_adapter.dart';
import 'package:tikal_time_tracker/utils/action_choice.dart';
import 'package:tikal_time_tracker/utils/page_transition.dart';
import 'package:tikal_time_tracker/pages/send_email/send_email_page.dart';
import 'package:tikal_time_tracker/resources/strings.dart';
import 'package:tikal_time_tracker/analytics/analytics.dart';
import 'package:tikal_time_tracker/analytics/events/reports_event.dart';

class ReportPage extends StatelessWidget implements ListAdapterClickListener {
  final Report report;
  final Analytics analytics = Analytics();

  final List<Choice> choices = const <Choice>[
    const Choice(
        action: Action.SendEmail,
        title: Strings.action_send_email,
        icon: Icons.email)
  ];

  ReportPage({this.report}) {
    analytics.logEvent(
        ReportsEvent.impression(EVENT_NAME.REPORT_GENERATED_SUCCESS).open());
    // print("Total: ${report.getTotalString()}");
  }

  @override
  Widget build(BuildContext context) {
    void _select(Choice choice) {
      if (choice.action == Action.SendEmail) {
        analytics.logEvent(ReportsEvent.click(EVENT_NAME.ACTION_SEND_MAIL));

        //  print("Navigate to SendEmail page");
        Navigator.of(context).push(new PageTransition(widget: SendEmailPage()));
      }
    }

    Widget _buildAppBar({String title}) {
      return PlatformAppbar(
        title: Text(title),
        actions: PopupMenuButton<Choice>(
          onSelected: _select,
          itemBuilder: (BuildContext context) {
            return choices.map((Choice c) {
              return PopupMenuItem<Choice>(
                value: c,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[Icon(c.icon), Text(c.title)],
                ),
              );
            }).toList();
          },
        ),
      ).build(context);
    }

    return Scaffold(
      appBar: _buildAppBar(title: Strings.report_page_title),
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
          child: TimeRecordListAdapter(
            items: report.report,
            adapterClickListener: this,
            intermittently: false,
          ));
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
                  "${User.me.name}, ${User.me.company}, ${User.me.role.toString().split(".").last}",
                  textAlign: TextAlign.start,
                ),
                Text("${Strings.total} ${report.getTotalString()}",
                    textAlign: TextAlign.end)
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  onListItemClicked(TimeRecord item) {}

  @override
  onListItemLongClick(TimeRecord item) {}
}
