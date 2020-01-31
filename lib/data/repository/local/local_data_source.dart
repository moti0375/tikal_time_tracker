import 'package:flutter/material.dart';
import 'package:tikal_time_tracker/data/member.dart';
import 'package:tikal_time_tracker/network/credentials.dart';
import 'package:tikal_time_tracker/network/requests/reports_form.dart';
import 'package:tikal_time_tracker/network/requests/reset_password_form.dart';
import 'package:tikal_time_tracker/data/models.dart';
import 'package:tikal_time_tracker/data/repository/time_data_source.dart';
import 'package:tikal_time_tracker/data/database/database_helper.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:tikal_time_tracker/network/requests/send_email_form.dart';

class LocalDataSource implements TimeDateSource {

  var records = [TimeRecord(id: 1,
      date: DateTime(2018, 8, 10),
      start: TimeOfDay(hour: 8, minute: 0),
      finish: TimeOfDay(hour: 17, minute: 30),
      comment: "Great day"),
  TimeRecord(id: 2,
      date: DateTime(2018, 8, 11),
      start: TimeOfDay(hour: 8, minute: 0),
      finish: TimeOfDay(hour: 17, minute: 0),
      comment: "Great day")
  ];

  final TimeRecordDatabaseOpenHelper databaseOpenHelper = TimeRecordDatabaseOpenHelper();

  LocalDataSource() {
    _openDataBase();
  }

  void _openDataBase()  async {
    String databasePath = await getDatabasesPath();
    databaseOpenHelper.open("$databasePath/timeRecords.db");
  }
  
  @override
  Future<dynamic> addTime(TimeRecord time) {
    return null;
  }

  @override
  Future<dynamic> deleteTime(TimeRecord time) {
    return null;
  }

  @override
  Future<TimeReport> getAllTimeForDate(DateTime date) {
    return databaseOpenHelper.getTimeRecordForDate(date);
  }

  @override
  Future<int> deleteTimeRecordForDate(DateTime dateTime) {
    return databaseOpenHelper.deleteRecordsForDate(dateTime);
  }

  @override
  Future<List<TimeRecord>> getRecordsBetweenDates(DateTime startDate, DateTime endDate) {
    return databaseOpenHelper.getRecordsBetweenDates(startDate, endDate);
  }


  @override
  void updateCredentials(Credentials credentials) {
    // TODO: implement updateCredentials
  }

  @override
  Future<dynamic> timePage() {
    return null;
  }

  @override
  Stream<List<Member>> getAllMembers(Role role) {
    return null;
  }

  @override
  Future<List<TimeRecord>> generateReport(ReportForm request) {
    return null;
  }

  @override
  Future reportsPage(Role role) {
    return null;
  }

  @override
  Future getReport(ReportForm request, Role role) {
    return null;
  }

  @override
  Future updateTime(TimeRecord time) {
    return null;
  }

  @override
  Future resetPasswordPage() {
    return null;
  }

  @override
  Future resetPassword(ResetPasswordForm request) {
    return null;
  }

  @override
  Future sendEmail(SendEmailForm request) {
    return null;
  }

  @override
  Future<SendEmailForm> sendEmailPage() {
    return null;
  }

  @override
  Future<DateTime> getIncompleteRecordById(int id) {
    return null;
  }

}