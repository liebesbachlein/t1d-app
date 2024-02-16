import 'package:flutter/material.dart';
import 'package:flutter_app/view/authentification/welcome_screen.dart';
import 'package:flutter_app/assets/colors.dart';
import 'package:flutter_app/server/repository/db_user.dart';
import 'package:flutter_app/server/repository/db_gv.dart';
import 'package:flutter_app/view/home/home_page.dart';
import 'dart:async';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_app/server/controllers/firebaseRemoteHelper.dart';
import 'package:shared_preferences/shared_preferences.dart';

DatabaseHelperGV databaseHelperGV = DatabaseHelperGV();
FirebaseRemoteHelper firebaseRemoteHelper = FirebaseRemoteHelper();

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  checkAuthToken().then((isToken) {
    if (isToken.length == 0) {
      runApp(const MainWelcome());
    } else {
      runApp(MainHome(isToken[0], isToken[1]));
    }
  });
}

class MainWelcome extends StatelessWidget {
  const MainWelcome({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false, home: WelcomeScreen());
  }
}

void mainHome({required String username, required String email}) {
  runApp(MainHome(username, email));
}

Future<List<String>> checkAuthToken() async {
  final prefs = await SharedPreferences.getInstance();
  final authToken = prefs.getInt('authToken');
  if (authToken == null || authToken == 0) {
    return [];
  } else {
    final email = prefs.getString('email');
    final username = prefs.getString('username');
    if (email == null || username == null) {
      return [];
    } else {
      return [username, email];
    }
  }
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
              print('DatabaseGLUVAL initialization: Success');
              return MaterialApp(
                  debugShowCheckedModeBanner: false, home: HomePage());
            }
          }
          return Center(
            child: CircularProgressIndicator(color: AppColors.lavender),
          );
        }, //builder
        future: databaseHelperGV.init(dbName: email));
  }
}
