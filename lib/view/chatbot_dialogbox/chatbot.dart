// ignore_for_file: avoid_print, non_constant_identifier_names, no_leading_underscores_for_local_identifier
import 'package:flutter_app/server/models/TrackGV.dart';
import 'package:flutter_app/server/models/TrackTmGV.dart';
import 'package:flutter_app/view/profile_settings/assistant.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/assets/colors.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/view/chatbot_dialogbox/calendar_chatbot.dart';
import 'dart:core';
import 'package:flutter_app/server/controllers/sharedPreferences.dart';
import 'package:flutter_app/server/models/DialogModel.dart';
import 'package:quiver/time.dart';

final DateTime MORNING_TIME_START = DateTime(2024, 1, 1, 6, 0, 0);
final DateTime MORNING_TIME_END = DateTime(2024, 1, 1, 11, 59, 0);
final DateTime AFTERNOON_TIME_START = DateTime(2024, 1, 1, 12, 0, 0);
final DateTime AFTERNOON_TIME_END = DateTime(2024, 1, 1, 17, 59, 0);
final DateTime EVENING_TIME_START = DateTime(2024, 1, 1, 18, 0, 0);
final DateTime EVENING_TIME_END = DateTime(2024, 1, 1, 23, 59, 0);
final DateTime NIGHT_TIME_START = DateTime(2024, 1, 2, 0, 0, 0);
final DateTime NIGHT_TIME_END = DateTime(2024, 1, 2, 5, 59, 0);

const List<Color> randomColors = [
  Color(0xFFF8B195),
  Color(0xFFF67280),
  Color(0xFFffa800),
  Color(0xFF75e3be),
  Color(0xFF00c3ff),
  Color(0xFF0087ff),
  Color(0xFF4a1fec),
  Color(0xFF8919ed),
  Color(0xFFb517ed),
  Color(0xFFdb1fec),
  Color.fromARGB(255, 187, 0, 255),
  Color.fromARGB(255, 107, 161, 120),
  Color.fromARGB(255, 105, 226, 216),
  Color.fromARGB(255, 98, 156, 154),
];

const List<String> months = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December'
];

late List<DialogModel> listDialog;
final GlobalKey<_ChatbotBoxState> _chatBox = GlobalKey<_ChatbotBoxState>();

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();

  GlobalKey<_ChatbotBoxState> getKey() {
    return _chatBox;
  }
}

class _ChatbotPageState extends State<ChatbotPage> {
  late String username;

  @override
  void initState() {
    super.initState();
    initUsername();
  }

  void initUsername() async {
    username = await getAssistantName();
  }

  void setUsername(String username) {
    this.username = username;
    setState(() {});
  }

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
              return Scaffold(
                  appBar: AppBar(
                    foregroundColor: Colors.white,
                    systemOverlayStyle: const SystemUiOverlayStyle(
                      statusBarColor: Colors.white,
                      statusBarIconBrightness: Brightness.dark,
                      statusBarBrightness: Brightness.light,
                    ),
                    toolbarHeight: 0,
                    elevation: 0,
                  ),
                  body: Stack(children: [
                    ChatbotBox(key: _chatBox),
                    buildTop(),
                    const ChatbotBottom()
                  ]));
            }
          }
          return const Center(
            child: CircularProgressIndicator(color: AppColors.lavender),
          );
        }, //builder
        future: databaseHelperDialog.queryAllRowsGV());
  }

  Widget buildTop() {
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
        child: buildChatboxProfile());
  }

  Widget buildChatboxProfile() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 25,
                backgroundColor: AppColors.lavender,
                backgroundImage:
                    AssetImage('lib/assets/images/profile_default0.png'),
              ),
              Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(
                    left: 20,
                    bottom: 8,
                    top: 8,
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(username,
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                                fontFamily: 'Inter-Medium',
                                fontSize: 16,
                                color: Colors.black)),
                        const Text('Your assistant',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontFamily: 'Inter-Medium',
                                fontSize: 12,
                                color: AppColors.text_sub))
                      ]))
            ],
          ),
          GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AssitantSetting()),
                );
              },
              child: const Icon(
                Icons.set_meal,
                size: 32,
                color: AppColors.mint,
              ))
        ]);
  }
}

class ChatbotBox extends StatefulWidget {
  const ChatbotBox({super.key});

  @override
  State<ChatbotBox> createState() => _ChatbotBoxState();
}

class _ChatbotBoxState extends State<ChatbotBox> {
  List<Widget> widgetListDialog = [];
  double bottomPadding = 60;

  void raiseChatbotBox() {
    setState(() {
      bottomPadding = 260;
    });
  }

