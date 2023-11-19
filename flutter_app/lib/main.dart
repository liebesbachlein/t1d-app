import 'package:flutter/material.dart';
import 'package:flutter_app/authentification/welcome_screen.dart';
import 'package:flutter_app/home/home_page.dart';
import 'package:flutter_app/test.dart';
import 'package:flutter_app/data_log/data_log.dart';
import 'dart:async';

late String EMAIL;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var c = await MainWelcome.create();
  runApp(c);
}

class MainWelcome extends StatelessWidget {
  MainWelcome();
  MainWelcome._create() {}
  static Future<MainWelcome> create() async {
    var component = MainWelcome._create();
    await databaseHelperUser.init();
    return component;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false, home: WelcomeScreen());
  }
}

void main2() async {
  WidgetsFlutterBinding.ensureInitialized();
  var c = await MainHome.create();
  runApp(c);
}

class MainHome extends StatelessWidget {
  MainHome();
  MainHome._create() {}
  static Future<MainHome> create() async {
    var component = MainHome._create();
    await databaseHelper.init();
    return component;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomePage());
  }
}
