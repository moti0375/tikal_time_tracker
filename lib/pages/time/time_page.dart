import 'package:flutter/material.dart';
import 'package:tikal_time_tracker/data/models.dart';
import 'package:tikal_time_tracker/data/user.dart';
import 'package:tikal_time_tracker/data/repository/time_records_repository.dart';
import 'package:tikal_time_tracker/pages/login/login_page.dart';
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
  Analytics analytics = new Analytics();
  List<Choice> choices = const <Choice>[
    const Choice(
        action: Action.Logout, title: "Logout", icon: Icons.transit_enterexit),
    const Choice(action: Action.About, title: "About", icon: Icons.info_outline)
  ];

  DateTime _selectedDate;
  TextEditingController dateInputController =
  new TextEditingController(text: "");

  TimeRecordsRepository repository = TimeRecordsRepository();
  List<TimeRecord> _records;
  Duration _dayTotal;
  Duration _weekTotal;
  Duration _monthTotal;
  Duration _remainQouta;
  TimePresenter presenter;

  @override
  void initState() {
    super.initState();
    // print("TimePage: initState");
    presenter = TimePresenter(repository: this.repository);
    presenter.subscribe(this);
    var now = DateTime.now();
    _selectedDate = DateTime(
        now.year,
        now.month,
        now.day,
        0,
        0,
        0,
        0,
        0);
    dateInputController = new TextEditingController(
        text:
        "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}");
    presenter.loadTimeForDate(_selectedDate);
    _dayTotal = Duration(hours: 0, minutes: 0);
    _weekTotal = Duration(hours: 0, minutes: 0);
    _monthTotal = Duration(hours: 0, minutes: 0);
    _remainQouta = Duration(hours: 0, minutes: 0);
    analytics
        .logEvent(TimeEvent.impression(EVENT_NAME.TIME_PAGE_OPENED).view());
  }

  @override
  Widget build(BuildContext context) {
    PlaceholderContent placeholderContent = PlaceholderContent(
        title: Strings.no_work_title,
        subtitle: Strings.no_work_subtitle,
        onPressed: () {
          analytics
              .logEvent(TimeEvent.click(EVENT_NAME.NEW_RECORD_SCREEN_CLICKED));
          presenter.listItemClicked(null);
        });

    Widget _datePicker = TimeTrackerDatePicker(
        initializedDateTime: _selectedDate,
        onSubmittedCallback: (date) {
          analytics.logEvent(TimeEvent.click(EVENT_NAME.DATE_PICKER_USED));
          _selectedDate = date;
          presenter.loadTimeForDate(_selectedDate);
        });

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
                "Week Total: ${Utils.buildTimeStringFromDuration(this._weekTotal)}",
                textAlign: TextAlign.start,
              ),
              Text("${Strings.day_total} ${Utils.buildTimeStringFromDuration(this._dayTotal)}", textAlign: TextAlign.end, style: TextStyle(color: _dayTotal.inHours < 9 ? Colors.red : Colors.black))
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Month Total: ${Utils.buildTimeStringFromDuration(this._monthTotal)}",
                textAlign: TextAlign.start,
              ),
              Text("Remaining Quota: ${Utils.buildTimeStringFromDuration(this._remainQouta)}", textAlign: TextAlign.end, style: TextStyle(color: Colors.red),)
            ],
          )
        ],
      );
    }

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.black12,
      appBar: _buildAppBar(title: Strings.app_name),
      floatingActionButton: new FloatingActionButton(
          onPressed: () {
            analytics
                .logEvent(TimeEvent.click(EVENT_NAME.NEW_RECORD_FAB_CLICKED));
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
                      "${User.me.name}, ${User.me.company}, ${User.me.role
                          .toString()
                          .split(".")
                          .last}",
                      textAlign: TextAlign.start,
                    )
                  ],
                )),
            Expanded(
              child: (_records == null || _records.isEmpty)
                  ? placeholderContent
                  : Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  TimeRecordListAdapter(
                      items: _records,
                      intermittently: true,
                      adapterClickListener: this),
                  summaryRow()
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
      if (choice.action == Action.Logout) {
        presenter.onLogoutClicked();
        analytics.logEvent(TimeEvent.click(EVENT_NAME.ACTION_LOGOUT));
      }
      if (choice.action == Action.About) {
        presenter.onAboutClicked();
        analytics.logEvent(TimeEvent.click(EVENT_NAME.ACTION_ABOUT));
      }
    });
  }

  _logout() {
    Navigator.of(context).pushReplacement(new MaterialPageRoute(
        builder: (BuildContext context) => new LoginPage()));
  }

  AppBar _buildAppBar({String title}) {
    return AppBar(
      title: Row(children: [
        Container(
          margin: EdgeInsets.all(8.0),
          width: 24.0,
          height: 24.0,
          child: InkWell(
            onTap: () {
              analytics.logEvent(TimeEvent.click(EVENT_NAME.ACTION_ABOUT)
                  .setDetails("Action Icon"));
              showAboutScreen();
            },
            child: Hero(
              tag: 'hero',
              child: Image.asset(
                'assets/logo_no_background.png',
              ),
            ),
          ),
        ),
        Text(title)
      ]),
      actions: <Widget>[
        PopupMenuButton<Choice>(
          onSelected: _select,
          itemBuilder: (BuildContext context) {
            return choices.map((Choice c) {
              return PopupMenuItem<Choice>(
                value: c,
                child: Text(c.title),
              );
            }).toList();
          },
        )
      ],
    );
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
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        0,
        0,
        0,
        0,
        0);
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
      this._records = timeReport.timeReport;
      this._dayTotal = timeReport.dayTotal;
      this._weekTotal = timeReport.weekTotal;
      this._monthTotal = timeReport.monthTotal;
      this._remainQouta = timeReport.remainTotal;
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
}
