import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tikal_time_tracker/data/models.dart';
import 'package:tikal_time_tracker/services/auth/auth.dart';
import 'package:tikal_time_tracker/services/auth/user.dart';
import 'package:tikal_time_tracker/data/repository/time_records_repository.dart';
import 'package:tikal_time_tracker/pages/login/login_page.dart';
import 'package:tikal_time_tracker/ui/platform_appbar.dart';
import 'package:tikal_time_tracker/ui/time_record_list_adapter.dart';
import 'package:tikal_time_tracker/pages/new_record_page/new_record_page.dart';
import 'package:tikal_time_tracker/pages/reports/place_holder_content.dart';
import 'package:tikal_time_tracker/ui/date_picker_widget.dart';
import 'package:tikal_time_tracker/utils/action_choice.dart';
import 'package:tikal_time_tracker/pages/time/time_presenter.dart';
import 'package:tikal_time_tracker/pages/time/time_contract.dart';
import 'package:tikal_time_tracker/pages/about_screen/about_screen.dart';
import 'package:tikal_time_tracker/utils/page_transition.dart';
import 'package:tikal_time_tracker/resources/strings.dart';
import 'package:tikal_time_tracker/analytics/analytics.dart';
import 'package:tikal_time_tracker/analytics/events/time_event.dart';
import 'package:tikal_time_tracker/utils/utils.dart';

class TimePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new TimePageState();
  }
}

