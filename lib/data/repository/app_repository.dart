import 'package:tikal_time_tracker/data/member.dart';
import 'package:tikal_time_tracker/data/models.dart';
import 'package:tikal_time_tracker/data/repository/login_data_source.dart';
import 'package:tikal_time_tracker/data/repository/login_repository.dart';
import 'package:tikal_time_tracker/data/repository/time_data_source.dart';
import 'package:tikal_time_tracker/data/repository/time_records_repository.dart';
import 'package:tikal_time_tracker/network/credentials.dart';
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
  Future<int> deleteTimeRecordForDate(DateTime dateTime) {
    return _timeRepository.deleteTimeRecordForDate(dateTime);
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
  Future<List<TimeRecord>> getRecordsBetweenDates(DateTime startDate, DateTime endDate) {
    return _timeRepository.getRecordsBetweenDates(startDate, endDate);
  }

  @override
  Future getReport(ReportForm request, Role role) {
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
  void updateCredentials(Credentials credentials) {
    _timeRepository.updateCredentials(credentials);
  }

  @override
  Future updateTime(TimeRecord time) {
    return _timeRepository.updateTime(time);
  }

  @override
  Stream<TimeReport> getTimeRecords(DateTime date) {
    // TODO: implement getTimeRecords
    return null;
  }

  //Login Repository
  @override
  Future<User> login(String email, String password) {
    return _loginRepository.login(email, password);
  }

  @override
  Stream<List<Member>> getAllMembers(Role role) {
    return _timeRepository.getAllMembers(role);
  }



}