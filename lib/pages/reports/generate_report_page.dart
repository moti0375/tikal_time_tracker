import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:tikal_time_tracker/analytics/analytics.dart';
import 'package:tikal_time_tracker/data/models.dart';
import 'package:tikal_time_tracker/data/name_value_entity.dart';
import 'package:tikal_time_tracker/data/project.dart';
import 'package:tikal_time_tracker/data/repository/time_records_repository.dart';
import 'package:tikal_time_tracker/data/task.dart';
import 'package:tikal_time_tracker/pages/login/login_page.dart';
import 'package:tikal_time_tracker/pages/report/report_page.dart';
import 'package:tikal_time_tracker/pages/reports/reports_helper.dart';
import 'package:tikal_time_tracker/pages/reports/reports_store.dart';
import 'package:tikal_time_tracker/resources/strings.dart';
import 'package:tikal_time_tracker/services/auth/auth.dart';
import 'package:tikal_time_tracker/services/auth/user.dart';
import 'package:tikal_time_tracker/services/locator/locator.dart';
import 'package:tikal_time_tracker/ui/animation_button.dart';
import 'package:tikal_time_tracker/ui/page_title.dart';
import 'package:tikal_time_tracker/ui/platform_appbar.dart';
import 'package:tikal_time_tracker/utils/page_transition.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class GenerateReportPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return new GenerateReportState();
  }

  static Widget create() {
    return Provider(
      create: (context) => ReportsStore(locator<TimeRecordsRepository>(), locator<BaseAuth>(), locator<Analytics>()),
      child: GenerateReportPage(),
    );
  }
}

class GenerateReportState extends State<GenerateReportPage> with AutomaticKeepAliveClientMixin<GenerateReportPage>  {


  TextEditingController startDateInputController;
  TextEditingController endDateInputController;

  ReportsStore _store;
  List<ReactionDisposer> disposers = [];
  User _user;

  @override
  void initState() {
    super.initState();
    startDateInputController = TextEditingController();
    endDateInputController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    print('dispose');
    disposers.forEach((ReactionDisposer d) => d());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _user = Provider.of<BaseAuth>(context).getCurrentUser();
    print("didChangeDependencies: ${_user.toString()}");

    if(_store == null){
      _store ??= Provider.of<ReportsStore>(context);
      _initReactions();
    }
  }

  void _initReactions() {
    disposers.add(reaction((_) => _store.error, (error) {
      _logout();
    }));

    disposers.add(reaction((_) => _store.report, (List<TimeRecord> report) {
      print("report reaction called: ");
      showReport(report);
    }));

    disposers.add(reaction((_) => _store.startDate, (DateTime date) {
      print('startDate reaction');
      if (date != null) {
        startDateInputController.text = "${_store.startDate.day}/${_store.startDate.month}/${_store.startDate.year}";
      }
    }));
    disposers.add(reaction((_) => _store.endDate, (DateTime date) {
      if (date != null) {
        endDateInputController.text = "${_store.endDate.day}/${_store.endDate.month}/${_store.endDate.year}";
      }
    }));
  }


  List<DropdownMenuItem<Project>> _buildDropDownItems(User user) {
    return user != null
        ? user.projects.map((Project value) {
            return new DropdownMenuItem<Project>(
              value: value,
              child: new Text(
                value.name,
                style: TextStyle(fontSize: 24.0),
              ),
            );
          }).toList()
        : null;
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildProjectDropDown() {
      return Container(
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
                value: _store.project,
                items: _buildDropDownItems(_user),
                onChanged: (Project value) => _store.onProjectSelected(value)),
          ));
    }

    Widget _buildTasksDropDown() {
      return Container(
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
                value: _store.task,
                items: _store.project != null ? _createDropDownMenuItems<Task>(_store.project.tasks) : _createDropDownMenuItems<Task>(_user != null ? _user.tasks : []),
                onChanged: (Task value) => _store.onTaskSelected(value)),
          ));
    }

    Widget _buildPeriodDropDown() {
      print("_buildPeriodDropDown: ");
      return Container(
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
              value: _store.period,
              items: availablePeriods.map((Period value) {
                return new DropdownMenuItem<Period>(
                  value: value,
                  child: new Text(
                    value.name,
                    style: TextStyle(fontSize: 24.0),
                  ),
                );
              }).toList(),
              onChanged: (Period value) => _store.onPeriodChanged(value)),
        ),
      );
    }

    Widget _buildStartDateInput() => Container(
          padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 4.0),
          child: new Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () => _showStartDatePicker(),
                  child: Icon(Icons.date_range),
                ),
              ),
              Container(
                child: new Flexible(
                    child: new TextField(
                  decoration:
                      InputDecoration(hintText: Strings.start_date, contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0), border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0))),
                  maxLines: 1,
                  controller: startDateInputController,
                )),
              ),
            ],
          ),
        );

    Widget _buildEndDateInput() => Container(
          padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 8.0),
          child: new Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () => _showEndDatePicker(),
                  child: Icon(Icons.date_range),
                ),
              ),
              Container(
                child: new Flexible(
                  child: new TextField(
                      decoration: InputDecoration(
                          hintText: Strings.end_date, contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0), border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0))),
                      maxLines: 1,
                      controller: endDateInputController,
                  )
                ),
              ),
            ],
          ),
        );

    Widget _generateButton() => Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      child: AnimationButton(
        onPressed: _store.buttonEnabled
            ? () {
                if (_store.buttonEnabled) {
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
        child: Observer(
          builder: (_) => Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TimeTrackerPageTitle(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    _buildProjectDropDown(),
                    _buildTasksDropDown(),
                    _buildStartDateInput(),
                    _buildEndDateInput(),
                    _buildPeriodDropDown(),
                  ],
                ),
              ),
              _generateButton(),
            ],
          ),
        ),
      ),
    );
  }

  Future<Null> _showStartDatePicker() async {
    final DateTime picked = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(DateTime.now().year - 1, 1), lastDate: DateTime(DateTime.now().year, 12));
    if (picked != null) {
      _store.onStartDate(DateTime(picked.year, picked.month, picked.day));
    }
  }

  Future<Null> _showEndDatePicker() async {
    final DateTime picked = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(DateTime.now().year - 1, 1), lastDate: DateTime(DateTime.now().year, 12));

    if (picked != null) {
      _store.onEndDate(DateTime(picked.year, picked.month, picked.day));
    }
  }

  void _handleGenerateButtonClicked() {
    Provider.of<ReportsStore>(context, listen: false).onClickGenerateButton();
  }

  void showReport(List<TimeRecord> items) {
    Navigator.of(context).push(new PageTransition(widget: ReportPage.create(Report(report: items, startDate: _store.startDate, endDate: _store.endDate, project: null, task: null))));
  }

  void logOut() {
    _logout();
  }

  _logout() {
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
