import 'dart:async';
//import 'package:flutter/widgets.dart';
import 'package:flutter_app/data_log/data_types.dart';
import 'package:flutter_app/authentification/welcome_screen.dart';
import 'package:flutter_app/db_user.dart';
//import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  late Database database;

  String trackTmGVTable = 'tmgv_table';
  String colId = 'id';
  String colDate = 'date';
  String colMonth = 'month';
  String colHour = 'hour';
  String colMinute = 'minute';
  String colGV = 'glucose_val';
  late String dbPath;
  late String dbName;

  DatabaseHelper() {}

  Future<Database> init(String dbName) async {
    //List<UserModel> users = await databaseHelperUser.queryAllRowsUsers();
    //dbName = users.last.email;

    this.dbName = dbName;
    Directory directory = await getApplicationDocumentsDirectory();
    dbPath = directory.path + dbName;
    print('Local database [${dbName}] initialized: ');
    database = await openDatabase(dbPath, version: 1, onCreate: _createDb);
    return database;
  }

  Future<void> deleteDatabase() => databaseFactory.deleteDatabase(dbPath);

  void _createDb(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $trackTmGVTable($colId INTEGER PRIMARY KEY, $colDate TEXT, $colMonth INTEGER, $colHour INTEGER, $colMinute INTEGER, $colGV REAL)');
  }

  Future<List<Map<String, dynamic>>> queryAllRowsMap() async {
    var a = await database.query(trackTmGVTable);
    return a;
  }

  Future<List<Map<String, dynamic>>> selectGV(String text) async {
    return await database
        .rawQuery('SELECT * FROM $trackTmGVTable WHERE $colDate == ?', [text]);
  }

  Future<int> insert(TrackTmGV trackTmGV) async {
    print('insertion: $trackTmGV');
    return await database.insert(trackTmGVTable, trackTmGV.toMap());
  }

  Future<int> updateTmGV(TrackTmGV trackTmGV) async {
    var result = await database.update(trackTmGVTable, trackTmGV.toMap(),
        where: '$colId = ?', whereArgs: [trackTmGV.id]);
    return result;
  }

  Future<int> deleteTmGV(int id) async {
    print('deletion: id$id');
    return await database
        .rawDelete('DELETE FROM $trackTmGVTable WHERE $colId = $id');
  }

  Future<int> queryRowCount() async {
    final results =
        await database.rawQuery('SELECT COUNT(*) FROM $trackTmGVTable');
    return Sqflite.firstIntValue(results) ?? 0;
  }

  Future<List<TrackTmGV>> queryAllRowsGV() async {
    var list = await queryAllRowsMap();
    int count = list.length;

    List<TrackTmGV> allRows = [];
    for (int i = 0; i < count; i++) {
      allRows.add(TrackTmGV.fromMapObject(list[i]));
    }

    print('${allRows.length} rows');
    return allRows;
  }
}
