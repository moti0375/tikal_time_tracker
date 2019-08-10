import '../../pages/mvp_base.dart';
import 'time_contract.dart';
import '../../data/repository/time_records_repository.dart';
import '../../data/models.dart';

class TimePresenter implements TimeContractPresenter{

  TimeContractView view;
  TimeRecordsRepository repository;
  TimeReport records;
  TimePresenter({this.repository});
  @override
  void subscribe(BaseView view) {
    this.view = view;
  }

  @override
  void unsubscribe() {
  }

  @override
  void setProgressView(bool visible) {
    // TODO: implement setProgressView
  }

  @override
  void loadTimeForDate(DateTime date) {
    _loadTime(date);
  }

  _loadTime(DateTime date){
    repository.getAllTimeForDate(date).then((records) {
        this.records = records;
        view.timeLoadFinished(this.records);
    }, onError: (e){
      print("PagePresenter There was an error: $e");
      if(e is RangeError){
        this.records = new TimeReport(timeReport: new List<TimeRecord>());
        view.timeLoadFinished(this.records);
      }else{
        print(e);
        view.logOut();
      }
    });
  }

  @override
  void listItemClicked(TimeRecord item) {
    view.openNewRecordPage(item);
  }

  @override
  void onLogoutClicked() {
    view.logOut();
  }

  @override
  void onAboutClicked() {
    view.showAboutScreen();
  }

  @override
  void onItemDismissed(TimeRecord item) {
    repository.deleteTime(item).then((value){
      view.refresh();
    });
  }
}