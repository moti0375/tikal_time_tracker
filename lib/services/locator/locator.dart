import 'package:get_it/get_it.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tikal_time_tracker/analytics/analytics.dart';
import 'package:tikal_time_tracker/analytics/firebase_endpoint.dart';
import 'package:tikal_time_tracker/data/dom/dom_parser.dart';
import 'package:tikal_time_tracker/data/repository/app_repository.dart';
import 'package:tikal_time_tracker/data/repository/login_repository.dart';
import 'package:tikal_time_tracker/data/repository/remote/login_remote_datasource.dart';
import 'package:tikal_time_tracker/data/repository/remote/remote_data_source.dart';
import 'package:tikal_time_tracker/data/repository/time_records_repository.dart';
import 'package:tikal_time_tracker/network/time_tracker_api.dart';
import 'package:tikal_time_tracker/services/auth/auth.dart';
import 'package:tikal_time_tracker/storage/preferences.dart';

GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  DomParser parser = DomParser();
  locator.registerSingleton(parser);

  await setPreferences();
  await setAnalytics();
  await setTimeTrackerApi();
  await registerPackageInfo();
  await setBaseAuth();
}

Future setTimeTrackerApi() async {
  TimeTrackerApi api = TimeTrackerApi.create();

  locator.registerLazySingleton<TimeTrackerApi>(() => api);

  locator.registerLazySingleton<LoginRemoteDataSource>(() => LoginRemoteDataSource(locator<TimeTrackerApi>(), parser: locator<DomParser>()));
  TimeRecordsRepository timeRecordsRepository = TimeRecordsRepository(remoteDateSource: RemoteDateSource(api: api, parser: locator<DomParser>()));

  locator.registerLazySingleton<TimeRecordsRepository>(() => timeRecordsRepository);
  LoginRepository loginRepository = LoginRepository(locator<LoginRemoteDataSource>());

  locator.registerLazySingleton<LoginRepository>(() => loginRepository);
  locator.registerLazySingleton(() => AppRepository(locator<TimeRecordsRepository>(), locator<LoginRepository>()));
}

Future setPreferences() async {
  Preferences preferences = await initPreferences();
  locator.registerLazySingleton(() => preferences);
}

Future setAnalytics() async {
  FirebaseEndpoint firebaseEndpoint = FirebaseEndpoint();
  Analytics.install(firebaseEndpoint);
  locator.registerLazySingleton(() => Analytics.instance);
}

Future registerPackageInfo() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  locator.registerLazySingleton(() => packageInfo);
}

Future<Preferences> initPreferences() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return Preferences.init(preferences);
}

Future setBaseAuth() async {
  BaseAuth auth = AppAuth(locator<AppRepository>());
  locator.registerLazySingleton<BaseAuth>(() => auth);
}
