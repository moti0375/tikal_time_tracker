import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/diagnostics.dart';
import 'package:tikal_time_tracker/ui/app_drawer.dart';
import 'package:tikal_time_tracker/ui/time_title.dart';
import 'new_record_page.dart';
import '../data/models.dart';
import '../data/user.dart';
import '../data/repository/time_records_repository.dart';
import 'dart:async';
import '../pages/login_page.dart';
import '../ui/time_record_list_adapter.dart';
import 'new_record_page.dart';
import '../data/project.dart';
import '../data/task.dart';
import '../pages/reports/place_holder_content.dart';

class TimePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new TimePageState();
  }
}

class TimePageState extends State<TimePage> implements DrawerOnClickListener, ListAdapterClickListener {
  final _items = <String>["Moti", "Nurit", "Yarden", "Yahel"];
  Choice _onSelected;
  DateTime _selectedDate;
  TextEditingController dateInputController = new TextEditingController(text: "");


  TimeRecordsRepository repository = TimeRecordsRepository();
  List<TimeRecord> _records;

  @override
  void initState() {
    super.initState();
    print("initState");
    var now = DateTime.now();
    _selectedDate = DateTime(now.year, now.month, now.day, 0, 0, 0, 0, 0);
//    _loadRecords(_selectedDate);
    dateInputController = new TextEditingController(text: "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}");
  }


  @override
  Widget build(BuildContext context) {

    PlaceholderContent placeholderContent = PlaceholderContent(title: "No Work Today", subtitle: "Tap to add report",onPressed: (){
      _navigateToNextScreen();
    });


    return Scaffold(
      backgroundColor: Colors.black12,
        appBar: _buildAppBar(title: "Tikal Time Tracker"),
        floatingActionButton:
            new FloatingActionButton(onPressed: () {
              _navigateToNextScreen();
            }, child: Icon(Icons.add)),
        body: Container(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _setDatePicker(),
              Container(
                height: 1.5,
                color: Colors.black26,
              ),
              Container(
                padding: EdgeInsets.only(bottom: 2.0),
                child: Text("${User.me.name}, ${User.me.role}, ${User.me.company}"),
              ),
              Expanded(
                child: (_records == null || _records.isEmpty) ? placeholderContent : TimeRecordListAdapter(items: _records, adapterClickListener: this),
              )
            ],
          ),
        ),
      );
  }

  @override
  void onLogoutClicked() {
    print("onLogoutClicked");
  }

  @override
  void onProfileClicked() {
    print("onProfileClicked");
  }

  @override
  void onReportClicked() {
    print("onReportClicked");
  }

  @override
  void onTimeClicked() {
    print("onTimeClicked");
  }

  @override
  void onUsersClicked() {
    print("onUsersClicked");
  }

  void _select(Choice choice){
    setState(() {
      if(choice.action == Action.Logout ){
        _logout();
      }
    });
  }

  _logout(){
    Navigator.of(context).
    pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => new LoginPage()));
  }

  AppBar _buildAppBar({String title}) {
    return AppBar(
      title: Text(title),
      actions: <Widget>[
        PopupMenuButton<Choice>(
          onSelected: _select,
          itemBuilder: (BuildContext context){
            return choices.map((Choice c){
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


  Widget _setDatePicker(){
    return  Container(
      padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
      child: new Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                print("onTap dateInput");
                _showDateDialog();
              },
              child: Icon(Icons.date_range),
            ),
          ),
          Container(
            child: new Flexible(
                child: new TextField(
                    decoration: InputDecoration(hintText: "Date",
                        contentPadding: EdgeInsets.fromLTRB(
                            10.0, 10.0, 10.0, 10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0))),
                    controller: dateInputController,
                    maxLines: 1)),
          ),
        ],
      ),
    );
  }

  _navigateToNextScreen(){
    final projects = User.me.projects;
    print("_navigateToNextScreen: " + projects.toString());
      Navigator.of(context).
      push(new MaterialPageRoute(builder: (BuildContext context) => new NewRecordPage(projects: projects, dateTime: _selectedDate, timeRecord: null, flow: NewRecordFlow.new_record))).then((value){
        print("got value from page");
        if(value != null){
          if(value is TimeRecord){
            _onDateSelected(value.dateTime);
          }else{
            _loadRecords(_selectedDate);
          }
        }
      });
  }

  _navigateToEditScreen(TimeRecord item){
    print("_navigateToEditScreen: ");
    Navigator.of(context).
    push(new MaterialPageRoute(builder: (BuildContext context) => new NewRecordPage(projects: User().projects, dateTime: _selectedDate, timeRecord: item, flow: NewRecordFlow.update_record))).then((value){
      print("got value from page");
      if(value != null){
        if(value is TimeRecord){
          _onDateSelected(value.dateTime);
        }else{
          _loadRecords(_selectedDate);
        }
      }
    });
  }

   _showDateDialog() {
     showDatePicker(context: context,
        initialDate: _selectedDate != null ? _selectedDate : DateTime.now(),
        firstDate: DateTime(_selectedDate.year-1, 1),
        lastDate: DateTime(_selectedDate.year, 12)).then((picked){
        setState(() {
         _onDateSelected(picked);
       });
    });
  }

  _onDateSelected(DateTime selectedDate){
    _selectedDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 0, 0, 0, 0, 0);
    dateInputController = new TextEditingController(text: "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}");
    _loadRecords(selectedDate);
  }

  void _loadRecords(DateTime selectedDate) {
    repository.getAllTimeForDate(_selectedDate).then((records) {
//      debugPrint(records.toString());
      _refreshList(records);
    }, onError: (e){
      print("There was an error: $e");
      if(e is RangeError){
        _refreshList(new List<TimeRecord>());
      }else{
        print(e);
       // _logout();
      }
    });
  }

  void _refreshList(List<TimeRecord> records){
    setState(() {
      print("records for ${_selectedDate} : ${records.toString()}:${records.length}");
      _records = records;
    });
  }

  @override
  StatelessElement createElement() {
    // TODO: implement createElement
  }

  @override
  List<DiagnosticsNode> debugDescribeChildren() {
    // TODO: implement debugDescribeChildren
  }

  // TODO: implement key
  @override
  Key get key => null;

  @override
  String toStringDeep({String prefixLineOne = '', String prefixOtherLines, DiagnosticLevel minLevel = DiagnosticLevel.debug}) {
    // TODO: implement toStringDeep
  }

  @override
  String toStringShallow({String joiner = ', ', DiagnosticLevel minLevel = DiagnosticLevel.debug}) {
    // TODO: implement toStringShallow
  }

  @override
  onListItemClicked(TimeRecord item) {
    print("onListItemClicked: $item");
    _navigateToEditScreen(item);
  }

  @override
  onListItemLongClick(TimeRecord item) {
    print("onListItemLongClick: $item");
  }
}

enum Action{
  Logout,
  Close
}

class Choice{
  final Action action;
  final String title;
  final IconData icon;
  const Choice({this.action, this.title, this.icon});
}

const List<Choice> choices = const <Choice>[
  const Choice(action : Action.Logout, title: "Logout", icon:  Icons.transit_enterexit)
];
