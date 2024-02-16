import 'dart:async';
import 'package:flutter_app/server/models/TrackTmGV.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:quiver/time.dart';

class DatabaseHelperGV {
  late Database database;

  String trackTmGVTable = 'tmgv_table';
  String colId = 'id';
  String colDateSeconds = 'dateSeconds';
  String colYear = 'year';
  String colMonth = 'month';
  String colDay = 'day';
  String colHour = 'hour';
  String colMinute = 'minute';
  String colGV = 'glucose_val';
  late String dbPath;
  late String dbName;

  DatabaseHelperGV();

  Future<Database> init({required String dbName}) async {
    //List<UserModel> users = await databaseHelperUser.queryAllRowsUsers();
    //dbName = users.last.email;

    this.dbName = '$dbName.db';
    print('1');
    Directory directory = await getApplicationDocumentsDirectory();
    print('2');
    dbPath = directory.path + dbName;
    print('Local database [${dbName}] initialized: ');
    database = await openDatabase(dbPath, version: 1, onCreate: _createDb);
    print('3');
    return database;
  }

  Future<void> deleteDatabase() => databaseFactory.deleteDatabase(dbPath);

  void _createDb(Database db, int version) async {
    print('create database');
    await db.execute(
        'CREATE TABLE $trackTmGVTable($colId TEXT PRIMARY KEY, $colDateSeconds INTEGER, $colYear INTEGER, $colMonth INTEGER, $colDay INTEGER, $colHour INTEGER, $colMinute INTEGER, $colGV REAL)');
  }

  Future<List<Map<String, dynamic>>> queryAllRowsMap() async {
    print('1');
    var a = await database.query(trackTmGVTable);
    return a;
  }

  Future<TrackTmGV?> selectGV(DateTime dateSeconds) async {
    List<Map<String, dynamic>> list = await database.rawQuery(
        'SELECT * FROM $trackTmGVTable WHERE $colDateSeconds == ?',
        [dateSeconds.millisecondsSinceEpoch]);
    if (list.isNotEmpty) {
      return TrackTmGV.fromMap(list.last);
    } else {
      return null;
    }
  }

  Future<List<TrackTmGV>> selectDay(DateTime dateSeconds) async {
    DateTime nowDay =
        DateTime(dateSeconds.year, dateSeconds.month, dateSeconds.day);

    DateTime minusDay = nowDay.subtract(Duration(days: 1));
    DateTime prevDay =
        DateTime(minusDay.year, minusDay.month, minusDay.day, 23, 59, 59);

    DateTime addDay = nowDay.add(Duration(days: 1));
    DateTime nextDay = DateTime(addDay.year, addDay.month, addDay.day, 0, 0, 0);

    List<Map<String, dynamic>> list = await database.rawQuery(
        'SELECT * FROM $trackTmGVTable WHERE $colDateSeconds > ? AND $colDateSeconds < ?',
        [prevDay.millisecondsSinceEpoch, nextDay.millisecondsSinceEpoch]);
    List<TrackTmGV> res = [];
    for (Map<String, dynamic> i in list) {
      res.add(TrackTmGV.fromMap(i));
    }
    return res;
  }

  Future<List<TrackTmGV>> selectMonth(DateTime dateSeconds) async {
    DateTime minusMonth = DateTime(
        dateSeconds.month == 1 ? dateSeconds.year - 1 : dateSeconds.year,
        dateSeconds.month == 1 ? 12 : dateSeconds.month - 1);
    DateTime prevMonth = DateTime(minusMonth.year, minusMonth.month,
        daysInMonth(minusMonth.year, minusMonth.month), 23, 59);

    DateTime addMonth = DateTime(
        dateSeconds.month == 12 ? dateSeconds.year + 1 : dateSeconds.year,
        dateSeconds.month == 12 ? 1 : dateSeconds.month + 1);
    DateTime nextMonth = DateTime(addMonth.year, addMonth.month, 1, 0, 0, 0);

    List<Map<String, dynamic>> list = await database.rawQuery(
        'SELECT * FROM $trackTmGVTable WHERE $colDateSeconds > ? AND $colDateSeconds < ?',
        [prevMonth.millisecondsSinceEpoch, nextMonth.millisecondsSinceEpoch]);
    List<TrackTmGV> res = [];
    for (Map<String, dynamic> i in list) {
      res.add(TrackTmGV.fromMap(i));
    }
    return res;
  }

  Future<int> insert(TrackTmGV trackTmGV) async {
    print('insertion: $trackTmGV');
    print(trackTmGV.toMap());
    var d = await database.insert(trackTmGVTable, trackTmGV.toMap());
    print(trackTmGV.toMap());
    return d;
  }

  Future<int> updateTmGV(TrackTmGV trackTmGV) async {
    return await database.update(trackTmGVTable, trackTmGV.toMap(),
        where: '$colId = ?', whereArgs: [trackTmGV.id]);
  }

  Future<int> deleteTmGV(String id) async {
    print('deletion: $id');
    return await database
        .rawDelete('DELETE FROM $trackTmGVTable WHERE $colId = ?', [id]);
  }

  Future<int> queryRowCount() async {
    try {
      final results =
          await database.rawQuery('SELECT COUNT(*) FROM $trackTmGVTable');
      return Sqflite.firstIntValue(results) ?? 0;
    } catch (err) {
      print(err);
      return 0;
    }
  }

  Future<List<TrackTmGV>> queryAllRowsGV() async {
    var list = await queryAllRowsMap();
    int count = list.length;

    List<TrackTmGV> allRows = [];
    for (int i = 0; i < count; i++) {
      allRows.add(TrackTmGV.fromMap(list[i]));
    }

    print('${allRows.length} rows');
    return allRows;
  }
}
