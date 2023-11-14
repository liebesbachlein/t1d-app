import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_app/data_log/data_log.dart';
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
  late String Path;

  DatabaseHelper() {}

  Future<void> init() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'gvtm.db';
    Path = path;
    database = await openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future<void> deleteDatabase() => databaseFactory.deleteDatabase(Path);

  void _createDb(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $trackTmGVTable($colId INTEGER PRIMARY KEY, $colDate TEXT, $colMonth INTEGER, $colHour INTEGER, $colMinute INTEGER, $colGV REAL)');
  }

  Future<List<Map<String, dynamic>>> queryAllRowsMap() async {
    var a = await database.query(trackTmGVTable);
    print(a.toString());
    print(a.length.toString());
    return a;
  }

  Future<List<Map<String, dynamic>>> selectGV(String text) async {
    return await database
        .rawQuery('SELECT * FROM $trackTmGVTable WHERE $colDate == ?', [text]);
  }

  Future<int> insert(TrackTmGV trackTmGV) async {
    return await database.insert(trackTmGVTable, trackTmGV.toMap());
  }

  Future<int> updateTmGV(TrackTmGV trackTmGV) async {
    var result = await database.update(trackTmGVTable, trackTmGV.toMap(),
        where: '$colId = ?', whereArgs: [trackTmGV.id]);
    return result;
  }

  Future<int> deleteTmGV(int id) async {
    return await database
        .rawDelete('DELETE FROM $trackTmGVTable WHERE $colId = $id');
    ;
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

    return allRows;
  }
}
