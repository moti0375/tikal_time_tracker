import '../../data/models.dart';
import '../../data/project.dart';
import '../../data/task.dart';
import '../../pages/reports/generate_report_page.dart';

class ReportsPresenterContract{
  void subscribe(ReportsViewContract view){}
  void onClickGenerateButton(Project project, Task task, DateTime startDate, DateTime endDate, Period onClickGenerateButton){}
}

class ReportsViewContract{
  void showReport(List<TimeRecord> items){}
}