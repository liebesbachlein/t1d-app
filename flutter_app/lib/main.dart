import 'package:flutter/material.dart';
import 'package:flutter_app/authentification/welcome_screen.dart';
import 'package:flutter_app/colors.dart';
import 'package:flutter_app/db_user.dart';
import 'package:flutter_app/db.dart';
import 'package:flutter_app/home/home_page.dart';
import 'dart:async';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_app/firebase/firebaseRemoteHelper.dart';

DatabaseHelperUser databaseHelperUser = DatabaseHelperUser();
DatabaseHelper databaseHelper = DatabaseHelper();
FirebaseRemoteHelper firebaseRemoteHelper = FirebaseRemoteHelper();

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MainWelcome());
}

class MainWelcome extends StatelessWidget {
  const MainWelcome({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false, home: WelcomeScreen());
  }
}

void main2({required String username, required String email}) {
  runApp(MainHome(username, email));
}

class MainHome extends StatelessWidget {
  String username;
  String email;

  MainHome(this.username, this.email);

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
                            debugShowCheckedModeBanner: false,
                            home: HomePage());
                      }
                    }
                    return Center(
                      child:
                          CircularProgressIndicator(color: AppColors.lavender),
                    );
                  }, //builder
                  future: databaseHelper.init(email));
            }
          }
          return Center(
            child: CircularProgressIndicator(color: AppColors.lavender),
          );
        }, //builder
        future: databaseHelperUser.init(username: username, email: email));
  }
}

/*
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
*/
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