import 'package:flutter/material.dart';
import 'dart:async';
import 'package:tikal_time_tracker/data/user.dart';
import 'package:tikal_time_tracker/data/models.dart';
import 'package:tikal_time_tracker/data/project.dart';
import 'package:tikal_time_tracker/data/task.dart';
import 'package:tikal_time_tracker/data/repository/time_records_repository.dart';
import 'package:tikal_time_tracker/pages/report/report_page.dart';
import 'package:tikal_time_tracker/ui/date_picker_widget.dart';
import 'package:tikal_time_tracker/ui/page_title.dart';
import 'package:tikal_time_tracker/pages/reports/reports_contract.dart';
import 'package:tikal_time_tracker/pages/reports/reports_presenter.dart';

class GenerateReportPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
//    print("Users: ${User.me.name}, Projects: ${User.me.projects[0].name}");
    return new GenerateReportState();
  }
}

class GenerateReportState extends State<GenerateReportPage> implements ReportsViewContract{
  Project _selectedProject;
  List<Task> _tasks = User.me.tasks;
  List<Period> _predefiendPeriod = [
    Period(name: "This Month", value: 3),
    Period(name: "Previuos Month", value: 7),
    Period(name: "This Week", value: 2),
    Period(name: "Today", value: 1),
    Period(name: "Yesterday", value: 8),
  ];
  Task _selectedTask;
  Period _selectedPeriod;
  TextEditingController startDateInputController;
  TextEditingController endDateInputController;
  DateTime _startDate;
  DateTime _endDate;

  bool isButtonEnabled = false;

  TimeRecordsRepository repository = TimeRecordsRepository();
  ReportsPresenter presenter;


  @override
  void initState() {
    super.initState();
    presenter = new ReportsPresenter(repository: repository);
    presenter.subscribe(this);
  }

