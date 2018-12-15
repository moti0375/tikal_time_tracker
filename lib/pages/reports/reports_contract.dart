import 'package:tikal_time_tracker/data/models.dart';
import 'package:tikal_time_tracker/data/project.dart';
import 'package:tikal_time_tracker/data/task.dart';
import 'package:tikal_time_tracker/pages/reports/generate_report_page.dart';

class ReportsPresenterContract{
  void subscribe(ReportsViewContract view){}
  void onClickGenerateButton(Project project, Task task, DateTime startDate, DateTime endDate, Period onClickGenerateButton){}
}

class ReportsViewContract{
  void showReport(List<TimeRecord> items){}
  void logOut(){}
}