import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/Login/login_screen.dart';
import 'package:flutter_app/Login/signup_screen.dart';
import 'package:flutter_app/colors.dart';
import 'package:flutter_app/db_user.dart';

DatabaseHelperUser databaseHelperUser = DatabaseHelperUser();

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: AppColors.background,
            statusBarIconBrightness: Brightness.dark, // Android dark???
            statusBarBrightness: Brightness.light, // iOS dark???
          ),
          toolbarHeight: 0,
          elevation: 0,
        ),
        body: Container(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.25),
            alignment: Alignment.topCenter,
            color: AppColors.background,
            child: Column(children: [WelcomeTop(), LoginSignup()])));
  }
}

class WelcomeTop extends StatelessWidget {
  const WelcomeTop({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 30),
        child: Text("Welcome",
            style: TextStyle(
              fontFamily: 'Inter-Regular',
              fontSize: 24,
              color: AppColors.text_set,
            )));
  }
}

class LoginSignup extends StatelessWidget {
  const LoginSignup({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(12)),
          boxShadow: [
            BoxShadow(
                color: Color.fromRGBO(149, 157, 165, 0.1),
                offset: Offset.zero,
                spreadRadius: 4,
                blurRadius: 10)
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Hero(
                tag: "login_btn",
                child: ElevatedButton(
                    style: ButtonStyle(
                      elevation: MaterialStatePropertyAll<double>(8),
                      shadowColor: MaterialStatePropertyAll<Color>(
                          Color.fromRGBO(149, 157, 165, 0.2)),
                      alignment: AlignmentDirectional.center,
                      backgroundColor:
                          MaterialStatePropertyAll<Color>(AppColors.mint),
                      padding: MaterialStatePropertyAll<EdgeInsets>(
                          EdgeInsets.all(0)),
                      shape: MaterialStatePropertyAll<OutlinedBorder>(
                          RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)))),
                    ),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return LoginScreen();
                      }));
                    },
                    child: Container(
                        width: 150,
                        height: 50,
                        alignment: Alignment.center,
                        child: Text('Login',
                            style: TextStyle(
                              fontFamily: 'Inter-Regular',
                              fontSize: 16,
                              color: Colors.white,
                            ))))),
            ElevatedButton(
                style: ButtonStyle(
                  elevation: MaterialStatePropertyAll<double>(8),
                  shadowColor: MaterialStatePropertyAll<Color>(
                      Color.fromRGBO(149, 157, 165, 0.2)),
                  alignment: AlignmentDirectional.center,
                  backgroundColor:
                      MaterialStatePropertyAll<Color>(AppColors.lavender),
                  padding:
                      MaterialStatePropertyAll<EdgeInsets>(EdgeInsets.all(0)),
                  shape: MaterialStatePropertyAll<OutlinedBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)))),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return SignUpScreen();
                      },
                    ),
                  );
                },
                child: Container(
                    width: 150,
                    height: 50,
                    alignment: Alignment.center,
                    child: Text('Sign up',
                        style: TextStyle(
                          fontFamily: 'Inter-Regular',
                          fontSize: 16,
                          color: Colors.white,
                        )))),
          ],
        ));
  }
}
