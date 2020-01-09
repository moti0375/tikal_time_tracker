import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tikal_time_tracker/pages/report/report_page_bloc.dart';
import 'package:tikal_time_tracker/pages/report/report_page_event.dart';
import 'package:tikal_time_tracker/pages/report/report_page_state_model.dart';
import 'package:tikal_time_tracker/pages/reports/place_holder_content.dart';
import 'package:tikal_time_tracker/data/models.dart';
import 'package:tikal_time_tracker/services/auth/auth.dart';
import 'package:tikal_time_tracker/services/auth/user.dart';
import 'package:tikal_time_tracker/services/locator/locator.dart';
import 'package:tikal_time_tracker/storage/preferences.dart';
import 'package:tikal_time_tracker/ui/platform_appbar.dart';
import 'package:tikal_time_tracker/ui/time_record_list_builder.dart';
import 'package:tikal_time_tracker/utils/action_choice.dart';
import 'package:tikal_time_tracker/utils/page_transition.dart';
import 'package:tikal_time_tracker/pages/send_email/send_email_page.dart';
import 'package:tikal_time_tracker/resources/strings.dart';
import 'package:tikal_time_tracker/analytics/analytics.dart';
import 'package:tikal_time_tracker/analytics/events/reports_event.dart';

class ReportPage extends StatelessWidget {
  final ReportPageBloc bloc;
  final Analytics analytics = Analytics.instance;

  final List<Choice> choices = <Choice>[
    Choice(
        action: MenuAction.SendEmail,
        title: Strings.action_send_email,
        icon: Icons.email),
    Choice(
        action: MenuAction.ReportAnalysis,
        title: Strings.action_report_analysis,
        icon: Icons.assessment)
  ];

  List<Choice> _buildChoices(bool didUserSawAnalysisOption, bool reportEmpty) {
    if (reportEmpty) {
      return null;
    }

    var choices = <Choice>[
      Choice(
          action: MenuAction.SendEmail,
          title: Strings.action_send_email,
          icon: Icons.email),
      Choice(
        action: MenuAction.ReportAnalysis,
        title: Strings.action_report_analysis,
        icon: Icons.assessment,
        textSpans: didUserSawAnalysisOption == null
            ? []
            : [
                TextSpan(
                    text: ' New!!',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.red))
              ],
      )
    ];
    return choices;
  }

  ReportPage({this.bloc});

  @override
  Widget build(BuildContext context) {
    void _select(Choice choice) {
      if (choice.action == MenuAction.SendEmail) {
        analytics.logEvent(ReportsEvent.click(EVENT_NAME.ACTION_SEND_MAIL)
            .setUser(User.me.name));

        //  print("Navigate to SendEmail page");
        Navigator.of(context).push(new PageTransition(widget: SendEmailPage()));
      }

      if (choice.action == MenuAction.ReportAnalysis) {
        bloc.dispatchEvent(OnAnalysisItemClick(context));
      }
    }

    Widget _buildAppBar(
        {String title, bool userSawAnalysisOption, bool reportEmpty}) {
      return PlatformAppbar(
        heroTag: "ReportPage",
        title: Text(title),
        actions: _buildChoices(userSawAnalysisOption, reportEmpty),
        onPressed: _select,
        notificationEnabled:
            userSawAnalysisOption == null ? true : !userSawAnalysisOption,
      ).build(context);
    }

    return StreamBuilder<ReportPageStateModel>(
        stream: bloc.reportStream,
        initialData: ReportPageStateModel(),
        builder: (context, snapshot) {
          return Scaffold(
            appBar: _buildAppBar(
                title: Strings.report_page_title,
                userSawAnalysisOption: snapshot.data.userSawAnalysisOption,
                reportEmpty: _isReportEmpty(snapshot.data)),
            body: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 0,
                  child: _createTitle(context, snapshot.data),
                ),
                Expanded(flex: 1, child: _buildContent(snapshot.data))
              ],
            ),
          );
        });
  }

  _buildContent(ReportPageStateModel data) {
    if (_isReportEmpty(data)) {
      print("_buildContent: emptyReport");
      return Column(
        children: <Widget>[
          PlaceholderContent(
            subtitle: "",
          ),
        ],
      );
    } else {
      print("_buildContent: showing report");
      return Container(
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: TimeRecordListViewBuilder(
            items: data.timeTrackerReport.report,
            intermittently: false,
            dismissibleItems: false,
          ));
    }
  }

  Widget _createTitle(BuildContext context, ReportPageStateModel data) {
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
              data.timeTrackerReport != null
                  ? "Report: ${data.timeTrackerReport.startDate.day}/${data.timeTrackerReport.startDate.month}/${data.timeTrackerReport.startDate.year} - ${data.timeTrackerReport.endDate.day}/${data.timeTrackerReport.endDate.month}/${data.timeTrackerReport.endDate.year}"
                  : "",
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
                Text(
                    data.timeTrackerReport != null
                        ? "${Strings.total} ${data.timeTrackerReport.getTotalString()}"
                        : "",
                    textAlign: TextAlign.end)
              ],
            ),
          )
        ],
      ),
    );
  }

  static Widget create(Report report) {
    return Consumer<BaseAuth>(
      builder: (context, auth, _) => Provider<ReportPageBloc>(
        create: (context) => ReportPageBloc(
          locator<Analytics>(),
          report,
          locator<Preferences>(),
        ),
        child: Consumer<ReportPageBloc>(
          builder: (context, bloc, _) => ReportPage(bloc: bloc),
        ),
        dispose: (context, bloc) => bloc.dispose(),
      ),
    );
  }

  bool _isReportEmpty(ReportPageStateModel data) {
    return data.timeTrackerReport == null ||
        data.timeTrackerReport.report.isEmpty;
  }
}
