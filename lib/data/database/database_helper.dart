import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:tikal_time_tracker/data/models.dart';

const String tableName = "times_record";
const String columnId = "_id";
const String columnProject = "project";
const String columnTask = "task";
const String columnDate = "date";
const String columnStart = "start";
const String columnFinish = "finish";
const String columnDuration = "duration";
const String columnComment = "comment";
const String columnRemote = "remote";

class TimeRecordDatabaseOpenHelper {
  Database db;

  Future open(String path) async {
    print("TimeRecordDatabaseOpenHelper: open: $path");
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''create table $tableName ( 
            $columnId integer primary key autoincrement, 
  $columnProject text not null,
  $columnTask text not null,
  $columnDate integer not null,
  $columnStart text not null,
  $columnFinish text,
  $columnDuration text,
  $columnComment text)''');
      print("database: onCreate");
    });
  }


  Future<TimeRecord> insert(TimeRecord timeRecord) async {
    timeRecord.id = await db.insert(tableName, timeRecord.toMap());
    return timeRecord;
  }

  Future<TimeRecord> getTimeRecord(int id) async {
    List<Map> maps = await db.query(tableName,
        columns: [columnId, columnProject, columnTask, columnDate, columnStart, columnFinish, columnDuration, columnComment],
        where: "$columnId = ?",
        whereArgs: [id]);
    if (maps.length > 0) {
      return new TimeRecord.fromMap(maps.first);
    }
    return null;
  }

  Future<TimeReport> getTimeRecordForDate(DateTime date) async {
    if(db == null){
      print("db is null");
    }
    String where = "${date.millisecondsSinceEpoch}";
    print("getTimeRecordForDate: from $where");
    List<Map> maps  = await db.query(tableName,
    columns: [columnId, columnProject, columnTask, columnDate, columnStart, columnFinish, columnDuration, columnComment],
      where: "$columnDate = ?",
      whereArgs: [where]
    );

    List<TimeRecord> records = List<TimeRecord>();
    if(maps.isNotEmpty){
      print("${maps.length} rows");
      maps.forEach((element) =>
       records.add(TimeRecord.fromMap(element)));

      TimeReport report = new TimeReport(timeReport: records);
      return report;
    }
    return null;
  }

  Future<List<TimeRecord>> getRecordsBetweenDates(DateTime startDate, DateTime endDate) async {
    if(db == null){
      print("db is null");
    }

     var where = ["${startDate.millisecondsSinceEpoch}","${endDate.millisecondsSinceEpoch}"];
    print("getTimeRecordForDate: from $where");
    List<Map> maps  = await db.query(tableName,
        columns: [columnId, columnProject, columnTask, columnDate, columnStart, columnFinish, columnDuration, columnComment],
        where: "$columnDate >= ? AND $columnDate <= ?",
        whereArgs: where,
        orderBy: columnDate
    );

    List<TimeRecord> records = List<TimeRecord>();
    if(maps != null && maps.isNotEmpty){
      print("${maps.length} rows");
      maps.forEach((element) =>
          records.add(TimeRecord.fromMap(element)));
    }

    return records;
  }



  Future<int> deleteRecordById(int id) async {
    return await db.delete(tableName, where: "$columnId = ?", whereArgs: [id]);
  }

  Future<int> deleteRecordsForDate(DateTime date) async {
    String whereArg = "${date.day}/${date.month}/${date.year}";
    return await db.delete(tableName, where: "$columnDate = ?", whereArgs: [whereArg]);
  }

  Future close() async {
    db.close();
  }
}
