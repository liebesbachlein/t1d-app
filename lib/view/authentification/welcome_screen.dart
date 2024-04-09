// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/view/authentification/login_screen.dart';
import 'package:flutter_app/view/authentification/signup_screen.dart';
import 'package:flutter_app/assets/colors.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          foregroundColor: AppColors.lavender_light,
          backgroundColor: AppColors.lavender_light,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: AppColors.lavender_light,
            statusBarIconBrightness: Brightness.dark, // Android dark???
            statusBarBrightness: Brightness.light, // iOS dark???
          ),
          toolbarHeight: 0,
          elevation: 0,
        ),
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              color: AppColors.lavender_light,
            ),
            //border: Border.all(color: Colors.black)),
            alignment: Alignment.topCenter,
            child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [WelcomeTop(context), LoginSignup(context)])));
  }

  Widget WelcomeTop(BuildContext context) {
    return Container(
        alignment: Alignment.topLeft,
        //decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        width: MediaQuery.of(context).size.width * 0.92,
        height: MediaQuery.of(context).size.height * 0.58,
        padding: const EdgeInsets.only(left: 12),
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.08),
        child: const Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Welcome',
                  style: TextStyle(
                      fontFamily: 'Inter-Medium',
                      fontSize: 32,
                      color: Colors.white)),
              Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Diabetes T1',
                        style: TextStyle(
                            fontFamily: 'Inter-Regular',
                            fontSize: 24,
                            color: AppColors.text_dark)),
                    Text('Senior Project',
                        style: TextStyle(
                            fontFamily: 'Inter-Regular',
                            fontSize: 16,
                            color: AppColors.text_info))
                  ])
            ]));
  }

  Widget LoginSignup(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width * 0.92,
        height: MediaQuery.of(context).size.height * 0.24,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
                style: ButtonStyle(
                  fixedSize: MaterialStatePropertyAll<Size>(
                      Size(MediaQuery.of(context).size.width * 0.85, 60)),
                  elevation: const MaterialStatePropertyAll<double>(2),
                  shadowColor: const MaterialStatePropertyAll<Color>(
                      Color.fromARGB(179, 233, 221, 233)),
                  alignment: AlignmentDirectional.center,
                  backgroundColor:
                      const MaterialStatePropertyAll<Color>(Colors.white),
                  padding: const MaterialStatePropertyAll<EdgeInsets>(
                      EdgeInsets.all(0)),
                  shape: const MaterialStatePropertyAll<OutlinedBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)))),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                },
                child: const Text('Login',
                    style: TextStyle(
                      fontFamily: 'Inter-Medium',
                      fontSize: 16,
                      color: AppColors.lavender_light_dark,
                    ))),
            ElevatedButton(
                style: ButtonStyle(
                  fixedSize: MaterialStatePropertyAll<Size>(
                      Size(MediaQuery.of(context).size.width * 0.85, 60)),
                  elevation: const MaterialStatePropertyAll<double>(2),
                  shadowColor:
                      const MaterialStatePropertyAll<Color>(Color(0xFFFFFFFF)),
                  alignment: AlignmentDirectional.center,
                  backgroundColor: const MaterialStatePropertyAll<Color>(
                      AppColors.lavender_light),
                  side: const MaterialStatePropertyAll<BorderSide>(
                      BorderSide(color: Colors.white, width: 1)),
                  padding: const MaterialStatePropertyAll<EdgeInsets>(
                      EdgeInsets.all(0)),
                  shape: const MaterialStatePropertyAll<OutlinedBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)))),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const SignUpScreen();
                      },
                    ),
                  );
                },
                child: const Text('Sign up',
                    style: TextStyle(
                      fontFamily: 'Inter-Medium',
                      fontSize: 16,
                      color: Colors.white,
                    ))),
          ],
        ));
  }
}
