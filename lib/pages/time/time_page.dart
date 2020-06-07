import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tikal_time_tracker/data/models.dart';
import 'package:tikal_time_tracker/pages/time/time_page_event.dart';
import 'package:tikal_time_tracker/services/auth/auth.dart';
import 'package:tikal_time_tracker/services/auth/user.dart';
import 'package:tikal_time_tracker/ui/platform_appbar.dart';
import 'package:tikal_time_tracker/ui/time_record_list_builder.dart';
import 'package:tikal_time_tracker/pages/reports/place_holder_content.dart';
import 'package:tikal_time_tracker/ui/date_picker_widget.dart';
import 'package:tikal_time_tracker/utils/action_choice.dart';
import 'package:tikal_time_tracker/pages/time/time_page_bloc.dart';
import 'package:tikal_time_tracker/resources/strings.dart';
import 'package:tikal_time_tracker/utils/utils.dart';

class TimePage extends StatefulWidget {
  final TimePageBloc bloc;

  TimePage({@required this.bloc});

  @override
  _TimePageState createState() => _TimePageState();
}

class _TimePageState extends State<TimePage> with AutomaticKeepAliveClientMixin<TimePage>{

  final List<Choice> choices =  <Choice>[
     Choice(
      action: MenuAction.Logout,
      title: "Logout",
      icon: null,
    ),
     Choice(
      action: MenuAction.About,
      title: "About",
      icon: null,
    )
  ];

  @override
  void initState() {
    super.initState();
    widget.bloc.dispatchEvent(DateSelectedEvent(selectedDate: DateTime.now()));
  }

  final TextEditingController dateInputController =
      new TextEditingController(text: Strings.empty_string);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    User user = Provider.of<BaseAuth>(context).getCurrentUser();

//    print("build: TimePage: $user");

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.black12,
      appBar: _buildAppBar(title: Strings.app_name, context: context),
      floatingActionButton: new FloatingActionButton(
          onPressed: () => widget.bloc.dispatchEvent(FabAddRecordClicked(context)),
          child: Icon(Icons.add)),
      body: StreamBuilder<TimeReport>(
          initialData: TimeReport(date: DateTime.now(), timeReport: List<TimeRecord>()),
          stream: widget.bloc.timeReportStream,
          builder: (context, snapshot) {
            return _buildContent(snapshot, context, user);
          }),
    );
  }

  Widget summaryRow(AsyncSnapshot<TimeReport> snapshot) {
    return Column(
      children: <Widget>[
        SizedBox(height: 10.0),
        Container(
          height: 1.5,
          color: Colors.black26,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "${Strings.week_total} ${Utils.buildTimeStringFromDuration(snapshot.data.weekTotal)}",
              textAlign: TextAlign.start,
            ),
            Text(
                "${Strings.day_total} ${Utils.buildTimeStringFromDuration(snapshot.data.dayTotal)}",
                textAlign: TextAlign.end,
                style: TextStyle(
                    color: snapshot.data.dayTotal.inHours < 9
                        ? Colors.red
                        : Colors.black))
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "${Strings.month_total} ${Utils.buildTimeStringFromDuration(snapshot.data.monthTotal)}",
              textAlign: TextAlign.start,
            ),
            buildQuotaWidget(snapshot.data),
          ],
        ),
      ],
    );
  }

  Widget buildQuotaWidget(TimeReport report) {
    String title =
        report.overQuota ? Strings.over_quota : Strings.remaining_quota;
    Color textColor = report.overQuota ? Colors.green : Colors.red;
    return Text("$title ${Utils.buildTimeStringFromDuration(report.quota)}",
        style: TextStyle(color: textColor));
  }

  PlaceholderContent _buildPlaceHolder(BuildContext context, User user) {
    return PlaceholderContent(
        title: Strings.no_work_title,
        subtitle: Strings.no_work_subtitle,
        onPressed: () => widget.bloc.dispatchEvent(EmptyScreenAddRecordClicked(context)));
  }

  void onNewRecordScreenClicked() {}

  Widget _buildDatePicker(TimeReport model) {
    return TimeTrackerDatePicker(
        initializedDateTime: widget.bloc.selectedDate,
        onSubmittedCallback: (date) {
          dateInputController.text = "${date.day}/${date.month}/${date.year}";
          widget.bloc.dispatchEvent(DatePickerSelectedEvent(selectedDate:date));
        });
  }

  Widget _infoRow(AsyncSnapshot<TimeReport> snapshot) {
    return Container(
      padding: EdgeInsets.only(top: 16),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          snapshot.data.message != null
              ? Text(
                  snapshot.data.message,
                  style: TextStyle(color: Colors.red),
                )
              : Container()
        ],
      ),
    );
  }

  Widget _buildBody(AsyncSnapshot<TimeReport> snapshot, BuildContext buildContext, User user) {
//    print("_buildBody: ${snapshot.connectionState}");
    if (snapshot.hasError) {
//      print("_buildBody: ${snapshot.error}");
      _logout(buildContext);
      return _buildPlaceHolder(context, user);
    } else if (snapshot.hasData) {
//      print("_buildBody: done with data");
      return (snapshot.data.timeReport.isEmpty)
          ? _buildPlaceHolder(buildContext, user)
          : Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                TimeRecordListViewBuilder(
                  items: snapshot.data.timeReport,
                  intermittently: true,
                  dismissibleItems: true,
                  onItemClick: (item) {
                    print("onItemClickListener: ");
                    widget.bloc.dispatchEvent(OnTimeRecordItemClicked(buildContext, timeRecord: item));
                  },
                  onItemDismissed: (item) => widget.bloc.dispatchEvent(OnItemDismissed(context, timeRecord: item)),
                ),
                summaryRow(snapshot),
                _infoRow(snapshot)
              ],
            );
    } else {
      print("_buildBody: other");
      return _buildPlaceHolder(buildContext, user);
    }
  }

  Container _buildContent(AsyncSnapshot snapshot, BuildContext context, User user) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildDatePicker(snapshot.data),
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
                  Text(user != null ? "${user.name}, ${user.company}, ${user.role.toString().split(".").last}" : "",
                    textAlign: TextAlign.start,
                  )
                ],
              )),
          _buildBody(snapshot, context, user),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar({String title, BuildContext context}) {
    return PlatformAppbar(
      heroTag: "TimePage",
      title: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.all(4.0),
              width: 24.0,
              height: 24.0,
              child: GestureDetector(
                onTap: () => widget.bloc.dispatchEvent(OnAboutItemClicked(context: context)),
                child: Image.asset(
                  'assets/logo_no_background.png',
                ),
              ),
            ),
            Text(title)
          ]),
      actions: choices,
      onPressed: (Choice c) {
        print("Selected: ${c.title}");
        _select(c, context);
      },
    ).build(context);
  }

  void timeLoadFinished(TimeReport timeReport) {
//    analytics.logEvent(TimeEvent.impression(EVENT_NAME.TIME_PAGE_LOADED).setDetails( "${timeRecord != null ? timeRecord.length : 0} :records").view());
  }

  _logout(BuildContext context) async {
    BaseAuth auth = Provider.of<BaseAuth>(context);
    await auth.logout();
  }

  void _select(Choice choice, BuildContext context) {
    if (choice.action == MenuAction.Logout) {
      widget.bloc.dispatchEvent(LogoutItemClicked());
    }
    if (choice.action == MenuAction.About) {
      widget.bloc.dispatchEvent(OnAboutItemClicked(context: context));
    }
  }

  @override
  bool get wantKeepAlive => true;
}
