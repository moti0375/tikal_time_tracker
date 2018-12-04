import 'package:tikal_time_tracker/pages/reports/generate_report_page.dart';
import 'package:tikal_time_tracker/data/project.dart';
import 'package:tikal_time_tracker/data/task.dart';
import 'package:tikal_time_tracker/data/member.dart';
class ReportForm{

  String favoriteReport;
  Project project;
  Task task;
  Period period;
  DateTime startDate;
  DateTime endDate;
  int chProject = 1;
  int chTask = 1;
  int chStart = 1;
  int chFinish = 1;
  int chNote = 1;
  List<Member> members;

  ReportForm({this.project, this.task, this.startDate, this.endDate, this.period, this.members});

  @override
  String toString() {
    return 'ReportForm{favoriteReport: $favoriteReport, project: $project, task: $task, period: $period, startDate: $startDate, endDate: $endDate, chProject: $chProject, chTask: $chTask, chStart: $chStart, chFinish: $chFinish, chNote: $chNote, members: $members}';
  }


}