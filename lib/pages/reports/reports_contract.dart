import '../../data/models.dart';

class ReportsPresenterContract{
  void subscribe(ReportsViewContract view){}
  void onClickGenerateButton(DateTime startDate, DateTime endDate){}
}

class ReportsViewContract{
  void showReport(List<TimeRecord> items){}
}