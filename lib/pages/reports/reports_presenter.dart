import 'reports_contract.dart';
import 'package:tikal_time_tracker/data/repository/time_records_repository.dart';
import 'package:tikal_time_tracker/data/project.dart';
import 'package:tikal_time_tracker/data/task.dart';
import 'package:tikal_time_tracker/data/user.dart';
import 'package:tikal_time_tracker/pages/users/member_list_item.dart';
import 'package:tikal_time_tracker/data/member.dart';
import 'package:tikal_time_tracker/network/requests/reports_form.dart';
import 'package:flutter/material.dart';
import 'package:tikal_time_tracker/pages/reports/generate_report_page.dart';

class ReportsPresenter implements ReportsPresenterContract {

  static const String TAG = "ReportsPresenter";
  TimeRecordsRepository repository;
  ReportsViewContract view;
  List<Member> members;

  ReportsPresenter({this.repository});

  @override
  void onClickGenerateButton(Project project, Task task, DateTime startTime, DateTime endDate, Period period) {
    ReportForm request = ReportForm(project: project, task: task, startDate:  startTime, endDate: endDate, period: period, members: this.members);
    _generateReport(request);
  }

  @override
  void subscribe(ReportsViewContract view) {
    this.view = view;
    _loadReportsPage();
  }

  void _loadReportsPage(){
    repository.reportsPage(User.me.role).then((response){
      print("_loadReportsPage: Success");

      if(response is List<Member>){
        this.members = response;
        print("_loadReportsPage: ${this.members.toString()}");
        List<MemberListItem> items = response.map((member){
//          print("_loadReportsPage: ${member.toString()}");
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
    repository.generateReport(request).then((report){
      debugPrint("$TAG: _generateReport: ${report.toString()}");
      _getReport(request);
    }, onError: (e){
      debugPrint("$TAG: _generateReport: There was an error ${e.toString()}");
      if(e is RangeError){
      }else{
        print(e);
        view.logOut();
      }
    });
  }

  void _getReport(ReportForm request){
    repository.getReport(request, User.me.role).then((response){
      debugPrint("_getReport: ${response.toString()}");
      view.showReport(response);
    }, onError: (e){
      debugPrint("_getReport: there was an error: ${e.toString()}");
    });
  }
}