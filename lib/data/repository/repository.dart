import 'package:tikal_time_tracker/data/member.dart';
import 'package:tikal_time_tracker/data/models.dart';

abstract class Repository{
  Stream<List<Member>> getAllUsers(Role role);
  Stream<TimeReport> getTimeRecords(DateTime date);
}