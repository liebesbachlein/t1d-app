// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/assets/colors.dart';
import 'package:flutter_app/view/profile_settings/account.dart';
import 'dart:core';
import 'package:flutter_app/server/controllers/sharedPreferences.dart';

import 'package:flutter_app/view/profile_settings/backup.dart';

class ProfileSettings extends StatefulWidget {
  const ProfileSettings({super.key});

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
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
            child:
                Column(children: [TopSet(), const PicName(), SettingsCont()])));
  }

  Widget TopSet() {
    return Container(
        height: 50,
        decoration: const BoxDecoration(
          color: Colors.white,
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
                  Navigator.pop(context);
                });
              }),
          Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width * 0.5,
              child: const Text('Settings',
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

  Widget SettingsCont() {
    return Container(
        margin: const EdgeInsets.only(right: 17, left: 17),
        padding: const EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width,
        height: 260,
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
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SettingOne('Account'),
              SettingOne('Display'),
              SettingOne('Data logging'),
              SettingOne('Backup & sync')
            ]));
  }

  Widget SettingOne(String tx) {
    return SizedBox(
        //margin: EdgeInsets.only(left: 25, right: 25),
        height: 48,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(
            tx,
            style: const TextStyle(
              fontFamily: 'Inter-Regular',
              fontSize: 16,
              color: Colors.black,
            ),
            textAlign: TextAlign.left,
          ),
          Container(
              alignment: Alignment.centerRight,
              child: IconButton(
                  icon: const Icon(Icons.arrow_forward_ios),
                  color: AppColors.text_set,
                  onPressed: () {
                    setState(() {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        if (tx == 'Account') {
                          return const AccountSetting();
                        } else if (tx == 'Display') {
                          return const BackUpSetting();
                        } else if (tx == 'Data logging') {
                          return const BackUpSetting();
                        } else {
                          return const BackUpSetting();
                        }
                      }));
                    });
                  }))
        ]));
  }
}

class PicName extends StatefulWidget {
  const PicName({super.key});
  @override
  State<PicName> createState() => _PicNameState();
}

class _PicNameState extends State<PicName> {
  late String username;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  '${snapshot.error} occurred',
                  style: const TextStyle(fontSize: 18),
                ),
              );
            } else if (snapshot.hasData) {
              return Container(
                  margin: const EdgeInsets.only(top: 11, bottom: 44),
                  height: 190,
                  child: Center(
                      child: Column(children: [
                    const CircleAvatar(
                      radius: 75,
                      backgroundColor: AppColors.lavender,
                      backgroundImage:
                          AssetImage('lib/assets/images/profile_default1.png'),
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 11),
                        child: Text(username,
                            style: const TextStyle(
                                fontFamily: 'Inter-Medium',
                                fontSize: 16,
                                color: AppColors.lavender)))
                  ])));
            }
          }
          return const Center(
            child: CircularProgressIndicator(color: AppColors.lavender),
          );
        },
        future: getUsername().then((e) => username = e));
  }
}
