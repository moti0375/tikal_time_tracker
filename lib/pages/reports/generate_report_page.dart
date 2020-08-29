import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tikal_time_tracker/analytics/analytics.dart';
import 'package:tikal_time_tracker/analytics/events/reports_event.dart';
import 'package:tikal_time_tracker/data/models.dart';
import 'package:tikal_time_tracker/data/name_value_entity.dart';
import 'package:tikal_time_tracker/data/project.dart';
import 'package:tikal_time_tracker/data/repository/time_records_repository.dart';
import 'package:tikal_time_tracker/data/task.dart';
import 'package:tikal_time_tracker/pages/login/login_page.dart';
import 'package:tikal_time_tracker/pages/report/report_page.dart';
import 'package:tikal_time_tracker/pages/reports/reports_contract.dart';
import 'package:tikal_time_tracker/pages/reports/reports_presenter.dart';
import 'package:tikal_time_tracker/resources/strings.dart';
import 'package:tikal_time_tracker/services/auth/auth.dart';
import 'package:tikal_time_tracker/services/locator/locator.dart';
import 'package:tikal_time_tracker/ui/animation_button.dart';
import 'package:tikal_time_tracker/ui/page_title.dart';
import 'package:tikal_time_tracker/ui/platform_appbar.dart';
import 'package:tikal_time_tracker/utils/page_transition.dart';

class GenerateReportPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new GenerateReportState();
  }
}

class GenerateReportState extends State<GenerateReportPage> with AutomaticKeepAliveClientMixin<GenerateReportPage> implements ReportsViewContract {
  Analytics analytics = Analytics.instance;
  Project _selectedProject;
  List<Period> _predefinedPeriod = [
    Period(name: Strings.item_this_month, value: 3),
    Period(name: Strings.item_previous_month, value: 7),
    Period(name: Strings.item_this_week, value: 2),
    Period(name: Strings.item_today, value: 1),
    Period(name: Strings.item_yesterday, value: 8),
  ];
  Task _selectedTask;
  Period _selectedPeriod;
  TextEditingController startDateInputController;
  TextEditingController endDateInputController;
  DateTime _startDate;
  DateTime _endDate;

  bool isButtonEnabled = false;

  TimeRecordsRepository repository;
  ReportsPresenter presenter;

  @override
  void initState() {
    super.initState();
    analytics.logEvent(ReportsEvent.impression(EVENT_NAME.REPORTS_SCREEN).open());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (repository == null) {
      repository = locator<TimeRecordsRepository>();
    }
    if (presenter == null) {
      presenter = new ReportsPresenter(repository: repository, auth: Provider.of<BaseAuth>(context));
      presenter.subscribe(this);
    }
  }

  @override
  Widget build(BuildContext context) {
    final projectsDropDown = Container(
        margin: EdgeInsets.symmetric(vertical: 4.0),
        decoration: BoxDecoration(border: Border.all(width: 0.5, color: Colors.black45)),
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: DropdownButtonHideUnderline(
          child: new DropdownButton(
              iconSize: 30.0,
              hint: Container(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  Strings.drop_down_project_title,
                  style: TextStyle(fontSize: 24.0, color: Colors.black26),
                ),
              ),
              value: _selectedProject,
              items: Provider.of<BaseAuth>(context).getCurrentUser().projects.map((Project value) {
                return new DropdownMenuItem<Project>(
                  value: value,
                  child: new Text(
                    value.name,
                    style: TextStyle(fontSize: 24.0),
                  ),
                );
              }).toList(),
              onChanged: (Project value) {
                _onProjectSelected(value);
              }),
        ));

