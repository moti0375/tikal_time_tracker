import 'package:tikal_time_tracker/pages/mvp_base.dart';
import 'package:tikal_time_tracker/data/models.dart';
class TimeContractPresenter extends BasePresenter{
  void listItemClicked(TimeRecord item){}
  void loadTimeForDate(DateTime date){}
  void setProgressView(bool visible){}
  void onLogoutClicked(){}
}

class TimeContractView extends BaseView{
    void openNewRecordPage(TimeRecord item){}
    void timeLoadFinished(List<TimeRecord> timeRecord){}
    void logOut(){}
}