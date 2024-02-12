import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/main.dart';
//import 'package:flutter/widgets.dart';
import 'package:flutter_app/data_log/data_types.dart';
//import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class UserModel {
  String id = '-1';
  String username = 'null';
  String email = 'null@null.com';

  UserModel(this.id, this.username, this.email);

  Map<String, dynamic> toMap() {
    return {'id': id, 'username': username, 'email': email};
  }

  UserModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    username = map['username'];
    email = map['email'];
  }

  static UserModel fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return UserModel(snapshot['id'], snapshot['username'], snapshot['email']);
  }

  static UserModel fromQuerySnapshot(
      QuerySnapshot<Map<String, dynamic>> snapshot) {
    List<UserModel> list = [];
    snapshot.docs.forEach(
        (doc) => list.add(UserModel(doc['id'], doc['username'], doc['email'])));

    return list.last;
  }
}

class DatabaseHelperUser {
  late Database databaseUser;

  String userTable = 'user_table';
  String colId = 'id';
  String colUsername = 'username';
  String colEmail = 'email';
  late String Path;
  String dbName = 'dataUserLocal.db';

  DatabaseHelperUser();

  Future<Database> init(
      {required String username, required String email}) async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + dbName;
    Path = path;
    databaseUser = await openDatabase(path, version: 1, onCreate: _createDb);
    UserModel user = UserModel(email, username, email);
    databaseUser.insert(userTable, user.toMap());
    return databaseUser;
  }

  Future<void> deleteDatabase() => databaseFactory.deleteDatabase(Path);

  void _createDb(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $userTable($colId TEXT PRIMARY KEY, $colUsername TEXT, $colEmail TEXT)');
  }

  Future<List<Map<String, dynamic>>> queryAllRowsMap() async {
    return await databaseUser.query(userTable);
  }

  Future<List<Map<String, dynamic>>> selectEmail(String text) async {
    return await databaseUser
        .rawQuery('SELECT * FROM $userTable WHERE $colEmail == ?', [text]);
  }

  Future insert(UserModel trackTmGV) async {
    print('insertion: $trackTmGV');
    return await databaseUser.insert(userTable, trackTmGV.toMap());
  }

  Future updateUser(UserModel trackTmGV) async {
    var result = await databaseUser.update(userTable, trackTmGV.toMap(),
        where: '$colId = ?', whereArgs: [trackTmGV.id]);
    return result;
  }

  Future deleteUser(String id) async {
    print('deletion: id $id');
    return await databaseUser
        .rawDelete('DELETE FROM $userTable WHERE $colId = $id');
  }
/*
  Future queryRowCount() async {
    final results =
        await databaseUser.rawQuery('SELECT COUNT(*) FROM $userTable');
    return Sqflite.firstIntValue(results) ?? 0;
  }*/

  Future<List<UserModel>> queryAllRowsUsers() async {
    List<Map<String, dynamic>> list = await queryAllRowsMap();
    print(list);
    int count = list.length;

    List<UserModel> allRows = [];
    for (int i = 0; i < count; i++) {
      allRows.add(UserModel.fromMap(list[i]));
    }

    print('${allRows.length} rows');
    return allRows;
  }
}
