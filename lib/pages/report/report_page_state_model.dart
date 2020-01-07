import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:tikal_time_tracker/data/models.dart';

class ReportPageStateModel extends Equatable{
  final Report timeTrackerReport;
  final bool userSawAnalysisOption;
  final List<Map<String, dynamic>> reportAnalysis;
  ReportPageStateModel({this.timeTrackerReport, this.reportAnalysis, this.userSawAnalysisOption});

  @override
  List<Object> get props => null;
}

class ReportPageStateModelBuilder {
  Report timeTrackerReport;
  List<Map<String, double>> reportAnalysis = List();
  bool userSawAnalysisOption;

  ReportPageStateModelBuilder({this.timeTrackerReport});

  ReportPageStateModelBuilder.fromAppState(ReportPageStateModel state) {
    timeTrackerReport = state.timeTrackerReport;
    if(state.reportAnalysis != null){
      reportAnalysis = state.reportAnalysis;
    }

    if(state.userSawAnalysisOption != null){
      userSawAnalysisOption = state.userSawAnalysisOption;
    }
  }

  void updateAnalysis(Map<String, dynamic> entry){
    reportAnalysis.add(entry);
  }

  void setUserSawAnalysisOption(bool didSaw){
    this.userSawAnalysisOption = didSaw;
  }

  ReportPageStateModel build() {
    return new ReportPageStateModel(timeTrackerReport: this.timeTrackerReport, reportAnalysis:  reportAnalysis, userSawAnalysisOption: this.userSawAnalysisOption);
  }
}