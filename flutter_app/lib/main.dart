import 'package:flutter/material.dart';
import 'package:flutter_app/authentification/welcome_screen.dart';
import 'package:flutter_app/colors.dart';
import 'package:flutter_app/home/home_page.dart';
import 'package:flutter_app/test.dart';
import 'package:flutter_app/data_log/data_log.dart';
import 'dart:async';

late String EMAIL;

void main() {
  runApp(const MainWelcome());
}

class MainWelcome extends StatelessWidget {
  const MainWelcome({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  '${snapshot.error} occurred',
                  style: TextStyle(fontSize: 18),
                ),
              );
            } else if (snapshot.hasData) {
              print('DatabaseUSER initialization: Success');
              return MaterialApp(
                  debugShowCheckedModeBanner: false, home: WelcomeScreen());
            }
          }
          return Center(
            child: CircularProgressIndicator(color: AppColors.lavender),
          );
        },
        future: databaseHelperUser.init());
  }
}

void main2() {
  runApp(const MainHome());
}

class MainHome extends StatelessWidget {
  const MainHome({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  '${snapshot.error} occurred',
                  style: TextStyle(fontSize: 18),
                ),
              );
            } else if (snapshot.hasData) {
              print('DatabaseGLUVAL initialization: Success');
              return MaterialApp(
                  debugShowCheckedModeBanner: false, home: HomePage());
            }
          }
          return Center(
            child: CircularProgressIndicator(color: AppColors.lavender),
          );
        },
        future: databaseHelper.init());
  }
}

/*
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
*/