class TimePageState extends State<TimePage>
    with TickerProviderStateMixin
    implements ListAdapterClickListener, TimeContractView {
  Analytics analytics = Analytics.instance;
  List<Choice> choices = const <Choice>[
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

  DateTime _selectedDate;
  TextEditingController dateInputController =
      new TextEditingController(text: "");

  TimeRecordsRepository repository = TimeRecordsRepository();
  TimeReport _timeReport;
  TimePresenter presenter;

  @override
  void initState() {
    super.initState();
    // print("TimePage: initState");
    presenter = TimePresenter(repository: this.repository);
    presenter.subscribe(this);
    var now = DateTime.now();
    _selectedDate = DateTime(now.year, now.month, now.day, 0, 0, 0, 0, 0);
    dateInputController = new TextEditingController(
        text:
            "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}");
    presenter.loadTimeForDate(_selectedDate);
    analytics.logEvent(TimeEvent.impression(EVENT_NAME.TIME_PAGE_OPENED).setUser(User.me.name).
    view());
  }

  @override
  Widget build(BuildContext context) {
    print("build: TimePage");
    PlaceholderContent placeholderContent = PlaceholderContent(
        title: Strings.no_work_title,
        subtitle: Strings.no_work_subtitle,
        onPressed: () {
          analytics.
          logEvent(TimeEvent.click(EVENT_NAME.NEW_RECORD_SCREEN_CLICKED).
          setUser(User.me.name));

          presenter.listItemClicked(null);
        });

    Widget _datePicker = TimeTrackerDatePicker(
        initializedDateTime: _selectedDate,
        onSubmittedCallback: (date) {
          analytics.logEvent(TimeEvent.click(EVENT_NAME.DATE_PICKER_USED));
          _selectedDate = date;
          presenter.loadTimeForDate(_selectedDate);
        });

    Widget buildQuotaWidget(TimeReport report) {
      String title =
          report.overQuota ? Strings.over_quota : Strings.remaining_quota;
      Color textColor = report.overQuota ? Colors.green : Colors.red;
      return Text("$title ${Utils.buildTimeStringFromDuration(report.quota)}",
          style: TextStyle(color: textColor));
    }

    Widget summaryRow() {
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
                "${Strings.week_total} ${Utils.buildTimeStringFromDuration(this._timeReport.weekTotal)}",
                textAlign: TextAlign.start,
              ),
              Text(
                  "${Strings.day_total} ${Utils.buildTimeStringFromDuration(this._timeReport.dayTotal)}",
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      color: this._timeReport.dayTotal.inHours < 9
                          ? Colors.red
                          : Colors.black))
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "${Strings.month_total} ${Utils.buildTimeStringFromDuration(this._timeReport.monthTotal)}",
                textAlign: TextAlign.start,
              ),
              buildQuotaWidget(_timeReport),
            ],
          ),
        ],
      );
    }


    Widget _infoRow() {
      return Container(
        padding: EdgeInsets.only(top: 16),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            _timeReport.message != null ? Text(_timeReport.message , style: TextStyle(color: Colors.red),) : Container()
          ],
        ),
      );
    }
    
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.black12,
      appBar: _buildAppBar(title: Strings.app_name),
      floatingActionButton: new FloatingActionButton(
          onPressed: () {
            analytics.logEvent(TimeEvent.click(EVENT_NAME.NEW_RECORD_FAB_CLICKED).setUser(User.me.name));
            presenter.listItemClicked(null);
          },
          child: Icon(Icons.add)),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _datePicker,
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
            Expanded(
              child: (_timeReport == null ||
                      _timeReport.timeReport == null ||
                      _timeReport.timeReport.isEmpty)
                  ? placeholderContent
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        TimeRecordListAdapter(
                            items: _timeReport.timeReport,
                            intermittently: true,
                            dismissibleItems: true,
                            adapterClickListener: this),
                        summaryRow(),
                        _infoRow()
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _select(Choice choice) {
    setState(() {
      if (choice.action == MenuAction.Logout) {
        presenter.onLogoutClicked();
        analytics.logEvent(TimeEvent.click(EVENT_NAME.ACTION_LOGOUT).setUser(User.me.name));
      }
      if (choice.action == MenuAction.About) {
        presenter.onAboutClicked();
        analytics.logEvent(TimeEvent.click(EVENT_NAME.ACTION_ABOUT).setUser(User.me.name));
      }
    });
  }

  _logout() async {

    BaseAuth auth = Provider.of<BaseAuth>(context);
    await auth.logout();
//    Navigator.of(context).pushReplacement(new MaterialPageRoute(
//        builder: (BuildContext context) => new LoginPage()));
  }

  PreferredSizeWidget _buildAppBar({String title}) {
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
                  analytics.logEvent(TimeEvent.click(EVENT_NAME.ACTION_ABOUT).setUser(User.me.name)
                      .setDetails("Action Icon"));
                  showAboutScreen();
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
        _select(c);
      },
    ).build(context);
  }

  _navigateToNextScreen() {
    final projects = User.me.projects;
    print("_navigateToNextScreen: " + projects.toString());
    Navigator.of(context)
        .push(new PageTransition(
            widget: new NewRecordPage(
                projects: projects,
                dateTime: _selectedDate,
                timeRecord: null,
                flow: NewRecordFlow.new_record)))
        .then((value) {
//      print("got value from page");
      if (value != null) {
        if (value is TimeRecord) {
          _onDateSelected(value.date);
        }
      } else {
        presenter.loadTimeForDate(_selectedDate);
      }
    });
  }

  _navigateToEditScreen(TimeRecord item) {
//    print("_navigateToEditScreen: ");
    Navigator.of(context)
        .push(new PageTransition(
            widget: new NewRecordPage(
                projects: User.me.projects,
                dateTime: _selectedDate,
                timeRecord: item,
                flow: NewRecordFlow.update_record)))
        .then((value) {
//      print("got value from page");
      if (value != null) {
        if (value is TimeRecord) {
          _onDateSelected(value.date);
        }
      } else {
        presenter.loadTimeForDate(_selectedDate);
      }
    });
  }

  _onDateSelected(DateTime selectedDate) {
    _selectedDate = DateTime(
        selectedDate.year, selectedDate.month, selectedDate.day, 0, 0, 0, 0, 0);
    dateInputController = new TextEditingController(
        text: "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}");
    presenter.loadTimeForDate(selectedDate);
  }

  @override
  onListItemClicked(TimeRecord item) {
    presenter.listItemClicked(item);
  }

  @override
  onListItemLongClick(TimeRecord item) {}

  @override
  void openNewRecordPage(TimeRecord item) {
    if (item != null) {
      _navigateToEditScreen(item);
    } else {
      _navigateToNextScreen();
    }
  }

  @override
  void timeLoadFinished(TimeReport timeReport) {
//    analytics.logEvent(TimeEvent.impression(EVENT_NAME.TIME_PAGE_LOADED).setDetails( "${timeRecord != null ? timeRecord.length : 0} :records").view());
    setState(() {
      this._timeReport = timeReport;
    });
  }

  @override
  void logOut() {
    _logout();
  }

  @override
  void showAboutScreen() {
    _navigateToAboutScreen();
  }

  void _navigateToAboutScreen() {
    Navigator.of(context).push(new PageTransition(widget: new AboutScreen()));
  }

  @override
  void onListItemDismissed(TimeRecord item) {
    presenter.onItemDismissed(item);
  }

  @override
  void refresh() {
    presenter.loadTimeForDate(_selectedDate);
  }
}


