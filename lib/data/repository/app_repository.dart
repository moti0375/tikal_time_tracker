import 'package:tikal_time_tracker/data/member.dart';
import 'package:tikal_time_tracker/data/models.dart';
import 'package:tikal_time_tracker/data/remote.dart';
import 'package:tikal_time_tracker/data/repository/login_data_source.dart';
import 'package:tikal_time_tracker/data/repository/login_repository.dart';
import 'package:tikal_time_tracker/data/repository/time_data_source.dart';
import 'package:tikal_time_tracker/data/repository/time_records_repository.dart';
import 'package:tikal_time_tracker/network/requests/reports_form.dart';
import 'package:tikal_time_tracker/network/requests/reset_password_form.dart';
import 'package:tikal_time_tracker/network/requests/send_email_form.dart';
import 'package:tikal_time_tracker/services/auth/user.dart';

class AppRepository implements TimeDateSource, LoginDataSource{
  final TimeRecordsRepository _timeRepository;
  final LoginRepository _loginRepository;

  AppRepository(this._timeRepository, this._loginRepository);


  //TimeTrackerRepository
  @override
  Future addTime(TimeRecord time) {
    return _timeRepository.addTime(time);
  }

  @override
  Future deleteTime(TimeRecord time) {
    return _timeRepository.deleteTime(time);
  }

  @override
  Future<List<TimeRecord>> generateReport(ReportForm request) {
    return _timeRepository.generateReport(request);
  }

  @override
  Future<TimeReport> getAllTimeForDate(DateTime date) {
    return _timeRepository.getAllTimeForDate(date);
  }


  @override
  Future<List<TimeRecord>> getReport(ReportForm request, Role role) {
    return _timeRepository.getReport(request, role);
  }

  @override
  Future reportsPage(Role role) {
    return _timeRepository.reportsPage(role);
  }

  @override
  Future resetPassword(ResetPasswordForm login) {
    return _timeRepository.resetPassword(login);
  }

  @override
  Future resetPasswordPage() {
    return _timeRepository.resetPasswordPage();
  }

  @override
  Future sendEmail(SendEmailForm request) {
    return _timeRepository.sendEmail(request);
  }

  @override
  Future sendEmailPage() {
    return _timeRepository.sendEmailPage();
  }

  @override
  Future timePage() {
    return _timeRepository.timePage();
  }

  @override
  Future updateTime(TimeRecord time) {
    return _timeRepository.updateTime(time);
  }

  //Login Repository
  @override
  Future<User> login(String email, String password) {
    return _loginRepository.login(email, password);
  }

  @override
  Future<List<Member>> getAllMembers(Role role) {
    return _timeRepository.getAllMembers(role);
  }

  @override
  Future<DateTime> getIncompleteRecordById(int id) {
    return _timeRepository.getIncompleteRecordById(id);
  }

  @override
  Future<Remote> getRemoteFromRecord(int recordId) {
    return _timeRepository.getRemoteFromRecord(recordId);

  }



}