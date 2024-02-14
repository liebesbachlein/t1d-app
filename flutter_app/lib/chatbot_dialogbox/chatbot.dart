import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter/services.dart';
import 'package:flutter_app/colors.dart';
import 'package:flutter_app/main.dart';
import 'dart:core';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
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
        body: Stack(children: [ChatbotBox(), TopSet(), ChatbotBottom()]));
  }

  Widget TopSet() {
    return Container(
      height: 70,
      padding: EdgeInsets.only(bottom: 5, top: 5, right: 20, left: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Color.fromRGBO(149, 157, 165, 0.1),
              offset: Offset.zero,
              spreadRadius: 4,
              blurRadius: 10)
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [ChatboxProfile()],
      ),
    );
  }

  Widget ChatboxProfile() {
    return Row(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: AppColors.lavender,
          backgroundImage: AssetImage('lib/assets/images/profile_default1.png'),
        ),
        Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(
              left: 20,
              bottom: 8,
              top: 8,
            ),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Hannibal Lecter',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontFamily: 'Inter-Medium',
                          fontSize: 16,
                          color: Colors.black)),
                  Text('Your AI assistant',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontFamily: 'Inter-Medium',
                          fontSize: 12,
                          color: AppColors.text_sub))
                ]))
      ],
    );
  }

  Widget ChatbotBox() {
    List<List<String>> list = [
      ["What’s my average BG for the past 2 weeks?", "13:21"],
      [
        "8.3 mmol/L. It’s 1.5 mmol/L higher that past 2 week average, and 0.9 mmol/l higher than 2 month average ",
        "13:21"
      ],
      ["What’s my average BG for the past 2 weeks?", "13:21"],
      [
        "8.3 mmol/L. It’s 1.5 mmol/L higher that past 2 week average, and 0.9 mmol/l higher than 2 month average ",
        "13:21"
      ],
      ["What’s my average BG for the past 2 weeks?", "13:21"],
      [
        "8.3 mmol/L. It’s 1.5 mmol/L higher that past 2 week average, and 0.9 mmol/l higher than 2 month average ",
        "13:21"
      ],
      ["What’s my average BG for the past 2 weeks?", "13:21"],
      [
        "8.3 mmol/L. It’s 1.5 mmol/L higher that past 2 week average, and 0.9 mmol/l higher than 2 month average ",
        "13:21"
      ],
      ["What’s my average BG for the past 2 weeks?", "13:21"],
      [
        "8.3 mmol/L. It’s 1.5 mmol/L higher that past 2 week average, and 0.9 mmol/l higher than 2 month average ",
        "13:21"
      ],
      ["What’s my average BG for the past 2 weeks?", "13:21"],
      [
        "8.3 mmol/L. It’s 1.5 mmol/L higher that past 2 week average, and 0.9 mmol/l higher than 2 month average ",
        "13:21"
      ],
      ["What’s my average BG for the past 2 weeks?", "13:21"],
      [
        "8.3 mmol/L. It’s 1.5 mmol/L higher that past 2 week average, and 0.9 mmol/l higher than 2 month average ",
        "13:21"
      ],
      ["What’s my average BG for the past 2 weeks?", "13:21"],
      [
        "8.3 mmol/L. It’s 1.5 mmol/L higher that past 2 week average, and 0.9 mmol/l higher than 2 month average ",
        "13:21"
      ],
    ];

    List<Widget> dialogList = [];
    for (int i = 0; i < 12; i++) {
      if (i % 2 == 0) {
        dialogList.add(UserMessage(list[i][1], list[i][0]));
      } else {
        dialogList.add(AIMessage(list[i][1], list[i][0]));
      }
    }

    return Container(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.height,
        ),
        decoration:
            BoxDecoration(border: Border.all(color: Colors.red, width: 2)),
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(bottom: 90),
        child: ListView(
          semanticChildCount: dialogList.length,
          children: dialogList,
          dragStartBehavior: DragStartBehavior.down,
          reverse: true,
        ));
  }

  Widget ChatbotBottom() {
    return Container(
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.bottomCenter,
        width: MediaQuery.of(context).size.width,
        child: Container(
            height: 80,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(24),
                    topLeft: Radius.circular(24)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Color.fromRGBO(149, 157, 165, 0.1),
                      offset: Offset.zero,
                      spreadRadius: 4,
                      blurRadius: 10)
                ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [ChatbotInput(), ChatbotSend()],
            )));
  }

  Widget ChatbotInput() {
    return Container(
        padding: EdgeInsets.only(left: 20),
        width: MediaQuery.of(context).size.width * 0.8,
        child: Text('Ask me anything... ',
            style: TextStyle(
              fontFamily: 'Inter-Medium',
              fontSize: 15,
              color: AppColors.text_sub,
            )));
  }

  Widget ChatbotSend() {
    return Container(
        width: MediaQuery.of(context).size.width * 0.2,
        child: Icon(Icons.send));
  }

  Widget AIMessage(String time, String text) {
    return Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        alignment: Alignment.centerLeft,
        child: Container(
            padding: EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 5),
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              color: AppColors.text_light,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
            ),
            child: Column(children: [
              Text(text,
                  style: TextStyle(
                    fontFamily: 'Inter-Medium',
                    fontSize: 15,
                    color: AppColors.text_info,
                  )),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(time,
                    style: TextStyle(
                      fontFamily: 'Inter-Medium',
                      fontSize: 12,
                      color: AppColors.text_sub,
                    )),
              )
            ])));
  }

  Widget UserMessage(String time, String text) {
    return Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        alignment: Alignment.centerRight,
        child: Container(
            padding: EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 5),
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              color: AppColors.lavender_light,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20)),
            ),
            child: Column(children: [
              Text(text,
                  style: TextStyle(
                    fontFamily: 'Inter-Medium',
                    fontSize: 15,
                    color: Colors.white,
                  )),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(time,
                    style: TextStyle(
                      fontFamily: 'Inter-Medium',
                      fontSize: 12,
                      color: Colors.white,
                    )),
              )
            ])));
  }
}
