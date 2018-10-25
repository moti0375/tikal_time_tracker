import '../mvp_base.dart';
import '../../data/models.dart';
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