  void dropChatbotBox() {
    setState(() {
      bottomPadding = 60;
    });
  }

  _ChatbotBoxState() {
    widgetListDialog = [];
    int currentDate = -1;
    int prevDate = -1;
    DateTime prevDay = DateTime.now();

    for (DialogModel itemDialog in listDialog.reversed) {
      currentDate = itemDialog.displayDate.day;
      if (prevDate != -1 && currentDate != prevDate) {
        widgetListDialog.add(getDayBox(prevDay));
      }
      String time =
          '${itemDialog.displayDate.hour < 10 ? '0${itemDialog.displayDate.hour}' : itemDialog.displayDate.hour}:${itemDialog.displayDate.minute < 10 ? '0${itemDialog.displayDate.minute}' : itemDialog.displayDate.minute}';

      if (itemDialog.fromWho == 0) {
        widgetListDialog.add(buildAIMessage(time, itemDialog.content));
      } else {
        widgetListDialog.add(buildUserMessage(itemDialog));
      }
      prevDate = currentDate;
      prevDay = itemDialog.displayDate;
    }
    widgetListDialog.add(getDayBox(prevDay));
  }

  Widget getDayBox(DateTime date) {
    String toShow = '${date.day} ${months[date.month - 1]}';
    return Container(
        height: 40,
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: FittedBox(
            child: Container(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    border: Border.fromBorderSide(BorderSide(
                        color: Color.fromARGB(255, 237, 235, 247), width: 1))),
                alignment: Alignment.center,
                child: Text(
                    date.month == DateTime.now().month &&
                            date.day == DateTime.now().day &&
                            date.year == DateTime.now().year
                        ? 'Today'
                        : toShow,
                    style: const TextStyle(
                        color: Colors.black,
                        fontFamily: 'Inter-Thin',
                        fontSize: 14)))));
  }

  void buildList() {
    setState(() {
      //    ALTER IT SO THAT IT APPENDS NEW MESSAGE TO widgetListDialog DIRECTLY
      widgetListDialog = [];
      int currentDate = -1;
      int prevDate = -1;
      DateTime prevDay = DateTime.now();

      for (DialogModel itemDialog in listDialog.reversed) {
        currentDate = itemDialog.displayDate.day;
        if (prevDate != -1 && currentDate != prevDate) {
          widgetListDialog.add(getDayBox(prevDay));
        }
        String time =
            '${itemDialog.displayDate.hour < 10 ? '0${itemDialog.displayDate.hour}' : itemDialog.displayDate.hour}:${itemDialog.displayDate.minute < 10 ? '0${itemDialog.displayDate.minute}' : itemDialog.displayDate.minute}';

        if (itemDialog.fromWho == 0) {
          widgetListDialog.add(buildAIMessage(time, itemDialog.content));
        } else {
          widgetListDialog.add(buildUserMessage(itemDialog));
        }
        prevDate = currentDate;
        prevDay = itemDialog.displayDate;
      }
      widgetListDialog.add(getDayBox(prevDay));
    });
  }

  Future<TrackGV> average(DateTime start, DateTime end, int period) async {
    // 0 -> all day, 1 -> morning, 2 -> afternoon, 3 -> evening, 4 -> night,
    List<TrackTmGV> res = await databaseHelperGV.selectPeriod(start, end);
    double gv = 0;
    int count = 0;

    if (res.isEmpty) {
      return TrackGV(-1);
    }

    if (period == 0) {
      for (TrackTmGV element in res) {
        count++;
        gv = gv + element.gluval.GV;
      }

      return TrackGV(gv / count);
    }

    late DateTime periodPick_start;
    late DateTime periodPick_end;
    if (period == 1) {
      periodPick_start = MORNING_TIME_START;
      periodPick_end = MORNING_TIME_END;
    } else if (period == 2) {
      periodPick_start = AFTERNOON_TIME_START;
      periodPick_end = AFTERNOON_TIME_END;
    } else if (period == 3) {
      periodPick_start = EVENING_TIME_START;
      periodPick_end = EVENING_TIME_END;
    } else if (period == 4) {
      periodPick_start = NIGHT_TIME_START;
      periodPick_end = NIGHT_TIME_END;
    }
    for (TrackTmGV element in res) {
      if (element.hour * 60 + element.minute >=
              periodPick_start.hour * 60 + periodPick_start.minute &&
          element.hour * 60 + element.minute <=
              periodPick_end.hour * 60 + periodPick_end.minute) {
        count++;
        gv = gv + element.gluval.GV;
      }
    }

    return gv == 0 ? TrackGV(-1) : TrackGV(gv / count);
  }

  void aiResponce(DateTime start, DateTime end, int period) async {
    TrackGV num = await average(DateTime(start.year, start.month, start.day),
        DateTime(end.year, end.month, end.day, 23, 59, 59), period);
    String text = '';
    if (num.GV == -1) {
      text = 'No data over this period';
    } else {
      text = '${num.GV1}.${num.GV2}';
    }

    DialogModel userMessage =
        DialogModel.createUserCommand(DateTime.now(), period, start, end);
    databaseHelperDialog.insert(userMessage);
    listDialog.add(userMessage);

    DialogModel aiMessage =
        DialogModel.createAICommand(DateTime.now(), text, period);
    databaseHelperDialog.insert(aiMessage);
    listDialog.add(aiMessage);

    buildList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: AppColors.background,
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
        ),
        padding: EdgeInsets.only(bottom: bottomPadding, top: 70),
        child: ListView(
          semanticChildCount: widgetListDialog.length,
          dragStartBehavior: DragStartBehavior.down,
          reverse: true,
          children: widgetListDialog,
        ));
  }

  Widget buildAIMessage(String time, String text) {
    if (text.length > 10) {
      return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          alignment: Alignment.centerLeft,
          child: Container(
              padding: const EdgeInsets.only(
                  top: 10, left: 10, right: 10, bottom: 5),
              constraints: const BoxConstraints(
                maxWidth: 300,
              ),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 179, 186, 192),
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

    double gv = double.parse(text);
    int position = (gv.floor() + (gv * 10 - gv.floor()).floor() * 13) %
        randomColors.length;

    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        alignment: Alignment.centerLeft,
        child: Container(
            padding:
                const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 5),
            constraints: const BoxConstraints(
              maxWidth: 300,
            ),
            decoration: BoxDecoration(
              color: randomColors[position],
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(12),
                  topLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12)),
            ),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text('$text mmol/L',
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

  Widget buildUserMessage(DialogModel itemDialog) {
    List<String> periods = [
      '24 hour',
      'Morning',
      'Afternoon',
      'Evening',
      'Night'
    ];
    const List<Color> colors = [
      Color.fromARGB(255, 248, 242, 195),
      Color.fromARGB(255, 217, 236, 240),
      Color.fromARGB(255, 183, 231, 197),
      Color.fromARGB(255, 212, 181, 235),
      Color.fromARGB(255, 136, 142, 198),
    ];

    const List<Color> textColors = [
      Color.fromARGB(255, 185, 163, 0),
      Color.fromARGB(255, 41, 128, 146),
      Color.fromARGB(255, 21, 141, 57),
      Color.fromARGB(255, 86, 17, 140),
      Color.fromARGB(255, 15, 29, 150),
    ];

    final String time =
        '${itemDialog.displayDate.hour < 10 ? '0${itemDialog.displayDate.hour}' : itemDialog.displayDate.hour}:${itemDialog.displayDate.minute < 10 ? '0${itemDialog.displayDate.minute}' : itemDialog.displayDate.minute}';

    final List<String> start = [
      itemDialog.fromDate.day.toString(),
      months[itemDialog.fromDate.month - 1]
    ];
    final List<String> end = [
      itemDialog.toDate.day.toString(),
      months[itemDialog.toDate.month - 1]
    ];
    if (start[0] == end[0] && end[1] == end[1]) {
      return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          alignment: Alignment.centerRight,
          child: Container(
              padding:
                  const EdgeInsets.only(top: 6, left: 10, right: 10, bottom: 5),
              constraints: BoxConstraints(
                maxWidth: itemDialog.command == 4 ? 250 : 270,
              ),
              decoration: const BoxDecoration(
                color: AppColors.text_light,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(12),
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12)),
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Wrap(crossAxisAlignment: WrapCrossAlignment.end, children: [
                      const Padding(
                          padding: EdgeInsets.symmetric(vertical: 4 + 2),
                          child: Text('Show ',
                              style: TextStyle(
                                fontFamily: 'Inter-Regular',
                                fontSize: 14,
                                color: AppColors.text_mes,
                              ))),
                      FittedBox(
                          child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              margin: const EdgeInsets.only(bottom: 2),
                              decoration: BoxDecoration(
                                  color: colors[itemDialog.command],
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(16))),
                              alignment: Alignment.center,
                              child: Text(periods[itemDialog.command],
                                  style: TextStyle(
                                    fontFamily: 'Inter-Regular',
                                    fontSize: 14,
                                    color: textColors[itemDialog.command],
                                  )))),
                      const Padding(
                          padding: EdgeInsets.symmetric(vertical: 4 + 2),
                          child: Text(' average over ',
                              style: TextStyle(
                                fontFamily: 'Inter-Regular',
                                fontSize: 14,
                                color: AppColors.text_mes,
                              ))),
                      Container(
                          width: 24,
                          padding: const EdgeInsets.only(top: 4),
                          margin: const EdgeInsets.only(bottom: 2 + 2),
                          decoration: const BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(4),
                                  topRight: Radius.circular(4),
                                  bottomLeft: Radius.circular(8),
                                  bottomRight: Radius.circular(8))),
                          alignment: Alignment.bottomCenter,
                          child: Container(
                              width: 24,
                              height: 24,
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(2))),
                              alignment: Alignment.center,
                              child: Text(end[0],
                                  style: const TextStyle(
                                    fontFamily: 'Inter-Regular',
                                    fontSize: 14,
                                    color: AppColors.text_mes,
                                  )))),
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4 + 2),
                          child: Text(' ${end[1]}',
                              style: const TextStyle(
                                fontFamily: 'Inter-Regular',
                                fontSize: 14,
                                color: AppColors.text_mes,
                              ))),
                    ]),
                    Container(
                      alignment: Alignment.bottomRight,
                      child: Text(time,
                          style: const TextStyle(
                            fontFamily: 'Inter-Regular',
                            fontSize: 10,
                            color: AppColors.text_mes,
                          )),
                    )
                  ])));
    }
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        alignment: Alignment.centerRight,
        child: Container(
            padding:
                const EdgeInsets.only(top: 6, left: 10, right: 10, bottom: 5),
            constraints: BoxConstraints(
              maxWidth: itemDialog.command == 4 ? 250 : 270,
            ),
            decoration: const BoxDecoration(
              color: AppColors.text_light,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12),
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12)),
            ),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Wrap(crossAxisAlignment: WrapCrossAlignment.end, children: [
                const Padding(
                    padding: EdgeInsets.symmetric(vertical: 4 + 2),
                    child: Text('Show ',
                        style: TextStyle(
                          fontFamily: 'Inter-Regular',
                          fontSize: 14,
                          color: AppColors.text_mes,
                        ))),
                FittedBox(
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        margin: const EdgeInsets.only(bottom: 2),
                        decoration: BoxDecoration(
                            color: colors[itemDialog.command],
                            borderRadius:
                                const BorderRadius.all(Radius.circular(16))),
                        alignment: Alignment.center,
                        child: Text(periods[itemDialog.command],
                            style: TextStyle(
                              fontFamily: 'Inter-Regular',
                              fontSize: 14,
                              color: textColors[itemDialog.command],
                            )))),
                const Padding(
                    padding: EdgeInsets.symmetric(vertical: 4 + 2),
                    child: Text(' average over ',
                        style: TextStyle(
                          fontFamily: 'Inter-Regular',
                          fontSize: 14,
                          color: AppColors.text_mes,
                        ))),
                Container(
                    width: 24,
                    padding: const EdgeInsets.only(top: 4),
                    margin: const EdgeInsets.only(bottom: 2 + 2),
                    decoration: const BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(4),
                            bottomLeft: Radius.circular(8),
                            bottomRight: Radius.circular(8))),
                    alignment: Alignment.bottomCenter,
                    child: Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(2))),
                        alignment: Alignment.center,
                        child: Text(start[0],
                            style: const TextStyle(
                              fontFamily: 'Inter-Regular',
                              fontSize: 14,
                              color: AppColors.text_mes,
                            )))),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4 + 2),
                    child: Text(' ${start[1]} — ',
                        style: const TextStyle(
                          fontFamily: 'Inter-Regular',
                          fontSize: 14,
                          color: AppColors.text_mes,
                        ))),
                Container(
                    width: 24,
                    padding: const EdgeInsets.only(top: 4),
                    margin: const EdgeInsets.only(bottom: 2 + 2),
                    decoration: const BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(4),
                            bottomLeft: Radius.circular(8),
                            bottomRight: Radius.circular(8))),
                    alignment: Alignment.bottomCenter,
                    child: Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(2))),
                        alignment: Alignment.center,
                        child: Text(end[0],
                            style: const TextStyle(
                              fontFamily: 'Inter-Regular',
                              fontSize: 14,
                              color: AppColors.text_mes,
                            )))),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4 + 2),
                    child: Text(' ${end[1]}',
                        style: const TextStyle(
                          fontFamily: 'Inter-Regular',
                          fontSize: 14,
                          color: AppColors.text_mes,
                        ))),
              ]),
              Container(
                alignment: Alignment.bottomRight,
                child: Text(time,
                    style: const TextStyle(
                      fontFamily: 'Inter-Regular',
                      fontSize: 10,
                      color: AppColors.text_mes,
                    )),
              )
            ])));
  }

  Widget LoadingAI() {
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
            child: LoadingAnimationWidget.staggeredDotsWave(
                color: AppColors.mint, size: 20)));
  }
}

