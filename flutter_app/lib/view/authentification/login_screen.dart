// ignore_for_file: avoid_print, non_constant_identifier_names, unused_local_variable, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/server/controllers/authServices.dart';
import 'package:flutter_app/server/controllers/sharedPreferences.dart';
import 'package:flutter_app/server/models/UserModel.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/assets/colors.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isSignIning = false;

  final _formkey = GlobalKey<FormState>();

  final FirebaseServices _auth = FirebaseServices();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  double offsetForm = 0.52;

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
            alignment: Alignment.topCenter,
            color: AppColors.lavender_light,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Stack(alignment: Alignment.topCenter, children: [
              TopBack(),
              LogTop(),
              Container(
                  //padding: EdgeInsets.only(
                  //  top: MediaQuery.of(context).size.height * 0.2),
                  //alignment: Alignment.topCenter,
                  //color: AppColors.background,
                  alignment: Alignment.bottomCenter,
                  child: LoginForm())
            ])));
  }

  Widget LoginForm() {
    return Container(
        height: MediaQuery.of(context).size.height * offsetForm,
        alignment: Alignment.bottomCenter,
        padding: const EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width * 0.92,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24), topRight: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                  color: Color.fromRGBO(149, 157, 165, 0.1),
                  offset: Offset.zero,
                  spreadRadius: 4,
                  blurRadius: 10)
            ]),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Form(
              key: _formkey,
              child: Column(children: [
                Container(
                    margin: const EdgeInsets.only(bottom: 20, top: 10),
                    height: 55,
                    child: TextFormField(
                        controller: _emailController,
                        style: const TextStyle(
                            fontFamily: 'Inter-Regular',
                            fontSize: 16,
                            color: AppColors.mint),
                        onTap: () {
                          setState(() {
                            offsetForm = 0.75;
                          });
                        },
                        /*onEditingComplete: () {
                          setState(() {
                            offsetForm = 0.52;
                          });
                        },*/
                        autocorrect: false,
                        validator: MultiValidator([
                          RequiredValidator(errorText: 'email?'),
                          EmailValidator(errorText: 'Fix the email'),
                        ]),
                        decoration: const InputDecoration(
                            constraints: BoxConstraints(minHeight: 60),
                            hintText: "Email",
                            hintStyle: TextStyle(
                                fontFamily: 'Inter-Regular',
                                fontSize: 16,
                                color: AppColors.lavender_light),
                            prefixIcon: Padding(
                              padding: EdgeInsets.all(5),
                              child: Icon(Icons.ramen_dining,
                                  color: AppColors.lavender_light),
                            ),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1, color: AppColors.lavender_light)),
                            errorStyle: TextStyle(
                                fontSize: 14, fontFamily: 'Inter-Regular'),
                            border: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1,
                                    color: AppColors.lavender_light))))),
                SizedBox(
                    //margin: EdgeInsets.only(bottom: 5),
                    height: 55,
                    child: TextFormField(
                        controller: _passwordController,
                        style: const TextStyle(
                            fontFamily: 'Inter-Regular',
                            fontSize: 16,
                            color: Colors.black),
                        onTap: () {
                          setState(() {
                            offsetForm = 0.75;
                          });
                        },
                        /*onEditingComplete: () {
                          setState(() {
                            offsetForm = 0.52;
                          });
                        },*/
                        obscuringCharacter: '☭',
                        obscureText: true,
                        validator: MultiValidator([
                          RequiredValidator(errorText: 'password?'),
                          MinLengthValidator(8,
                              errorText: 'minimum 8 characters'),
                          /*PatternValidator(r'(?=.*?[#!@$%^&*-_])',
                              errorText:
                                  'add a special character')*/
                        ]),
                        decoration: const InputDecoration(
                            fillColor: AppColors.lavender,
                            focusColor: AppColors.lavender,
                            hintText: "Password",
                            hintStyle: TextStyle(
                                fontFamily: 'Inter-Regular',
                                fontSize: 16,
                                color: AppColors.lavender_light),
                            prefixIcon: Padding(
                              padding: EdgeInsets.all(5),
                              child: Icon(Icons.castle,
                                  color: AppColors.lavender_light),
                            ),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1, color: AppColors.lavender_light)),
                            errorStyle: TextStyle(
                                fontSize: 14, fontFamily: 'Inter-Regular'),
                            border: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1,
                                    color: AppColors.lavender_light)))))
              ])),
          Align(
              alignment: Alignment.centerRight,
              child: Padding(
                  padding: const EdgeInsets.only(
                      top: 5, bottom: 8, left: 10, right: 10),
                  child: TextButton(
                      onPressed: () {
                        popUpNoSuchFeature("the feature will be here soon");
                      },
                      child: const Text('Forgot password?',
                          style: TextStyle(
                              fontFamily: 'Inter-Regular',
                              fontSize: 12,
                              color: AppColors.text_sub))))),
          ElevatedButton(
              style: ButtonStyle(
                fixedSize: MaterialStatePropertyAll<Size>(
                    Size(MediaQuery.of(context).size.width * 0.85, 60)),
                elevation: const MaterialStatePropertyAll<double>(2),
                shadowColor: const MaterialStatePropertyAll<Color>(
                    Color.fromARGB(179, 233, 221, 233)),
                alignment: AlignmentDirectional.center,
                backgroundColor:
                    const MaterialStatePropertyAll<Color>(AppColors.mint),
                padding: const MaterialStatePropertyAll<EdgeInsets>(
                    EdgeInsets.all(0)),
                shape: const MaterialStatePropertyAll<OutlinedBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)))),
              ),
              onPressed: () {
                if (_formkey.currentState!.validate()) {
                  _formkey.currentState?.save();
                  _signIn();
                }
              },
              child: _isSignIning
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Login',
                      style: TextStyle(
                        fontFamily: 'Inter-Medium',
                        fontSize: 16,
                        color: Colors.white,
                      ))),
          Padding(
              padding: const EdgeInsets.only(top: 40),
              child: TextButton(
                  onPressed: () {
                    _signInWithGoogle();
                  },
                  child: Column(children: [
                    const Text('or login with',
                        style: TextStyle(
                            fontFamily: 'Inter-Regular',
                            fontSize: 12,
                            color: AppColors.text_sub)),
                    Container(
                        width: 40,
                        height: 40,
                        margin: const EdgeInsets.only(top: 12),
                        child: Image.asset('lib/assets/images/google_icon.png'))
                  ])))
        ]));
  }

  void _signIn() async {
    setState(() {
      _isSignIning = true;
    });

    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.signInWithEmailAndPassword(email, password);
    setState(() {
      _isSignIning = false;
    });

    if (user != null) {
      print('User successfully signed in');

      UserModel resUser = await firebaseRemoteHelper.getUsername(email);
      await setPersonalInfo(username: resUser.username, email: email);

      //firebaseRemoteHelper.changeToken(email, Random().nextInt(1000) + 1000);

      mainHome(username: resUser.username, email: email);
    } else {
      popUpNoSuchFeature("Incorrect email/password");
    }
  }

  void _signInWithGoogle() async {
    setState(() {
      _isSignIning = true;
    });
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();

      if (googleSignInAccount != null) {
        setState(() {
          _isSignIning = false;
        });
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
            idToken: googleSignInAuthentication.idToken,
            accessToken: googleSignInAuthentication.accessToken);

        await _firebaseAuth.signInWithCredential(credential);
        String email = googleSignInAccount.email;
        UserModel resUser = await firebaseRemoteHelper.getUsername(email);
        await setPersonalInfo(username: resUser.username, email: email);

        mainHome(username: resUser.username, email: email);
      }
    } catch (e) {
      popUpNoSuchFeature("Error occured");
    }
  }

  Widget LogTop() {
    return Container(
        alignment: Alignment.topLeft,
        //decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        width: MediaQuery.of(context).size.width * 0.92,
        //constraints: BoxConstraints(minHeight: 100),
        height: MediaQuery.of(context).size.height * 0.92,
        padding: const EdgeInsets.only(left: 12),
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.08),
        child: const Text('Login',
            style: TextStyle(
              fontFamily: 'Inter-Medium',
              fontSize: 32,
              color: Colors.white,
            )));
  }

  void popUpNoSuchFeature(String text) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
            contentPadding: const EdgeInsets.all(0),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            content: SizedBox(
                width: 200,
                height: 300,
                child: Column(children: [
                  Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                              width: 20,
                              height: 20,
                              alignment: Alignment.centerRight,
                              child: const Icon(Icons.close,
                                  color: Colors.black)))),
                  Text(text,
                      style: const TextStyle(
                          fontFamily: 'Inter-Regular',
                          fontSize: 16,
                          color: AppColors.mint)),
                  Image.asset('lib/assets/images/ryan_gosling.jpg',
                      width: 170, height: 170)
                ]))));
  }

  Widget TopBack() {
    return Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 12),
        height: 50,
        width: MediaQuery.of(context).size.width,
        child: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            color: Colors.white,
            onPressed: () {
              setState(() {
                Navigator.pop(context);
              });
            }));
  }
}
