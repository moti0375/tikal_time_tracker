
import 'package:get_it/get_it.dart';
import 'package:tikal_time_tracker/data/dom/dom_parser.dart';
import 'package:tikal_time_tracker/data/repository/app_repository.dart';
import 'package:tikal_time_tracker/data/repository/login_data_source.dart';
import 'package:tikal_time_tracker/data/repository/login_repository.dart';
import 'package:tikal_time_tracker/data/repository/remote/login_remote_datasource.dart';
import 'package:tikal_time_tracker/data/repository/remote/remote_data_source.dart';
import 'package:tikal_time_tracker/data/repository/time_records_repository.dart';
import 'package:tikal_time_tracker/network/credentials.dart';
import 'package:tikal_time_tracker/network/time_tracker_api.dart';
import 'package:tikal_time_tracker/services/auth/user.dart';

GetIt locator = GetIt.instance;

void setupLocator(){
  TimeTrackerApi api = TimeTrackerApi.create();
  locator.registerLazySingleton(() => DomParser());
  TimeRecordsRepository timeRecordsRepository = TimeRecordsRepository.init(RemoteDateSource(api: api), Credentials(signInUserName: "", signInPassword: ""));
  LoginRepository loginRepository = LoginRepository(LoginRemoteDataSource(api));
  locator.registerLazySingleton(() => AppRepository(timeRecordsRepository, loginRepository));
}

void setUser(User user){
  locator.registerSingleton(user);
}

void clearUser(){
//  locator.unregister<User>();
}