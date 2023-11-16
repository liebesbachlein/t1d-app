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
  print("done");
}

class MainApp extends StatelessWidget {
  MainApp();

  MainApp._create() {
    print("_create() (private constructor)");

    // Do most of your initialization here, that's what a constructor is for
    //...
  }

  static Future<MainApp> create() async {
    print("create() (public factory)");

    // Call the private constructor
    var component = MainApp._create();

    // Do initialization that requires async
    await databaseHelper.init();

    // Return the fully initialized object
    return component;
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false, home: HomePage());
  }
}
