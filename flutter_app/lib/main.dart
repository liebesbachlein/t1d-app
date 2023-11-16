import 'package:flutter/material.dart';
import 'package:flutter_app/home/home_page.dart';
import 'package:flutter_app/profile_settings/profile.dart';
import 'package:flutter_app/test.dart';
import 'package:flutter_app/data_log/data_log.dart';
import 'dart:async';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var c = await MainApp.create();
  runApp(c);
}

class MainApp extends StatelessWidget {
  MainApp();

  MainApp._create() {}

  static Future<MainApp> create() async {
    var component = MainApp._create();

    await databaseHelper.init();

    return component;
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false, home: HomePage());
  }
}
