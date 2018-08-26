import 'package:flutter/material.dart';
import 'dart:async';
import '../../data/user.dart';
import '../../data/models.dart';
import '../../data/repository/time_records_repository.dart';
import 'report_page.dart';

class GenerateReportPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    print("Users: ${User().name}, Projects: ${User().projects[0].name}");
    return new GenerateReportState();
  }
}

class GenerateReportState extends State<GenerateReportPage> {
  Project _selectedProject;
  List<String> _tasks = new List<String>();
  List<String> _predefiendPeriod = [
    "This Month",
    "Previuos Month",
    "This Week",
    "Previuos Week",
    "Today",
    "Yesterday"
  ];
  String _selectedTask;
  String _selectedPeriod;
  TextEditingController startDateInputController;
  TextEditingController endDateInputController;
  DateTime _startDate;
  DateTime _endDate;

  bool isButtonEnabled = false;

  TimeRecordsRepository repository = TimeRecordsRepository();
  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final projectsDropDown = Container(
        padding: EdgeInsets.symmetric(horizontal: 25.0),
        child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              DropdownButton(
                  hint: Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    padding: const EdgeInsets.all(8.0),
                    child: new Text(
                      "Select a Project",
                      style: TextStyle(fontSize: 30.0),
                    ),
                  ),
                  value: _selectedProject,
                  isDense: true,
                  iconSize: 50.0,
                  items: User().projects.map((Project value) {
                    return new DropdownMenuItem<Project>(
                      value: value,
                      child: new Text(
                        value.name,
                        style: TextStyle(fontSize: 25.0),
                      ),
                    );
                  }).toList(),
                  onChanged: (Project value) {
                    _onProjectSelected(value);
                  })
            ]));

    final tasksDropDown = Container(
      padding: EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Expanded(
              child: new DropdownButton(
                  iconSize: 50.0,
                  hint: Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Select a Task",
                      style: TextStyle(fontSize: 30.0),
                    ),
                  ),
                  value: _selectedTask,
                  items: _tasks.map((String value) {
                    return new DropdownMenuItem<String>(
                      value: value,
                      child: new Text(
                        value
                            .toString()
                            .substring(value.toString().indexOf('.') + 1),
                        style: TextStyle(fontSize: 25.0),
                      ),
                    );
                  }).toList(),
                  onChanged: (String value) {
                    _onTaskSelected(value);
                  })),
        ],
      ),
    );

    final predefiendPeriod = Container(
      padding: EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Expanded(
              child: new DropdownButton(
                  iconSize: 50.0,
                  hint: Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Select Time Period",
                      style: TextStyle(fontSize: 30.0),
                    ),
                  ),
                  value: _selectedPeriod,
                  items: _predefiendPeriod.map((String value) {
                    return new DropdownMenuItem<String>(
                      value: value,
                      child: new Text(
                        value,
                        style: TextStyle(fontSize: 25.0),
                      ),
                    );
                  }).toList(),
                  onChanged: (String value) {
                    _onPeriodSelected(value);
                  })),
        ],
      ),
    );

    final startDateInput = Container(
      padding: EdgeInsets.only(left: 32.0, right: 32.0, top: 8.0),
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
                        contentPadding:
                            EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0))),
                    maxLines: 1,
                    controller: startDateInputController)),
          ),
        ],
      ),
    );

    final endDateInput = Container(
      padding: EdgeInsets.only(left: 32.0, right: 32.0, top: 8.0),
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

   final generateButton = Column(
       mainAxisSize: MainAxisSize.max,
       mainAxisAlignment: MainAxisAlignment.start,
       children: <Widget>[
         Material(borderRadius: BorderRadius.circular(10.0),
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
             color: isButtonEnabled ? Colors.orangeAccent : Colors
                 .grey,
             child: Text(
                 "Generate", style: TextStyle(color: Colors.white)),
           ),
         ),
       ],
     );


    return Scaffold(
      appBar: AppBar(
        title: Text("Reports"),
        elevation: 1.0,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 0.0),
            shrinkWrap: false,
            children: <Widget>[
              projectsDropDown,
              tasksDropDown,
              startDateInput,
              endDateInput,
              predefiendPeriod,
              generateButton
            ],
          ),
        ),
      ),
    );
  }

  void _onProjectSelected(Project value) {
    setState(() {
      _selectedProject = value;
      _tasks.clear();
      _tasks.addAll(value.tasks);
      _selectedTask = null;
    });
  }

  void _onTaskSelected(String value) {
    setState(() {
      _selectedTask = value;
    });
  }

  void _onPeriodSelected(String value) {
    setState(() {
      _selectedPeriod = value;
      switch (value) {
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
    _onSelectedStartDate(DateTime(DateTime.now().year, DateTime.now().month, 1));
    _onSelectedEndDate(DateTime(DateTime.now().year, DateTime.now().month, _daysInMonth(DateTime.now().year, DateTime.now().month)));
  }

  void _onSelectPreviousMonth() {
    _onSelectedStartDate(DateTime(DateTime.now().year, DateTime.now().month - 1, 1));
    _onSelectedEndDate(DateTime(DateTime.now().year, DateTime.now().month - 1, _daysInMonth(DateTime.now().year, DateTime.now().month - 1)));
  }

  void _onSelectThisWeek() {
    var startDay = DateTime.now().weekday;
    _onSelectedStartDate(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - DateTime.now().weekday));
    _onSelectedEndDate(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + (7 - DateTime.now().weekday) - 1) );
  }

  void _onSelectedPrevWeek() {
    _onSelectedStartDate(DateTime(DateTime.now().year, DateTime.now().month, (DateTime.now().day - DateTime.now().weekday) - 7));
    _onSelectedEndDate(DateTime(DateTime.now().year, DateTime.now().month, (DateTime.now().day + (7 - DateTime.now().weekday) - 1) - 7) );
  }

  void _onTodaySelected() {
    _onSelectedStartDate(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day));
    _onSelectedEndDate(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day));
  }

  void _onYesterdaySelected() {
    _onSelectedStartDate(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - 1 ));
    _onSelectedEndDate(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - 1));
  }

  int _daysInMonth(int year, int month){
    if(month == 4 || month == 6 || month == 9 || month == 11) return 30;
    if(month == 2) {
      if (year%4==0 && year%100!=0 || year%400==0) {
        return 29;
      }else{
        return 28;
      }
    }
    return 31;
  }

  void _handleGenerateButtonClicked() {

      print("_handleGenerateButtonClicked");
      repository.getRecordsBetweenDates(_startDate, _endDate).then((items) {
        if(items != null){
          print("Got ${items.length} from database");
        }
        Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new ReportPage(report: Report(report: items, startDate: _startDate, endDate: _endDate, project: null, task: null))));
      });
  }
}

Widget _buildBody() {
  return Container();
}
