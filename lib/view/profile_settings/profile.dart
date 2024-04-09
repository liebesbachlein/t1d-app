import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/assets/colors.dart';
import 'package:flutter_app/view/home/home_bu.dart';
import 'package:flutter_app/view/profile_settings/account.dart';
import 'dart:core';
import 'package:flutter_app/server/controllers/sharedPreferences.dart';
import 'package:flutter_app/view/profile_settings/assistant.dart';
import 'package:flutter_app/view/profile_settings/backup.dart';

class ProfileSettings extends StatefulWidget {
  const ProfileSettings({super.key});

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  late String username = 'Default';

  @override
  void initState() {
    super.initState();
    initUsername();
  }

  void initUsername() async {
    username = await getUsername();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    initUsername();
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
            child: Column(children: [
              buildTop(),
              buildPersonalInfoBox(),
              buildSettingsBox()
            ])),
        resizeToAvoidBottomInset: true);
  }

  Widget buildTop() {
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const HomePage();
                  }));
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

  Widget buildSettingsBox() {
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
              buildSettingBox('Account'),
              buildSettingBox('Assistant'),
              buildSettingBox('Data logging'),
              buildSettingBox('Backup & sync')
            ]));
  }

  Widget buildSettingBox(String tx) {
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
                        } else if (tx == 'Assistant') {
                          return const AssitantSetting();
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

  Widget buildPersonalInfoBox() {
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
