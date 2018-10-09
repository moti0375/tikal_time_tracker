import 'reports_contract.dart';
import '../../data/repository/time_records_repository.dart';
import '../../data/project.dart';
import '../../data/task.dart';
import '../../network/requests/reports_form.dart';
import 'package:flutter/material.dart';
import 'generate_report_page.dart';

class ReportsPresenter implements ReportsPresenterContract {

  static const String TAG = "ReportsPresenter";
  TimeRecordsRepository repository;
  ReportsViewContract view;

  ReportsPresenter({this.repository});

  @override
  void onClickGenerateButton(Project project, Task task, DateTime startTime, DateTime endDate, Period period) {
    ReportForm request = ReportForm(project: project, task: task, startDate:  startTime, endDate: endDate, period: period);
    _generateReport(request);
  }

  @override
  void subscribe(ReportsViewContract view) {
    this.view = view;
    _loadReportsPage();
  }

  void _loadReportsPage(){
    repository.reportsPage().then((response){
//      debugPrint("$TAG: reportsPage: ${response}");
    },onError: (e){
      debugPrint("There was an error ${e.toString()}");
    });
  }

  void _generateReport(ReportForm request){
    print("_generateReport: ");
    repository.generateReport(request).then((report){
      debugPrint("$TAG: _generateReport: ${report.toString()}");
      _getReport(request);
    });
  }

  void _getReport(ReportForm request){
    repository.getReport(request).then((response){
      debugPrint("_getReport: ${response.toString()}");
      view.showReport(response);
    }, onError: (e){
      debugPrint("_getReport: there was an error: ${e.toString()}");
    });
  }
}