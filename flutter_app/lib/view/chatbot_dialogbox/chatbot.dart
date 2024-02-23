// ignore_for_file: avoid_print, non_constant_identifier_names, no_leading_underscores_for_local_identifiers

import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter/services.dart';
import 'package:flutter_app/assets/colors.dart';
import 'package:flutter_app/assets/ai_script.dart';
import 'package:flutter_app/main.dart';
import 'dart:core';

import 'package:flutter_app/server/models/DialogModel.dart';

late List<DialogModel> listDialog;

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _messageController = TextEditingController();
  final _chatBox = GlobalKey<_ChatbotBoxState>();

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
              listDialog = snapshot.data ?? [];
              print('Load Dialog Data: Success');
              return Scaffold(
                  appBar: AppBar(
                    foregroundColor: Colors.white,
                    systemOverlayStyle: const SystemUiOverlayStyle(
                      statusBarColor: Colors.white,
                      statusBarIconBrightness:
                          Brightness.dark, // Android dark???
                      statusBarBrightness: Brightness.light, // iOS dark???
                    ),
                    toolbarHeight: 0,
                    elevation: 0,
                  ),
                  body: Stack(children: [
                    ChatbotBox(key: _chatBox),
                    TopSet(),
                    ChatbotBottom()
                  ]));
            }
          }
          return const Center(
            child: CircularProgressIndicator(color: AppColors.lavender),
          );
        }, //builder
        future: databaseHelperDialog.queryAllRowsGV());
  }

  Widget TopSet() {
    return Container(
      height: 70,
      padding: const EdgeInsets.only(bottom: 5, top: 5, right: 20, left: 20),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [ChatboxProfile()],
      ),
    );
  }

  Widget ChatboxProfile() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 25,
          backgroundColor: AppColors.lavender,
          backgroundImage: AssetImage('lib/assets/images/profile_default0.png'),
        ),
        Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(
              left: 20,
              bottom: 8,
              top: 8,
            ),
            child: const Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('John Wick',
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

  Widget ChatbotBottom() {
    return Container(
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.bottomCenter,
        width: MediaQuery.of(context).size.width,
        child: Container(
            height: 60,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(24),
                    topLeft: Radius.circular(24)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Color.fromRGBO(149, 157, 165, 0.1),
                      offset: Offset.zero,
                      blurRadius: 4)
                ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    padding: const EdgeInsets.only(left: 20),
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Form(
                        key: _formkey,
                        child: TextFormField(
                          textAlign: TextAlign.left,
                          controller: _messageController,
                          style: const TextStyle(
                              fontFamily: 'Inter-Regular',
                              fontSize: 14,
                              color: AppColors.text_mes),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Ask anything",
                            hintStyle: TextStyle(
                              fontFamily: 'Inter-Regular',
                              fontSize: 14,
                              color: AppColors.text_sub,
                            ),
                          ),
                        ))),
                Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    padding: const EdgeInsets.only(right: 10),
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                        onTap: () {
                          String message = _messageController.text;
                          if (message != '') {
                            DialogModel newMessage = DialogModel.createUserText(
                                DateTime.now(), message);
                            databaseHelperDialog.insert(newMessage);
                            listDialog.add(newMessage);
                            _chatBox.currentState?.buildList();
                            _chatBox.currentState?.buildAItext();
                            _formkey.currentState?.reset();
                          }
                        },
                        child: const Icon(Icons.cookie_rounded,
                            color: AppColors.mint, size: 35)))
              ],
            )));
  }
}

class ChatbotBox extends StatefulWidget {
  const ChatbotBox({super.key});

  @override
  State<ChatbotBox> createState() => _ChatbotBoxState();
}

class _ChatbotBoxState extends State<ChatbotBox> {
  List<Widget> widgetListDialog = [];

  _ChatbotBoxState() {
    widgetListDialog = [];
    for (DialogModel itemDialog in listDialog.reversed) {
      String time =
          '${itemDialog.displayDate.hour < 10 ? '0${itemDialog.displayDate.hour}' : itemDialog.displayDate.hour}:${itemDialog.displayDate.minute < 10 ? '0${itemDialog.displayDate.minute}' : itemDialog.displayDate.minute}';
      if (itemDialog.fromWho == 0) {
        widgetListDialog.add(AIMessage(time, itemDialog.content));
      } else {
        widgetListDialog.add(UserMessage(time, itemDialog.content));
      }
    }
  }

  void buildList() {
    setState(() {
      //    ALTER IT SO THAT IT APPENDS NEW MESSAGE TO widgetListDialog DIRECTLY
      widgetListDialog = [];
      for (DialogModel itemDialog in listDialog.reversed) {
        String time =
            '${itemDialog.displayDate.hour < 10 ? '0${itemDialog.displayDate.hour}' : itemDialog.displayDate.hour}:${itemDialog.displayDate.minute < 10 ? '0${itemDialog.displayDate.minute}' : itemDialog.displayDate.minute}';
        if (itemDialog.fromWho == 0) {
          widgetListDialog.add(AIMessage(time, itemDialog.content));
        } else {
          widgetListDialog.add(UserMessage(time, itemDialog.content));
        }
      }
    });
  }

  void buildAItext() {
    Random rand = Random();
    Map<String, String> mapResponse =
        aiResponces[rand.nextInt(aiResponces.length)];
    String quote = mapResponse['quote'] ?? '';
    String movie = mapResponse['movie'] ?? '';
    String year = mapResponse['year'] ?? '';
    String text = '$quote\n$movie, $year';
    DialogModel newMessage = DialogModel.createAIText(DateTime.now(), text);
    databaseHelperDialog.insert(newMessage);
    listDialog.add(newMessage);
    buildList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: AppColors.background,
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
        ),
        padding: const EdgeInsets.only(bottom: 60, top: 70),
        child: ListView(
          semanticChildCount: widgetListDialog.length,
          dragStartBehavior: DragStartBehavior.down,
          reverse: true,
          children: widgetListDialog,
        ));
  }

  Widget AIMessage(String time, String text) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        alignment: Alignment.centerLeft,
        child: Container(
            padding:
                const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 5),
            constraints: const BoxConstraints(
              maxWidth: 300,
            ),
            decoration: const BoxDecoration(
              color: AppColors.text_light,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12),
                  topLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12)),
            ),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text(text,
                  style: const TextStyle(
                    fontFamily: 'Inter-Regular',
                    fontSize: 14,
                    color: AppColors.text_mes,
                  )),
              Text(time,
                  style: const TextStyle(
                    fontFamily: 'Inter-Regular',
                    fontSize: 10,
                    color: AppColors.text_mes,
                  )),
            ])));
  }

  Widget UserMessage(String time, String text) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        alignment: Alignment.centerRight,
        child: Container(
            padding:
                const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 5),
            constraints: const BoxConstraints(
              maxWidth: 300,
            ),
            decoration: const BoxDecoration(
              color: AppColors.lavender,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12),
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12)),
            ),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text(text,
                  style: const TextStyle(
                    fontFamily: 'Inter-Regular',
                    fontSize: 14,
                    color: Colors.white,
                  )),
              Text(time,
                  style: const TextStyle(
                    fontFamily: 'Inter-Regular',
                    fontSize: 10,
                    color: Colors.white,
                  )),
            ])));
  }
}