  @override
  Widget build(BuildContext context) {

    final projectsDropDown = Container(
        margin: EdgeInsets.symmetric(vertical: 4.0),
        decoration: BoxDecoration(
            border: Border.all(width: 0.5, color: Colors.black45)),
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: DropdownButtonHideUnderline(
          child: new DropdownButton(
              iconSize: 30.0,
              hint: Container(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Select a Project",
                  style: TextStyle(fontSize: 24.0, color: Colors.black26),
                ),
              ),
              value: _selectedProject,
              items: User.me.projects.map((Project value) {
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
        )
    );

    final tasksDropDown = Container(
        margin: EdgeInsets.symmetric(vertical: 4.0),
        decoration: BoxDecoration(
            border: Border.all(width: 0.5, color: Colors.black45)),
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: DropdownButtonHideUnderline(
          child: new DropdownButton(
              iconSize: 30.0,
              hint: Container(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Select a Task",
                  style: TextStyle(fontSize: 24.0, color: Colors.black26),
                ),
              ),
              value: _selectedTask,
              items: _tasks.map((Task value) {
                return new DropdownMenuItem<Task>(
                  value: value,
                  child: new Text(
                    value.name,
                    style: TextStyle(fontSize: 24.0),
                  ),
                );
              }).toList(),
              onChanged: (Task value) {
                _onTaskSelected(value);
              }),
        ));

    final predefiendPeriod = Container(
        margin: EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
            border: Border.all(width: 0.5, color: Colors.black45)),
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: DropdownButtonHideUnderline(
          child: new DropdownButton(
              iconSize: 30.0,
              hint: Container(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Select Time Period",
                  style: TextStyle(fontSize: 24.0, color: Colors.black26),
                ),
              ),
              value: _selectedPeriod,
              items: _predefiendPeriod.map((Period value) {
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

    final _startDatePicker = TimeTrackerDatePicker(initializedDateTime: _startDate, hint: "Start Date", onSubmittedCallback: (date){
      setState(() {
        _startDate = date;
      });
    });

    final _endDatePicker = TimeTrackerDatePicker(initializedDateTime: _endDate, hint: "End Date", onSubmittedCallback: (date){
      setState(() {
        _endDate = date;
      });
    });

    final startDateInput = Container(
      padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 4.0),
      child: new Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                print("onTap dateInput");
                _showStartDatePicker();
              },
              child: Icon(Icons.date_range),
            ),
          ),
          Container(
            child: new Flexible(
                  child: new TextField(
                      decoration: InputDecoration(
                          hintText: "Start Date",
                          contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0))),
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
                    decoration: InputDecoration(
                        hintText: "End Date",
                        contentPadding:
                            EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0))),
                    maxLines: 1,
                    controller: endDateInputController)),
          ),
        ],
      ),
    );

    var generateButton = Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      child: Material(
          borderRadius: BorderRadius.circular(10.0),
          shadowColor: isButtonEnabled
              ? Colors.orangeAccent.shade100
              : Colors.grey.shade100,
          elevation: 2.0,
          child: MaterialButton(
            minWidth: 200.0,
            height: 42.0,
            onPressed: () {
              if (isButtonEnabled) {
                _handleGenerateButtonClicked();
              }
            },
            color: isButtonEnabled ? Colors.orangeAccent : Colors.grey,
            child: Text("Generate", style: TextStyle(color: Colors.white)),
          )),
    );

    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text("Reports"),
          elevation: 1.0,
        ),
        backgroundColor: Colors.white,
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: <Widget>[
              TimeTrackerPageTitle(),
              Flexible(
                flex: 2,
                child: ListView(
                  padding:
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
                  shrinkWrap: false,
                  children: <Widget>[
                    projectsDropDown,
                    tasksDropDown,
                    startDateInput,
                    endDateInput,
                    predefiendPeriod,
                  ],
                ),
              ),
              Flexible(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[generateButton],
                  ))
            ],
          ),
        ));
  }

  void _onProjectSelected(Project value) {
    setState(() {
      _selectedProject = value;
      _tasks.clear();
      _tasks.addAll(value.tasks);
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
        case "This Month":
          _onSelectThisMonth();
          break;
        case "Previuos Month":
          _onSelectPreviousMonth();
          break;
        case "This Week":
          _onSelectThisWeek();
          break;
        case "Previuos Week":
          _onSelectedPrevWeek();
          break;
        case "Today":
          _onTodaySelected();
          break;
        case "Yesterday":
          _onYesterdaySelected();
          break;
      }
      _setButtonState();
    });
  }

  Future<Null> _showStartDatePicker() async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year - 1, 1),
        lastDate: DateTime(DateTime.now().year, 12));

    if (picked != null) {
      _onSelectedStartDate(
          DateTime(picked.year, picked.month, picked.day, 0, 0, 0, 0));
      _setButtonState();
    }
  }

  Future<Null> _showEndDatePicker() async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year - 1, 1),
        lastDate: DateTime(DateTime.now().year, 12));

    if (picked != null) {
      _onSelectedEndDate(
          DateTime(picked.year, picked.month, picked.day, 0, 0, 0, 0));
      _setButtonState();
    }
  }

  _onSelectedStartDate(DateTime dateTime) {
    setState(() {
      _startDate = dateTime;
      print("picked: ${_startDate.millisecondsSinceEpoch}");
      startDateInputController = new TextEditingController(
          text: "${_startDate.day}/${_startDate.month}/${_startDate.year}");
    });
  }

  _onSelectedEndDate(DateTime dateTime) {
    setState(() {
      _endDate =
          DateTime(dateTime.year, dateTime.month, dateTime.day, 0, 0, 0, 0);
      print("picked: ${_endDate.millisecondsSinceEpoch}");
      endDateInputController = new TextEditingController(
          text: "${_endDate.day}/${_endDate.month}/${_endDate.year}");
    });
  }

  void _setButtonState() {
    setState(() {
      if (_startDate != null && _endDate != null) {
        print("setButtonState: Button enabled");
        isButtonEnabled = true;
      } else {
        print("setButtonState: Button diabled");
        isButtonEnabled = false;
      }
    });
  }

  void _onSelectThisMonth() {
    _onSelectedStartDate(
        DateTime(DateTime.now().year, DateTime.now().month, 1));
    _onSelectedEndDate(DateTime(DateTime.now().year, DateTime.now().month,
        _daysInMonth(DateTime.now().year, DateTime.now().month)));
  }

  void _onSelectPreviousMonth() {
    _onSelectedStartDate(
        DateTime(DateTime.now().year, DateTime.now().month - 1, 1));
    _onSelectedEndDate(DateTime(DateTime.now().year, DateTime.now().month - 1,
        _daysInMonth(DateTime.now().year, DateTime.now().month - 1)));
  }

  void _onSelectThisWeek() {
    var startDay = DateTime.now().weekday;
    _onSelectedStartDate(DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day - DateTime.now().weekday));
    _onSelectedEndDate(DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day + (7 - DateTime.now().weekday) - 1));
  }

  void _onSelectedPrevWeek() {
    _onSelectedStartDate(DateTime(DateTime.now().year, DateTime.now().month,
        (DateTime.now().day - DateTime.now().weekday) - 7));
    _onSelectedEndDate(DateTime(DateTime.now().year, DateTime.now().month,
        (DateTime.now().day + (7 - DateTime.now().weekday) - 1) - 7));
  }

  void _onTodaySelected() {
    _onSelectedStartDate(DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day));
    _onSelectedEndDate(DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day));
  }

  void _onYesterdaySelected() {
    _onSelectedStartDate(DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day - 1));
    _onSelectedEndDate(DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day - 1));
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
    print("_handleGenerateButtonClicked");
    presenter.onClickGenerateButton(_selectedProject, _selectedTask, _startDate, _endDate, _selectedPeriod);
  }

  @override
  void showReport(List<TimeRecord> items) {
    Navigator.of(context).push(new MaterialPageRoute(
        builder: (BuildContext context) => new ReportPage(
            report: Report(
                report: items,
                startDate: _startDate,
                endDate: _endDate,
                project: null,
                task: null))));
    }
}

class Period{
 final String name;
 final int value;

  Period({this.name, this.value});

  @override
  String toString() {
    return 'Period{name: $name, value: $value}';
  }
}