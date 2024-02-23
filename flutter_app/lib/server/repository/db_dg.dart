// ignore_for_file: avoid_print

import 'dart:async';
import 'package:flutter_app/server/models/DialogModel.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelperDialog {
  late Database database;

  String dialogTable = 'dialog_table';
  String colId = 'id';
  String colFromWho = 'fromWho';
  String colContent = 'content';
  String colCommand = 'command';
  String colDisplayDate = 'displayDate';
  String colFromDate = 'fromDate';
  String colToDate = 'toDate';

  DatabaseHelperDialog();
/*
  Future<Database> init({required String dbName}) async {
    //List<UserModel> users = await databaseHelperUser.queryAllRowsUsers();
    //dbName = users.last.email;

    this.dbName = '$dbName.db';
    print('1');
    Directory directory = await getApplicationDocumentsDirectory();
    print('2');
    dbPath = directory.path + dbName;
    print('Diablog database [$dbName] initialized: ');
    database = await openDatabase(dbPath, version: 1, onCreate: createDb);
    print('3');
    return database;
  }*/

  void setDb(Database db) {
    database = db;
  }

  String createDb() {
    return 'CREATE TABLE $dialogTable($colId TEXT PRIMARY KEY, $colFromWho INTEGER, $colContent TEXT, $colCommand INTEGER, $colDisplayDate INTEGER, $colFromDate INTEGER, $colToDate INTEGER)';
  }

  Future<List<Map<String, dynamic>>> queryAllRowsMap() async {
    return await database.query(dialogTable);
  }

  Future<int> insert(DialogModel message) async {
    print('insertion: $message');
    var d = await database.insert(dialogTable, message.toMap());
    return d;
  }

  Future<int> deleteTmGV(String id) async {
    print('deletion: $id');
    return await database
        .rawDelete('DELETE FROM $dialogTable WHERE $colId = ?', [id]);
  }

  Future<int> queryRowCount() async {
    try {
      final results =
          await database.rawQuery('SELECT COUNT(*) FROM $dialogTable');
      return Sqflite.firstIntValue(results) ?? 0;
    } catch (err) {
      print(err);
      return 0;
    }
  }

  Future<List<DialogModel>> queryAllRowsGV() async {
    var list = await queryAllRowsMap();
    int count = list.length;

    List<DialogModel> allRows = [];
    for (int i = 0; i < count; i++) {
      allRows.add(DialogModel.fromMap(list[i]));
    }

    print('${allRows.length} rows');
    return allRows;
  }
}
