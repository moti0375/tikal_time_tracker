import 'package:flutter/material.dart';
import '../../models.dart';
import '../time_data_source.dart';
import '../../database/database_helper.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';

class LocalDataSource implements TimeDateSource {

  var records = [TimeRecord(id: 1,
      dateTime: DateTime(2018, 8, 10),
      start: TimeOfDay(hour: 8, minute: 0),
      finish: TimeOfDay(hour: 17, minute: 30),
      comment: "Great day"),
  TimeRecord(id: 2,
      dateTime: DateTime(2018, 8, 11),
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
  Future<TimeRecord> addTimeForDate(TimeRecord time) {
    return databaseOpenHelper.insert(time);
  }

  @override
  Future<int> deleteTime(TimeRecord time) {
    records.remove(time.dateTime);
    return databaseOpenHelper.deleteRecordById(time.id);
  }

  @override
  Future<List<TimeRecord>> getAllTimeForDate(DateTime date) {
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
  Future<String> login() {
    return null;
  }

}