import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:tikal_time_tracker/bloc_base/base_state.dart';
import 'package:tikal_time_tracker/bloc_base/bloc_base_event.dart';
import 'package:tikal_time_tracker/data/models.dart';
import 'package:tikal_time_tracker/services/auth/auth.dart';
import 'package:tikal_time_tracker/services/auth/user.dart';
import 'package:tikal_time_tracker/ui/platform_appbar.dart';
import 'package:tikal_time_tracker/ui/time_record_list_builder.dart';
import 'package:tikal_time_tracker/pages/new_record_page/new_record_page.dart';
import 'package:tikal_time_tracker/pages/reports/place_holder_content.dart';
import 'package:tikal_time_tracker/ui/date_picker_widget.dart';
import 'package:tikal_time_tracker/utils/action_choice.dart';
import 'package:tikal_time_tracker/pages/time/time_page_bloc.dart';
import 'package:tikal_time_tracker/pages/about_screen/about_screen.dart';
import 'package:tikal_time_tracker/utils/page_transition.dart';
import 'package:tikal_time_tracker/resources/strings.dart';
import 'package:tikal_time_tracker/analytics/analytics.dart';
import 'package:tikal_time_tracker/analytics/events/time_event.dart';
import 'package:tikal_time_tracker/utils/utils.dart';
import 'package:bloc/bloc.dart';


class TimePage extends StatefulWidget {

  @override
  _TimePageState createState() => _TimePageState();
}

class _TimePageState extends State<TimePage> {
  final Analytics analytics = Analytics.instance;
  final List<Choice> choices = const <Choice>[
    const Choice(
      action: MenuAction.Logout,
      title: "Logout",
      icon: null,
    ),
    const Choice(
      action: MenuAction.About,
      title: "About",
      icon: null,
    )
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  final TextEditingController dateInputController =
      new TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    TimePageBloc _bloc = BlocProvider.of<TimePageBloc>(context);

    analytics.logEvent(TimeEvent.impression(EVENT_NAME.TIME_PAGE_OPENED)
        .setUser(User.me.name)
        .view());

    print("build: TimePage");

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.black12,
      appBar: _buildAppBar(title: Strings.app_name, context: context),
      floatingActionButton: new FloatingActionButton(
          onPressed: () {
            analytics.logEvent(
                TimeEvent.click(EVENT_NAME.NEW_RECORD_FAB_CLICKED)
                    .setUser(User.me.name));
            _openNewRecordPage(null, context);
          },
          child: Icon(Icons.add)),
      body: BlocBuilder<BlocBaseEvent, BaseState>(
        bloc: _bloc,
          builder: (context, outputState) {
            if(outputState is LoadingCompleted){
              return _buildContent(context, outputState);
            } else return Placeholder();
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

  PlaceholderContent _buildPlaceHolder(BuildContext context) {
    return PlaceholderContent(
        title: Strings.no_work_title,
        subtitle: Strings.no_work_subtitle,
        onPressed: () {
          analytics.logEvent(
              TimeEvent.click(EVENT_NAME.NEW_RECORD_SCREEN_CLICKED)
                  .setUser(User.me.name));
          _openNewRecordPage(null, context);
        });
  }

  void onNewRecordScreenClicked() {}

  Widget _buildDatePicker(TimeReport model, BuildContext context) {
    return TimeTrackerDatePicker(
        initializedDateTime: BlocProvider.of<TimePageBloc>(context).selectedDate,
        onSubmittedCallback: (date) {
          analytics.logEvent(TimeEvent.click(EVENT_NAME.DATE_PICKER_USED));
          _onDateSelected(date);
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

  Widget _buildBody(AsyncSnapshot<TimeReport> snapshot, BuildContext context) {
    print("_buildBody: ${snapshot.connectionState}");
    if (snapshot.hasError) {
      print("_buildBody: ${snapshot.error}");
      _logout(context);
      return _buildPlaceHolder(context);
    } else if (snapshot.hasData) {
      print("_buildBody: done with data");
      return (snapshot.data.timeReport.isEmpty)
          ? _buildPlaceHolder(context)
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
                    _navigateToEditScreen(item, context);
                  },
                  onItemDismissed: (item) {
                    print("onItemDismissed: ");
                    BlocProvider.of<TimePageBloc>(context).onItemDismissed(item);
                  },
                ),
                summaryRow(snapshot),
                _infoRow(snapshot)
              ],
            );
    } else {
      print("_buildBody: other");
      return _buildPlaceHolder(context);
    }
  }

  Container _buildContent(BuildContext context, LoadingCompleted state, ) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildDatePicker((state), context),
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
                  )
                ],
              )),
          _buildBody(, context),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar({String title, BuildContext context}) {
    return PlatformAppbar(
      title: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.all(4.0),
              width: 24.0,
              height: 24.0,
              child: GestureDetector(
                onTap: () {
                  analytics.logEvent(TimeEvent.click(EVENT_NAME.ACTION_ABOUT)
                      .setUser(User.me.name)
                      .setDetails("Action Icon"));
                  _navigateToAboutScreen(context);
                },
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

  void _navigateToAboutScreen(BuildContext context) {
    Navigator.of(context).push(new PageTransition(widget: new AboutScreen()));
  }

  _logout(BuildContext context) async {
    BaseAuth auth = Provider.of<BaseAuth>(context);
    await auth.logout();
//    Navigator.of(context).pushReplacement(new MaterialPageRoute(
//        builder: (BuildContext context) => new LoginPage()));
  }

  void _select(Choice choice, BuildContext context) {
    if (choice.action == MenuAction.Logout) {
      _logout(context);
      analytics.logEvent(
          TimeEvent.click(EVENT_NAME.ACTION_LOGOUT).setUser(User.me.name));
    }
    if (choice.action == MenuAction.About) {
      _navigateToAboutScreen(context);
      analytics.logEvent(
          TimeEvent.click(EVENT_NAME.ACTION_ABOUT).setUser(User.me.name));
    }
  }

  _navigateToEditScreen(TimeRecord item, BuildContext context) {
//    print("_navigateToEditScreen: ");
    Navigator.of(context)
        .push(new PageTransition(
            widget: new NewRecordPage(
                projects: User.me.projects,
                dateTime: item.date,
                timeRecord: item,
                flow: NewRecordFlow.update_record)))
        .then((value) {
//      print("got value from page");
      if (value != null) {
        if (value is TimeRecord) {
          _onDateSelected(value.date);
        }
      } else {
        _onDateSelected(item.date);
      }
    });
  }

  _onDateSelected(DateTime selectedDate) {
    dateInputController.text =
        "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
    _bloc.dateSelected(DateSelectedEvent(selectedDate: selectedDate));
  }

  void _openNewRecordPage(TimeRecord item, BuildContext context) {
    if (item != null) {
      _navigateToEditScreen(item, context);
    } else {
      _navigateToNextScreen(context);
    }
  }

  _navigateToNextScreen(BuildContext context) {
    final projects = User.me.projects;
    print("_navigateToNextScreen: " + projects.toString());
    Navigator.of(context)
        .push(new PageTransition(
            widget: new NewRecordPage(
                projects: projects,
                dateTime: widget.bloc.selectedDate,
                timeRecord: null,
                flow: NewRecordFlow.new_record)))
        .then((value) {
//      print("got value from page");
      if (value != null) {
        if (value is TimeRecord) {
          _onDateSelected(value.date);
        }
      } else {
        _onDateSelected(BlocProvider.of<TimePageBloc>(context).selectedDate);
      }
    });
  }
}
