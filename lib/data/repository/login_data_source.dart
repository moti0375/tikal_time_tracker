import 'package:tikal_time_tracker/network/credentials.dart';
import 'package:tikal_time_tracker/services/auth/user.dart';

abstract class LoginDataSource{
  Future<User> login(String email, String password);
}
