// ignore_for_file: non_constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/assets/colors.dart';
import 'dart:core';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/server/controllers/sharedPreferences.dart';
import 'package:flutter_app/view/profile_settings/profile.dart';

class AccountSetting extends StatefulWidget {
  const AccountSetting({super.key});

  @override
  State<AccountSetting> createState() => _AccountSettingState();
}

class _AccountSettingState extends State<AccountSetting> {
  bool _isChanging = false;
  bool _label = false;

  final _formkey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark, // Android dark???
            statusBarBrightness: Brightness.light, // iOS dark???
          ),
          toolbarHeight: 0,
          elevation: 0,
        ),
        body: Container(
            color: AppColors.background,
            child: Column(children: [TopSet(), SettingsCont()])));
  }

  Widget SettingsCont() {
    return Container(
        margin: const EdgeInsets.only(right: 17, left: 17, top: 100),
        padding: const EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width,
        height: 300,
        decoration: const BoxDecoration(
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
        child: Column(children: [NewUsername(), SignOut()]));
  }

  Widget NewUsername() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(children: [
          Form(
              key: _formkey,
              child: Container(
                  margin: const EdgeInsets.only(bottom: 20, top: 10),
                  height: 55,
                  child: TextFormField(
                      controller: _usernameController,
                      style: const TextStyle(
                          fontFamily: 'Inter-Regular',
                          fontSize: 16,
                          color: AppColors.mint),
                      autocorrect: false,
                      decoration: const InputDecoration(
                          constraints: BoxConstraints(minHeight: 60),
                          hintText: "New username",
                          hintStyle: TextStyle(
                              fontFamily: 'Inter-Regular',
                              fontSize: 16,
                              color: AppColors.lavender_light),
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(5),
                            child: Icon(Icons.flood,
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
                                  color: AppColors.lavender_light)))))),
          ElevatedButton(
              style: ButtonStyle(
                fixedSize: MaterialStatePropertyAll<Size>(
                    Size(MediaQuery.of(context).size.width * 0.85, 60)),
                elevation: const MaterialStatePropertyAll<double>(2),
                shadowColor: const MaterialStatePropertyAll<Color>(
                    Color.fromARGB(179, 233, 221, 233)),
                alignment: AlignmentDirectional.center,
                backgroundColor: _label
                    ? const MaterialStatePropertyAll<Color>(
                        AppColors.mint_light)
                    : const MaterialStatePropertyAll<Color>(AppColors.lavender),
                padding: const MaterialStatePropertyAll<EdgeInsets>(
                    EdgeInsets.all(0)),
                shape: const MaterialStatePropertyAll<OutlinedBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)))),
              ),
              onPressed: () {
                if (_formkey.currentState!.validate()) {
                  _formkey.currentState?.save();
                  _changeUsername();
                }
              },
              child: _isChanging
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(_label ? 'Username changed' : 'Change username',
                      style: const TextStyle(
                        fontFamily: 'Inter-Medium',
                        fontSize: 16,
                        color: Colors.white,
                      )))
        ]));
  }

  Widget SignOut() {
    return ElevatedButton(
        style: ButtonStyle(
          fixedSize: MaterialStatePropertyAll<Size>(
              Size(MediaQuery.of(context).size.width * 0.85, 60)),
          elevation: const MaterialStatePropertyAll<double>(2),
          shadowColor: const MaterialStatePropertyAll<Color>(
              Color.fromARGB(179, 233, 221, 233)),
          alignment: AlignmentDirectional.center,
          backgroundColor:
              const MaterialStatePropertyAll<Color>(AppColors.mint),
          padding:
              const MaterialStatePropertyAll<EdgeInsets>(EdgeInsets.all(0)),
          shape: const MaterialStatePropertyAll<OutlinedBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)))),
        ),
        onPressed: () {
          FirebaseAuth.instance.signOut();
          runApp(const MainWelcome());
          deletePersonalInfo();
        },
        child: const Text('Sign out',
            style: TextStyle(
              fontFamily: 'Inter-Medium',
              fontSize: 16,
              color: Colors.white,
            )));
  }

  Widget TopSet() {
    return Container(
        height: 50,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(24),
              bottomLeft: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
                color: Color.fromRGBO(149, 157, 165, 0.1),
                offset: Offset.zero,
                spreadRadius: 4,
                blurRadius: 10)
          ],
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              color: AppColors.lavender,
              onPressed: () {
                setState(() {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const ProfileSettings();
                  }));
                });
              }),
          Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width * 0.5,
              child: const Text('Account settings',
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Inter-Medium',
                      fontSize: 16))),
          IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              color: AppColors.trans,
              onPressed: () {}),
        ]));
  }

  void _changeUsername() async {
    setState(() {
      _isChanging = true;
    });
    String username = _usernameController.text;
    String email = await getEmail();
    setPersonalInfo(email: email, username: username);
    firebaseRemoteHelper.updateUsername(email: email, username: username);

    setState(() {
      _isChanging = false;
      _label = true;
    });
  }
}
