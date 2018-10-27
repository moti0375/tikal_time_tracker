import 'package:tikal_time_tracker/pages/reports/generate_report_page.dart';
import 'package:tikal_time_tracker/data/project.dart';
import 'package:tikal_time_tracker/data/task.dart';
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

  ReportForm({this.project, this.task, this.startDate, this.endDate, this.period});
}