    final tasksDropDown = Container(
        margin: EdgeInsets.symmetric(vertical: 4.0),
        decoration: BoxDecoration(border: Border.all(width: 0.5, color: Colors.black45)),
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: DropdownButtonHideUnderline(
          child: new DropdownButton(
              iconSize: 30.0,
              hint: Container(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  Strings.drop_down_task_title,
                  style: TextStyle(fontSize: 24.0, color: Colors.black26),
                ),
              ),
              value: _selectedTask,
              items: _selectedProject != null
                  ? _createDropDownMenuItems<Task>(_selectedProject.tasks)
                  : _createDropDownMenuItems<Task>(Provider.of<BaseAuth>(context).getCurrentUser().tasks),
              onChanged: (Task value) {
                _onTaskSelected(value);
              }),
        ));

    final predefiendPeriod = Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(border: Border.all(width: 0.5, color: Colors.black45)),
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: DropdownButtonHideUnderline(
        child: new DropdownButton(
            iconSize: 30.0,
            hint: Container(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                Strings.drop_down_period_title,
                style: TextStyle(fontSize: 24.0, color: Colors.black26),
              ),
            ),
            value: _selectedPeriod,
            items: _predefinedPeriod.map((Period value) {
              return new DropdownMenuItem<Period>(
                value: value,
                child: new Text(
                  value.name,
                  style: TextStyle(fontSize: 24.0),
                ),
              );
            }).toList(),
            onChanged: (Period value) {
              _onPeriodSelected(value);
            }),
      ),
    );

    final startDateInput = Container(
      padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 4.0),
      child: new Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
