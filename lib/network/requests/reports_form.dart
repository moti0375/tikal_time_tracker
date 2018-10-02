
class ReportForm{

  String favoriteReport;
  String project;
  String task;
  DateTime startDate;
  DateTime endDate;
  int chProject = 1;
  int chTask = 1;
  int chStart = 1;
  int chFinish = 1;
  int chNote = 1;

  ReportForm({this.project, this.task, this.startDate, this.endDate});
}