import 'reports_contract.dart';
import '../../data/repository/time_records_repository.dart';
import '../../network/requests/reports_form.dart';
import 'package:flutter/material.dart';

class ReportsPresenter implements ReportsPresenterContract {

  static const String TAG = "ReportsPresenter";
  TimeRecordsRepository repository;
  ReportsViewContract view;

  ReportsPresenter({this.repository});

  @override
  void onClickGenerateButton(DateTime startTime, DateTime endDate) {
    ReportForm request = ReportForm(startDate:  startTime, endDate: endDate);
    _generateReport(request);
  }

  @override
  void subscribe(ReportsViewContract view) {
    this.view = view;
    _loadReportsPage();
  }

  void _loadReportsPage(){
    repository.reportsPage().then((response){
      debugPrint("$TAG: reportsPage: ${response}");
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
    }, onError: (e){
      debugPrint("_getReport: there was an error: ${e.toString()}");
    });
  }
}