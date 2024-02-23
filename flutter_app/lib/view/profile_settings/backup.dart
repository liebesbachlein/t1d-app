// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter/services.dart';
import 'package:flutter_app/assets/colors.dart';
import 'package:flutter_app/main.dart';
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
                  Navigator.pop(context);
                });
              }),
          Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width * 0.5,
              child: const Text('Backup & Sync',
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
    String tx = '';
    return Container(
        margin: const EdgeInsets.only(right: 17, left: 17, top: 100),
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
        child: Column(children: [
          ElevatedButton(
              style: ButtonStyle(
                fixedSize: MaterialStatePropertyAll<Size>(
                    Size(MediaQuery.of(context).size.width * 0.85, 60)),
                elevation: const MaterialStatePropertyAll<double>(2),
                shadowColor: const MaterialStatePropertyAll<Color>(
                    Color.fromARGB(179, 233, 221, 233)),
                alignment: AlignmentDirectional.center,
                backgroundColor:
                    const MaterialStatePropertyAll<Color>(AppColors.lavender),
                padding: const MaterialStatePropertyAll<EdgeInsets>(
                    EdgeInsets.all(0)),
                shape: const MaterialStatePropertyAll<OutlinedBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)))),
              ),
              onPressed: () async {
                bool res = await firebaseRemoteHelper.uploadGVdata();

                if (res == true) {
                  setState(() {
                    tx = "Data was successfully sync";
                  });
                } else {
                  setState(() {
                    tx = "Error occured while sync";
                  });
                }
              },
              child: const Text('Backup now',
                  style: TextStyle(
                    fontFamily: 'Inter-Medium',
                    fontSize: 16,
                    color: Colors.white,
                  ))),
          Text(tx,
              style: const TextStyle(
                  fontFamily: 'Inter-Regular',
                  fontSize: 16,
                  color: Colors.black)),
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
              onPressed: () async {
                bool res = await firebaseRemoteHelper.downloadGVdata();

                if (res == true) {
                  setState(() {
                    tx = "Data was successfully backed up";
                  });
                } else {
                  setState(() {
                    tx = "Error occured while backing up";
                  });
                }
              },
              child: const Text('Sync data now',
                  style: TextStyle(
                    fontFamily: 'Inter-Medium',
                    fontSize: 16,
                    color: Colors.white,
                  ))),
          Text(tx,
              style: const TextStyle(
                  fontFamily: 'Inter-Regular',
                  fontSize: 16,
                  color: Colors.black))
        ]));
  }
}
