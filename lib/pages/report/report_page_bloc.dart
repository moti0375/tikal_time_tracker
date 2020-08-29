import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:tikal_time_tracker/analytics/analytics.dart';
import 'package:tikal_time_tracker/analytics/events/reports_event.dart';
import 'package:tikal_time_tracker/data/models.dart';
import 'package:tikal_time_tracker/pages/report/report_page_event.dart';
import 'package:tikal_time_tracker/pages/report/report_page_state_model.dart';
import 'package:tikal_time_tracker/pages/report_analysis/report_analysis_page.dart';
import 'package:tikal_time_tracker/services/auth/auth.dart';
import "package:collection/collection.dart";
import 'package:tikal_time_tracker/storage/preferences.dart';
import 'package:tikal_time_tracker/utils/page_transition.dart';

class ReportPageBloc{
  final Analytics _analytics;
  final Preferences _preferences;
  ReportPageStateModel _stateModel = ReportPageStateModel();
  final BaseAuth auth;

  StreamController<ReportPageStateModel> _reportStreamController = StreamController();
  Stream<ReportPageStateModel> get reportStream => _reportStreamController.stream;
  Sink<ReportPageStateModel> get _reportSink => _reportStreamController.sink;

  StreamController<ReportPageEvent> _eventsController = StreamController<ReportPageEvent>();
  Sink<ReportPageEvent> get _eventsSink => _eventsController.sink;



  ReportPageBloc(this._analytics, Report report, this._preferences, this.auth){
    print("ReportPageBloc: initializig bloc");
    _analytics.logEvent(ReportsEvent.impression(EVENT_NAME.REPORT_GENERATED_SUCCESS).
    setUser(auth.getCurrentUser().name).
    open());

    var builder = ReportPageStateModelBuilder.fromAppState(_stateModel);
    builder.timeTrackerReport = report;
    _stateModel = builder.build();
    initBlocEventListener();
    _reportSink.add(_stateModel);

    if(report.report != null && report.report.isNotEmpty){
      createReportAnalysis();
    }

    _updateUserSawAnalysisOption();
  }

  void initBlocEventListener() {
    _eventsController.stream.listen((e){
      _handleInputEvents(e);
    });
  }

  void dispatchEvent(ReportPageEvent event){
   _eventsSink.add(event);
  }

  void dispose(){
    _reportStreamController.close();
    _eventsController.close();
  }

  void _handleInputEvents(ReportPageEvent e) {

    if(e is OnAnalysisItemClick){
      _navigateToReportAnalysis(e.context);
    }
  }

  void createReportAnalysis() {
    var builder = ReportPageStateModelBuilder.fromAppState(_stateModel);

    Iterable r = _stateModel.timeTrackerReport.report;
    Map<String, double> projectMap = Map();
    groupBy<TimeRecord, String>(r,  ((timeRecord) => timeRecord.project.name)).forEach((key, items){
      Duration duration = Duration();
      items.forEach((recordForProject) {
        duration += recordForProject.duration;
      });
      projectMap[key] = duration.inMilliseconds.toDouble();
    });

    builder.updateAnalysis(projectMap);

    Map<String, double> tasksMap = Map();

    groupBy<TimeRecord, String>(r,  ((timeRecord) => timeRecord.task.name)).forEach((key, items){
      Duration duration = Duration();
      items.forEach((recordForProject) {
        duration += recordForProject.duration;
      });
      tasksMap[key] = duration.inMilliseconds.toDouble();
    });

    builder.updateAnalysis(tasksMap);
    _stateModel = builder.build();

    print("createReportAnalysis: ${_stateModel.reportAnalysis.toString()}");
  }

  void _navigateToReportAnalysis(BuildContext context) {

    Navigator.of(context).push(new PageTransition(widget: ReportAnalysisPage(analysis: _stateModel.reportAnalysis,)));
  }

  void _updateUserSawAnalysisOption() async {
    print("ReportPageBloc: _updateUserSawAnalysisOption: ");
    _preferences.setAnalysisCounter();
    var didUserSawAnalysisOption = await _preferences.didUserSawAnalysis();

    print("ReportPageBloc: didUserSawAnalysisOption: $didUserSawAnalysisOption");

    var builder = ReportPageStateModelBuilder.fromAppState(_stateModel);
    builder.userSawAnalysisOption = didUserSawAnalysisOption;
    _stateModel = builder.build();
    _reportSink.add(_stateModel);
  }
}

