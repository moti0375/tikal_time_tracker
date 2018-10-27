import '../../pages/mvp_base.dart';
import 'time_contract.dart';
import '../../data/repository/time_records_repository.dart';
import '../../data/models.dart';

class TimePresenter implements TimeContractPresenter{

  TimeContractView view;
  TimeRecordsRepository repository;
  List<TimeRecord> records;
  TimePresenter({this.repository}){

  }
  @override
  void subscribe(BaseView view) {
    this.view = view;
  }

  @override
  void unsubscribe() {
  }

  @override
  void newRecordClicked() {
    // TODO: implement newRecordClicked
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
      print("There was an error: $e");
      if(e is RangeError){
        this.records = new List<TimeRecord>();
        view.timeLoadFinished(this.records);
      }else{
        print(e);
        // _logout();
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
}