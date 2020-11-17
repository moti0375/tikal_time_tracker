import 'package:mobx/mobx.dart';
import 'package:tikal_time_tracker/analytics/analytics.dart';
import 'package:tikal_time_tracker/analytics/events/reports_event.dart';
import 'package:tikal_time_tracker/data/models.dart';
import 'package:tikal_time_tracker/resources/strings.dart';
import 'package:tikal_time_tracker/services/auth/auth.dart';

import 'package:tikal_time_tracker/data/repository/time_records_repository.dart';
import 'package:tikal_time_tracker/data/project.dart';
import 'package:tikal_time_tracker/data/task.dart';
import 'package:tikal_time_tracker/pages/users/member_list_item.dart';
import 'package:tikal_time_tracker/data/member.dart';
import 'package:tikal_time_tracker/network/requests/reports_form.dart';
import 'package:flutter/material.dart';
import 'package:tikal_time_tracker/pages/reports/generate_report_page.dart';
import 'package:tikal_time_tracker/utils/utils.dart';

part 'reports_store.g.dart';

class ReportsStore extends _ReportsStore with _$ReportsStore{
  ReportsStore(TimeRecordsRepository repository, BaseAuth auth, Analytics analytics) : super(repository, auth, analytics);
}

abstract class _ReportsStore with Store{

  static const String TAG = "ReportsStore";
  final TimeRecordsRepository _repository;
  final BaseAuth _auth;
  final Analytics _analytics;
  List<Member> _members;

  @observable
  List<TimeRecord> report;

  @observable
  bool error = false;

  @observable
  Project _selectedProject;
  Project get project => _selectedProject;

  @observable
  Task _selectedTask;
  Task get task => _selectedTask;

  @observable
  DateTime _startDate;
  DateTime get startDate => _startDate;

  @observable
  DateTime _endDate;
  DateTime get endDate => _endDate;

  @observable
  Period _period;
  Period get period => _period;

  @computed
  bool get buttonEnabled =>  _startDate != null && _endDate != null;

  _ReportsStore(this._repository, this._auth, this._analytics){
    _analytics.logEvent(ReportsEvent.impression(EVENT_NAME.REPORTS_SCREEN).open());
    _loadReportsPage();
  }

  void onClickGenerateButton() {
    _analytics.logEvent(ReportsEvent.click(EVENT_NAME.GENERATE_REPORT_CLICKED));
    ReportForm request = ReportForm(project: _selectedProject, task: _selectedTask, startDate:  _startDate, endDate: _endDate, period: _period, members: this._members);
    _generateReport(request);
  }


  void _loadReportsPage(){
    print("_loadReportsPage: ${_auth.getCurrentUser().toString()}");
    _repository.reportsPage(_auth.getCurrentUser().role).then((response){
      print("_loadReportsPage: Success");

      if(response is List<Member>){
        this._members = response;
        response.map((member){
         print("_loadReportsPage: member: ${member.toString()}");
          return MemberListItem(member: member);
        }).toList();
      }
//      print("$TAG: reportsPage: ${response}");
    },onError: (e){
      debugPrint("_loadReportsPage There was an error ${e.toString()}");
    });
  }

  void _generateReport(ReportForm request){
    print("_generateReport: ");
    _repository.generateReport(request).then((report){
      debugPrint("$TAG: _generateReport: ${report.toString()}");
      _getReport(request);
    }, onError: (e){
      debugPrint("$TAG: _generateReport: There was an error ${e.toString()}");
      if(e is RangeError){
      }else{
        print(e);
        _analytics.logEvent(ReportsEvent.impression(EVENT_NAME.FAILED_TO_GENERATE_REPORT).view().setDetails("Logout"));
        error = true;
      }
    });
  }

  void _getReport(ReportForm request){
    _repository.getReport(request, _auth.getCurrentUser().role).then((response){
      debugPrint("_getReport: ${response.toString()}");
      report = response;
      _analytics.logEvent(ReportsEvent.impression(EVENT_NAME.REPORT_GENERATED_SUCCESS).view());
    }, onError: (e){
      debugPrint("_getReport: there was an error: ${e.toString()}");
    });
  }

  @action
  void onProjectSelected(Project project){
    this._selectedProject = project;
    this._selectedTask = null;
  }

  @action
  void onTaskSelected(Task task){
    this._selectedTask = task;
  }

  @action
  void onStartDate(DateTime date) {
    this._startDate = date;
  }

  @action
  void onEndDate(DateTime date){
    this._endDate = date;
  }

  @action
  void onPeriodChanged(Period p){
    print("onPeriodChanged: $p");
    this._period = p;
    _handlePeriodChange();
  }

  void _handlePeriodChange() {
    switch (_period.name) {
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
  }

  void _onSelectThisMonth() {
    onStartDate(DateTime(DateTime.now().year, DateTime.now().month, 1));
    onEndDate(DateTime(DateTime.now().year, DateTime.now().month, Utils.getDaysInMonth(DateTime.now().year, DateTime.now().month)));
  }

  void _onSelectPreviousMonth() {
    onStartDate(DateTime(DateTime.now().year, DateTime.now().month - 1, 1));
    onEndDate(DateTime(DateTime.now().year, DateTime.now().month - 1, Utils.getDaysInMonth(DateTime.now().year, DateTime.now().month - 1)));
  }

  void _onSelectThisWeek() {
    onStartDate(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - DateTime.now().weekday));
    onEndDate(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + (7 - DateTime.now().weekday) - 1));
  }

  void _onSelectedPrevWeek() {
    onStartDate(DateTime(DateTime.now().year, DateTime.now().month, (DateTime.now().day - DateTime.now().weekday) - 7));
    onEndDate(DateTime(DateTime.now().year, DateTime.now().month, (DateTime.now().day + (7 - DateTime.now().weekday) - 1) - 7));
  }

  void _onTodaySelected() {
    onStartDate(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day));
    onEndDate(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day));
  }

  void _onYesterdaySelected() {
    onStartDate(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - 1));
    onEndDate(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - 1));
  }

}