
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tikal_time_tracker/analytics/analytics.dart';
import 'package:tikal_time_tracker/analytics/firebase_endpoint.dart';
import 'package:tikal_time_tracker/data/dom/dom_parser.dart';
import 'package:tikal_time_tracker/data/repository/app_repository.dart';
import 'package:tikal_time_tracker/data/repository/login_repository.dart';
import 'package:tikal_time_tracker/data/repository/remote/login_remote_datasource.dart';
import 'package:tikal_time_tracker/data/repository/remote/remote_data_source.dart';
import 'package:tikal_time_tracker/data/repository/time_records_repository.dart';
import 'package:tikal_time_tracker/network/credentials.dart';
import 'package:tikal_time_tracker/network/time_tracker_api.dart';
import 'package:tikal_time_tracker/services/auth/user.dart';
import 'package:tikal_time_tracker/storage/preferences.dart';

GetIt locator = GetIt.instance;

Future<void> setupLocator() async {

  Preferences preferences = await initPreferences();
  locator.registerLazySingleton(() => preferences);

  FirebaseEndpoint firebaseEndpoint = FirebaseEndpoint();
  Analytics.install(firebaseEndpoint);
  locator.registerLazySingleton(() => Analytics.instance);

  TimeTrackerApi api = TimeTrackerApi.create();
  locator.registerLazySingleton(() => DomParser());
  TimeRecordsRepository timeRecordsRepository = TimeRecordsRepository.init(RemoteDateSource(api: api), Credentials(signInUserName: "", signInPassword: ""));
  LoginRepository loginRepository = LoginRepository(LoginRemoteDataSource(api));
  locator.registerLazySingleton(() => AppRepository(timeRecordsRepository, loginRepository));
}

Future<Preferences> initPreferences() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return Preferences.init(preferences);
}
