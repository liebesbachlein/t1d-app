import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_app/data_log/data_log.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  late Database _database;

  String trackTmGVTable = 'tmgv_table';
  String colId = 'id';
  String colDate = 'date';
  String colMonth = 'month';
  String colHour = 'hour';
  String colMinute = 'minute';
  String colGV = 'glucose_val';

  DatabaseHelper() {}

  Future<Database> get database async {
    if (_database == null) {
      _database = await init();
    }
    return _database;
  }

  Future<Database> init() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'gvtm.db';

    var trackGVTmDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return trackGVTmDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $trackTmGVTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colDate TEXT, '
        '$colMonth INTEGER, $colHour INTEGER), $colMinute INTEGER, $colGV REAL');
  }

  Future<List<Map<String, dynamic>>> gettrackTmGVTableMapList() async {
    Database db = await this.database;

    var result = await db.query(trackTmGVTable,
        orderBy: '$colDate DESC, $colHour DESC, $colMinute DESC,');
    return result;
  }

  Future<int> insertTmGV(TrackTmGV trackTmGV) async {
    Database db = await this.database;
    var result = await db.insert(trackTmGVTable, trackTmGV.toMap());
    return result;
  }

  Future<int> updateTmGV(TrackTmGV trackTmGV) async {
    var db = await this.database;
    var result = await db.update(trackTmGVTable, trackTmGV.toMap(),
        where: '$colId = ?', whereArgs: [trackTmGV.id]);
    return result;
  }

  Future<int> deleteTmGV(int id) async {
    var db = await this.database;
    int result =
        await db.rawDelete('DELETE FROM $trackTmGVTable WHERE $colId = $id');
    return result;
  }

  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $trackTmGVTable');
    int? result = Sqflite.firstIntValue(x);
    if (result != null) {
      return result;
    } else {
      return -1;
    }
  }

  Future<List<TrackTmGV>> getTmGV() async {
    var todoMapList = await gettrackTmGVTableMapList();
    int count = todoMapList.length;

    List<TrackTmGV> todoList = [];
    for (int i = 0; i < count; i++) {
      todoList.add(TrackTmGV.fromMapObject(todoMapList[i]));
    }

    return todoList;
  }
}
