import 'dart:async';

//import 'package:flutter/widgets.dart';
import 'package:flutter_app/data_log/data_types.dart';
//import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class UserModel {
  int id = -1;
  String name = '';
  String email = '';
  String password = '';

  UserModel(this.id, this.name, this.email, this.password);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'name': name,
      'email': email,
      'password': password
    };
    return map;
  }

  UserModel.fromMap(Map<String, dynamic> map) {
    id = map['user_id'];
    name = map['name'];
    email = map['email'];
    password = map['password'];
  }
}

class DatabaseHelperUser {
  late Database database;

  String userTable = 'user_table';
  String colId = 'user_id';
  String colName = 'name';
  String colEmail = 'email';
  String colPassword = 'password';
  late String Path;
  String dbName = 'dataUsers.db';

  DatabaseHelperUser();

  Future<Database> init() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + dbName;
    Path = path;
    database = await openDatabase(path, version: 1, onCreate: _createDb);
    return database;
  }

  Future<void> deleteDatabase() => databaseFactory.deleteDatabase(Path);

  void _createDb(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $userTable($colId INTEGER PRIMARY KEY, $colName TEXT, $colEmail TEXT, $colPassword TEXT)');
  }

  Future<List<Map<String, dynamic>>> queryAllRowsMap() async {
    var a = await database.query(userTable);
    return a;
  }

  Future<List<Map<String, dynamic>>> selectEmail(String text) async {
    return await database
        .rawQuery('SELECT * FROM $userTable WHERE $colEmail == ?', [text]);
  }

  Future<int> insert(UserModel trackTmGV) async {
    print('insertion: $trackTmGV');
    return await database.insert(userTable, trackTmGV.toMap());
  }

  Future<int> updateUser(UserModel trackTmGV) async {
    var result = await database.update(userTable, trackTmGV.toMap(),
        where: '$colId = ?', whereArgs: [trackTmGV.id]);
    return result;
  }

  Future<int> deleteUser(int id) async {
    print('deletion: id$id');
    return await database
        .rawDelete('DELETE FROM $userTable WHERE $colId = $id');
    ;
  }

  Future<int> queryRowCount() async {
    final results = await database.rawQuery('SELECT COUNT(*) FROM $userTable');
    return Sqflite.firstIntValue(results) ?? 0;
  }

  Future<List<UserModel>> queryAllRowsUsers() async {
    var list = await queryAllRowsMap();
    int count = list.length;

    List<UserModel> allRows = [];
    for (int i = 0; i < count; i++) {
      allRows.add(UserModel.fromMap(list[i]));
    }

    print('${allRows.length} rows');
    return allRows;
  }
}
