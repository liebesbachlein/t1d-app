import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter/services.dart';
import 'package:flutter_app/colors.dart';
import 'dart:core';

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
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            //statusBarIconBrightness: Brightness.dark, // Android dark???
            //statusBarBrightness: Brightness.light, // iOS dark???
          ),
          toolbarHeight: 0,
          elevation: 0,
        ),
        body: Container(
            color: AppColors.background,
            child: Column(children: [TopSet(), PicName(), SettingsCont()])));
  }
}

class TopSet extends StatefulWidget {
  const TopSet({super.key});
  @override
  State<TopSet> createState() => _TopSetState();
}

class _TopSetState extends State<TopSet> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(24),
                bottomLeft: Radius.circular(24))),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Container(
              child: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  color: AppColors.lavender,
                  onPressed: () {
                    setState(() {
                      Navigator.pop(context);
                    });
                  })),
          Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width * 0.5,
              child: Text('Settings',
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Inter-Medium',
                      fontSize: 16))),
          Container(
              //padding: EdgeInsets.only(left: 8, right: 3),
              child: IconButton(
                  icon: Icon(Icons.arrow_forward_ios),
                  color: AppColors.trans,
                  onPressed: () {})),
        ]));
  }
}

class PicName extends StatefulWidget {
  const PicName({super.key});
  @override
  State<PicName> createState() => _PicNameState();
}

class _PicNameState extends State<PicName> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 11, bottom: 44),
        height: 190,
        child: Center(
            child: Column(children: [
          CircleAvatar(
            radius: 75,
            backgroundColor: AppColors.lavender,
            backgroundImage:
                AssetImage('lib/assets/images/profile_default1.png'),
          ),
          Container(
              margin: EdgeInsets.only(top: 11),
              child: Text('Keanu',
                  style: TextStyle(
                      fontFamily: 'Inter-Medium',
                      fontSize: 16,
                      color: AppColors.lavender)))
        ])));
  }
}

class SettingsCont extends Container {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(right: 17, left: 17),
        padding: EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width,
        height: 260,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(12))),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SettingOne('Account'),
              SettingOne('Display'),
              SettingOne('Data logging'),
              SettingOne('Backup & sync')
            ]));
  }
}

class SettingOne extends StatefulWidget {
  String tx = 'Err';
  SettingOne(String settingStr, {super.key}) {
    tx = settingStr;
  }
  @override
  State<SettingOne> createState() => _SettingOneState(tx);
}

class _SettingOneState extends State<SettingOne> {
  String tx = 'Err';

  _SettingOneState(String settingStr) {
    tx = settingStr;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        //margin: EdgeInsets.only(left: 25, right: 25),
        height: 48,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(
            tx,
            style: TextStyle(
              fontFamily: 'Inter-Regular',
              fontSize: 16,
              color: Colors.black,
            ),
            textAlign: TextAlign.left,
          ),
          Container(
              alignment: Alignment.centerRight,
              child: IconButton(
                  icon: Icon(Icons.arrow_forward_ios),
                  color: AppColors.text_set,
                  onPressed: () {
                    setState(() {
                      Navigator.pop(context);
                    });
                  }))
        ]));
  }
}