class ChatbotBottom extends StatefulWidget {
  const ChatbotBottom({super.key});

  @override
  State<ChatbotBottom> createState() => _ChatbotBottomState();
}

class _ChatbotBottomState extends State<ChatbotBottom> {
  int command = 0; // 0 -> average, 1 -> max, 2 -> min
  int stage = 0; // 0 -> choosing command, 1 -> choosing time
  int time = 0; // 0 -> 2 weeks, 1 -> 1 month, 2 -> custom
  List<Widget> listGridCommands = [];
  List<Widget> listGridTimes = [];
  bool times = false;
  double gridHeight = 0;

  @override
  void initState() {
    super.initState();
    listGridCommands = [
      buildCommandItem(0),
      buildCommandItem(1),
      buildCommandItem(2),
      buildCommandItem(3),
      buildCommandItem(4)
    ];

    listGridTimes = [
      buildBackToCommands(),
      buildTimeItem(0),
      buildTimeItem(1),
      buildTimeItem(2)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.bottomCenter,
        width: MediaQuery.of(context).size.width,
        child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          buildCommandBox(),
          Container(
              height: gridHeight,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                      top: BorderSide(color: AppColors.mint, width: 0.5))),
              child: Wrap(children: times ? listGridTimes : listGridCommands))
        ]));
  }

  Widget buildCommandBox() {
    return GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
          if (gridHeight > 0) {
            setState(() {
              gridHeight = 0;
            });
            _chatBox.currentState?.dropChatbotBox();
          } else if (gridHeight == 0) {
            setState(() {
              gridHeight = 200;
            });
            _chatBox.currentState?.raiseChatbotBox();
          }
        },
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
            alignment: Alignment.centerRight,
            child: Padding(
                padding: const EdgeInsets.only(right: 5),
                child: gridHeight == 0
                    ? const Icon(Icons.arrow_upward,
                        color: AppColors.mint, size: 35)
                    : const Icon(Icons.arrow_downward,
                        color: AppColors.mint, size: 35))));
  }

  Widget buildCommandItem(int localCommand) {
    String text = '';

    if (localCommand == 0) {
      text = '24H average';
    } else if (localCommand == 1) {
      text = 'Morning average';
    } else if (localCommand == 2) {
      text = 'Afternoon average';
    } else if (localCommand == 3) {
      text = 'Evening average';
    } else {
      text = 'Night average';
    }

    return GestureDetector(
        onTap: () {
          command = localCommand;
          stage = 1;
          setState(() {
            times = true;
          });
        },
        child: Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: const BoxDecoration(
                color: AppColors.text_light,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Text(text,
                style: const TextStyle(
                  fontFamily: 'Inter-Regular',
                  fontSize: 14,
                  color: AppColors.text_info,
                ))));
  }

  Widget buildTimeItem(int localTime) {
    String text = '';
    late DateTime start;
    late DateTime end;
    late bool custom = false;

    if (localTime == 0) {
      text = '2 weeks';
      start = DateTime.now().subtract(const Duration(days: 14));
      end = DateTime.now();
    } else if (localTime == 1) {
      text = '1 month';
      start = DateTime.now().subtract(Duration(
          days: daysInMonth(DateTime.now().year, DateTime.now().month)));
      end = DateTime.now();
    } else {
      custom = true;
      text = 'Select period';
    }

    return GestureDetector(
        onTap: () {
          time = localTime;
          stage = 3;
          if (custom) {
            setState(() {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                firstTap = [];
                secondTap = [];
                directionUp = false;
                return ChatbotCalendar(command);
              }));
            });
          } else {
            _chatBox.currentState?.aiResponce(start, end, command);
          }
        },
        child: Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: const BoxDecoration(
                color: AppColors.text_light,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Text(text,
                style: const TextStyle(
                  fontFamily: 'Inter-Regular',
                  fontSize: 14,
                  color: AppColors.text_info,
                ))));
  }

  Widget buildBackToCommands() {
    return GestureDetector(
        onTap: () {
          stage = 1;
          setState(() {
            times = false;
          });
        },
        child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            padding: const EdgeInsets.symmetric(vertical: 1),
            child: const Icon(Icons.chevron_left,
                color: AppColors.mint, size: 32)));
  }
}
