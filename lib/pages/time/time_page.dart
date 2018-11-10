import 'package:flutter/material.dart';
import 'package:tikal_time_tracker/data/models.dart';
import 'package:tikal_time_tracker/data/user.dart';
import 'package:tikal_time_tracker/data/repository/time_records_repository.dart';
import 'package:tikal_time_tracker/pages/login_page.dart';
import 'package:tikal_time_tracker/ui/time_record_list_adapter.dart';
import 'package:tikal_time_tracker/pages/new_record_page/new_record_page.dart';
import 'package:tikal_time_tracker/pages/reports/place_holder_content.dart';
import 'package:tikal_time_tracker/ui/date_picker_widget.dart';
import 'package:tikal_time_tracker/pages/time/time_presenter.dart';
import 'package:tikal_time_tracker/pages/time/time_contract.dart';

class TimePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new TimePageState();
  }
}

class TimePageState extends State<TimePage>
    implements ListAdapterClickListener, TimeContractView {
  final _items = <String>["Moti", "Nurit", "Yarden", "Yahel"];
  Choice _onSelected;
  DateTime _selectedDate;
  TextEditingController dateInputController =
      new TextEditingController(text: "");

  TimeRecordsRepository repository = TimeRecordsRepository();
  List<TimeRecord> _records;
  TimePresenter presenter;

  @override
  void initState() {
    super.initState();
    print("initState");
    presenter = TimePresenter(repository: this.repository);
    presenter.subscribe(this);
    var now = DateTime.now();
    _selectedDate = DateTime(now.year, now.month, now.day, 0, 0, 0, 0, 0);
//    _loadRecords(_selectedDate);
    dateInputController = new TextEditingController(
        text:
            "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}");
    presenter.loadTimeForDate(_selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    PlaceholderContent placeholderContent = PlaceholderContent(
        title: "No Work Today",
        subtitle: "Tap to add report",
        onPressed: () {
          presenter.listItemClicked(null);
        });

    Widget _datePicker = TimeTrackerDatePicker(
        initializedDateTime: _selectedDate,
        onSubmittedCallback: (date) {
          _selectedDate = date;
          presenter.loadTimeForDate(_selectedDate);
        });

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.black12,
      appBar: _buildAppBar(title: "Tikal Time Tracker"),
      floatingActionButton: new FloatingActionButton(
          onPressed: () {
            presenter.listItemClicked(null);
          },
          child: Icon(Icons.add)),
      body: Container(
        padding: const EdgeInsets.all(32.0),
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
              child:
                  Text("${User.me.name}, ${User.me.role}, ${User.me.company}"),
            ),
            Expanded(
              child: (_records == null || _records.isEmpty)
                  ? placeholderContent
                  : TimeRecordListAdapter(
                      items: _records,
                      intermittently: true,
                      adapterClickListener: this),
            )
          ],
        ),
      ),
    );
  }

  void _select(Choice choice) {
    setState(() {
      if (choice.action == Action.Logout) {
        presenter.onLogoutClicked();
      }
    });
  }

  _logout() {
    Navigator.of(context).pushReplacement(new MaterialPageRoute(
        builder: (BuildContext context) => new LoginPage()));
  }

  AppBar _buildAppBar({String title}) {
    return AppBar(
      title: Text(title),
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

  Widget _setDatePicker() {
    return Container(
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
              decoration: InputDecoration(
                  hintText: "Date",
                  contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0))),
              maxLines: 1,
              controller: dateInputController,
            )),
          ),
        ],
      ),
    );
  }

  _navigateToNextScreen() {
    final projects = User.me.projects;
    print("_navigateToNextScreen: " + projects.toString());
    Navigator.of(context)
        .push(new MaterialPageRoute(
            builder: (BuildContext context) => new NewRecordPage(
                projects: projects,
                dateTime: _selectedDate,
                timeRecord: null,
                flow: NewRecordFlow.new_record)))
        .then((value) {
      print("got value from page");
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
    print("_navigateToEditScreen: ");
    Navigator.of(context)
        .push(new MaterialPageRoute(
            builder: (BuildContext context) => new NewRecordPage(
                projects: User.me.projects,
                dateTime: _selectedDate,
                timeRecord: item,
                flow: NewRecordFlow.update_record)))
        .then((value) {
      print("got value from page");
      if (value != null) {
        if (value is TimeRecord) {
          _onDateSelected(value.date);
        }
      } else {
        presenter.loadTimeForDate(_selectedDate);
      }
    });
  }

  _showDateDialog() {
    showDatePicker(
            context: context,
            initialDate: _selectedDate != null ? _selectedDate : DateTime.now(),
            firstDate: DateTime(_selectedDate.year - 1, 1),
            lastDate: DateTime(_selectedDate.year, 12))
        .then((picked) {
      setState(() {
        _onDateSelected(picked);
      });
    });
  }

  _onDateSelected(DateTime selectedDate) {
    _selectedDate = DateTime(
        selectedDate.year, selectedDate.month, selectedDate.day, 0, 0, 0, 0, 0);
    dateInputController = new TextEditingController(
        text: "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}");
    presenter.loadTimeForDate(selectedDate);
  }

  void _refreshList(List<TimeRecord> records) {
    setState(() {
      print(
          "records for $_selectedDate : ${records.toString()}:${records.length}");
      _records = records;
    });
  }


  @override
  onListItemClicked(TimeRecord item) {
    print("onListItemClicked: $item");
    presenter.listItemClicked(item);
  }

  @override
  onListItemLongClick(TimeRecord item) {
    print("onListItemLongClick: $item");
  }

  @override
  void openNewRecordPage(TimeRecord item) {
    if (item != null) {
      _navigateToEditScreen(item);
    } else {
      _navigateToNextScreen();
    }
  }

  @override
  void timeLoadFinished(List<TimeRecord> timeRecord) {
    setState(() {
      this._records = timeRecord;
    });
  }

  @override
  void logOut() {
    _logout();
  }
}

enum Action { Logout, Close }

class Choice {
  final Action action;
  final String title;
  final IconData icon;

  const Choice({this.action, this.title, this.icon});
}

const List<Choice> choices = const <Choice>[
  const Choice(
      action: Action.Logout, title: "Logout", icon: Icons.transit_enterexit)
];
