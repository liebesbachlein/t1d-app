import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter/services.dart';
import 'package:flutter_app/colors.dart';
import 'dart:core';

class BackUpSetting extends StatefulWidget {
  const BackUpSetting({super.key});

  @override
  State<BackUpSetting> createState() => _BackUpSettingState();
}

class _BackUpSettingState extends State<BackUpSetting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          systemOverlayStyle: SystemUiOverlayStyle(
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
              child: Text('Backup & Sync',
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

class SettingsCont extends StatefulWidget {
  SettingsCont({super.key});

  @override
  State<SettingsCont> createState() => _SettingsContState();
}

class _SettingsContState extends State<SettingsCont> {
  String tx = '';
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(right: 17, left: 17, top: 100),
        padding: EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width,
        height: 260,
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
        child: Column(children: [
          ElevatedButton(
              style: ButtonStyle(
                fixedSize: MaterialStatePropertyAll<Size>(
                    Size(MediaQuery.of(context).size.width * 0.85, 60)),
                elevation: MaterialStatePropertyAll<double>(2),
                shadowColor: MaterialStatePropertyAll<Color>(
                    Color.fromARGB(179, 233, 221, 233)),
                alignment: AlignmentDirectional.center,
                backgroundColor:
                    MaterialStatePropertyAll<Color>(AppColors.mint),
                padding:
                    MaterialStatePropertyAll<EdgeInsets>(EdgeInsets.all(0)),
                shape: MaterialStatePropertyAll<OutlinedBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)))),
              ),
              onPressed: () {
                setState(() {
                  tx = DateTime.now().toString();
                });
              },
              child: Text('Backup now',
                  style: TextStyle(
                    fontFamily: 'Inter-Medium',
                    fontSize: 16,
                    color: Colors.white,
                  ))),
          Text(tx,
              style: TextStyle(
                  fontFamily: 'Inter-Regular',
                  fontSize: 16,
                  color: Colors.black))
        ]));
  }
}
