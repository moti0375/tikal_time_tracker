import 'package:tikal_time_tracker/data/repository/login_data_source.dart';
import 'package:tikal_time_tracker/services/auth/user.dart';

class LoginRepository extends LoginDataSource{
  
  LoginDataSource _loginRemoteDataSource;
  LoginRepository(this._loginRemoteDataSource);
  
  @override
  Future<User> login(String email, String password) {
    return _loginRemoteDataSource.login(email, password);
  }
}