//                print("onTap dateInput");
                _showStartDatePicker();
              },
              child: Icon(Icons.date_range),
            ),
          ),
          Container(
            child: new Flexible(
              child: new TextField(
                  decoration:
                      InputDecoration(hintText: Strings.start_date, contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0), border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0))),
                  maxLines: 1,
                  controller: startDateInputController),
            ),
          ),
        ],
      ),
    );

    final endDateInput = Container(
      padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 8.0),
      child: new Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                print("onTap dateInput");
                _showEndDatePicker();
              },
              child: Icon(Icons.date_range),
            ),
          ),
          Container(
            child: new Flexible(
                child: new TextField(
                    decoration:
                        InputDecoration(hintText: Strings.end_date, contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0), border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0))),
                    maxLines: 1,
                    controller: endDateInputController)),
          ),
        ],
      ),
    );

    var generateButton = Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      child: AnimationButton(
        onPressed: isButtonEnabled
            ? () {
                if (isButtonEnabled) {
                  _handleGenerateButtonClicked();
                }
              }
            : null,
        buttonText: Strings.generate_button_text,
      ),
    );

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: PlatformAppbar(
        heroTag: "GenerateReportPage",
        title: Text(Strings.reports_page_title),
      ).build(context),
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TimeTrackerPageTitle(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  projectsDropDown,
                  tasksDropDown,
                  startDateInput,
                  endDateInput,
                  predefiendPeriod,
                ],
              ),
            ),
            generateButton,
          ],
        ),
      ),
    );
  }

  void _onProjectSelected(Project value) {
    setState(() {
      _selectedProject = value;
      _selectedTask = null;
    });
  }

  void _onTaskSelected(Task value) {
    setState(() {
      _selectedTask = value;
    });
  }

  void _onPeriodSelected(Period value) {
    setState(() {
      _selectedPeriod = value;
      switch (value.name) {
        case Strings.item_this_month:
          _onSelectThisMonth();
          break;
        case Strings.item_previous_month:
          _onSelectPreviousMonth();
          break;
        case Strings.item_this_week:
          _onSelectThisWeek();
          break;
        case Strings.item_previous_week:
          _onSelectedPrevWeek();
          break;
        case Strings.item_today:
          _onTodaySelected();
          break;
        case Strings.item_yesterday:
          _onYesterdaySelected();
          break;
      }
      _setButtonState();
    });
  }

  Future<Null> _showStartDatePicker() async {
    final DateTime picked = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(DateTime.now().year - 1, 1), lastDate: DateTime(DateTime.now().year, 12));

    if (picked != null) {
      _onSelectedStartDate(DateTime(picked.year, picked.month, picked.day, 0, 0, 0, 0));
      _setButtonState();
    }
  }

  Future<Null> _showEndDatePicker() async {
    final DateTime picked = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(DateTime.now().year - 1, 1), lastDate: DateTime(DateTime.now().year, 12));

    if (picked != null) {
      _onSelectedEndDate(DateTime(picked.year, picked.month, picked.day, 0, 0, 0, 0));
      _setButtonState();
    }
  }

  _onSelectedStartDate(DateTime dateTime) {
    setState(() {
      _startDate = dateTime;
      print("picked: ${_startDate.millisecondsSinceEpoch}");
      startDateInputController = new TextEditingController(text: "${_startDate.day}/${_startDate.month}/${_startDate.year}");
    });
  }

  _onSelectedEndDate(DateTime dateTime) {
    setState(() {
      _endDate = DateTime(dateTime.year, dateTime.month, dateTime.day, 0, 0, 0, 0);
      print("picked: ${_endDate.millisecondsSinceEpoch}");
      endDateInputController = new TextEditingController(text: "${_endDate.day}/${_endDate.month}/${_endDate.year}");
    });
  }

  void _setButtonState() {
    setState(() {
      if (_startDate != null && _endDate != null) {
        isButtonEnabled = true;
      } else {
        isButtonEnabled = false;
      }
    });
  }

  void _onSelectThisMonth() {
    _onSelectedStartDate(DateTime(DateTime.now().year, DateTime.now().month, 1));
    _onSelectedEndDate(DateTime(DateTime.now().year, DateTime.now().month, _daysInMonth(DateTime.now().year, DateTime.now().month)));
  }

  void _onSelectPreviousMonth() {
    _onSelectedStartDate(DateTime(DateTime.now().year, DateTime.now().month - 1, 1));
    _onSelectedEndDate(DateTime(DateTime.now().year, DateTime.now().month - 1, _daysInMonth(DateTime.now().year, DateTime.now().month - 1)));
  }

  void _onSelectThisWeek() {
    _onSelectedStartDate(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - DateTime.now().weekday));
    _onSelectedEndDate(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + (7 - DateTime.now().weekday) - 1));
  }

  void _onSelectedPrevWeek() {
    _onSelectedStartDate(DateTime(DateTime.now().year, DateTime.now().month, (DateTime.now().day - DateTime.now().weekday) - 7));
    _onSelectedEndDate(DateTime(DateTime.now().year, DateTime.now().month, (DateTime.now().day + (7 - DateTime.now().weekday) - 1) - 7));
  }

  void _onTodaySelected() {
    _onSelectedStartDate(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day));
    _onSelectedEndDate(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day));
  }

  void _onYesterdaySelected() {
    _onSelectedStartDate(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - 1));
    _onSelectedEndDate(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - 1));
  }

  int _daysInMonth(int year, int month) {
    if (month == 4 || month == 6 || month == 9 || month == 11) return 30;
    if (month == 2) {
      if (year % 4 == 0 && year % 100 != 0 || year % 400 == 0) {
        return 29;
      } else {
        return 28;
      }
    }
    return 31;
  }

  void _handleGenerateButtonClicked() {
    analytics.logEvent(ReportsEvent.click(EVENT_NAME.GENERATE_REPORT_CLICKED));
    presenter.onClickGenerateButton(_selectedProject, _selectedTask, _startDate, _endDate, _selectedPeriod);
  }

  @override
  void showReport(List<TimeRecord> items) {
    analytics.logEvent(ReportsEvent.impression(EVENT_NAME.REPORT_GENERATED_SUCCESS).view());

    Navigator.of(context).push(new PageTransition(widget: ReportPage.create(Report(report: items, startDate: _startDate, endDate: _endDate, project: null, task: null))));

//    Navigator.of(context).push(new MaterialPageRoute(
//        builder: (BuildContext context) =>  ReportPage.create(Report(
//                report: items,
//                startDate: _startDate,
//                endDate: _endDate,
//                project: null,
//                task: null))));
  }

  @override
  void logOut() {
    _logout();
  }

  _logout() {
    analytics.logEvent(ReportsEvent.impression(EVENT_NAME.FAILED_TO_GENERATE_REPORT).view().setDetails("Logout"));
    Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => new LoginPage()));
  }

  @override
  bool get wantKeepAlive => true;

  List<DropdownMenuItem<T>> _createDropDownMenuItems<T extends NameValueEntity>(List<T> items) {
    return items.map((T value) {
      return new DropdownMenuItem<T>(
        value: value,
        child: new Text(
          value.name,
          style: TextStyle(fontSize: 24.0),
        ),
      );
    }).toList();
  }
}

class Period {
  final String name;
  final int value;

  Period({this.name, this.value});

  @override
  String toString() {
    return 'Period{name: $name, value: $value}';
  }
}
