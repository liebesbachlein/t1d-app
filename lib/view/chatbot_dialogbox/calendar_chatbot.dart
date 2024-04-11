import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/assets/colors.dart';
import 'package:flutter_app/server/models/TrackTmGV.dart';
import 'package:flutter_app/main.dart';
import 'dart:core';
import 'package:quiver/time.dart';
import 'package:flutter_app/view/chatbot_dialogbox/chatbot.dart';

List<int> firstTap = [];
List<int> secondTap = [];
bool directionUp = false;

class ChatbotCalendar extends StatefulWidget {
  final int period;
  const ChatbotCalendar(this.period, {super.key});

  @override
  State<ChatbotCalendar> createState() => _ChatbotCalendarState();
}

class _ChatbotCalendarState extends State<ChatbotCalendar> {
  late int year;
  late int month;
  late int day;
  late int period;

  @override
  void initState() {
    super.initState();
    year = DateTime.now().year;
    month = DateTime.now().month;
    day = DateTime.now().day;
    period = widget.period;
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
            child: Align(
                alignment: Alignment.topCenter,
                child: FittedBox(child: buildCalendarBox()))),
        floatingActionButton: FloatingActionButton(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            backgroundColor: AppColors.mint,
            onPressed: () {
              ChatbotPage chatbot = const ChatbotPage();
              if (firstTap.isEmpty || secondTap.isEmpty) {
                Navigator.pop(context);
              } else {
                DateTime first =
                    DateTime(firstTap[2], firstTap[1], firstTap[0]);
                DateTime second =
                    DateTime(secondTap[2], secondTap[1], secondTap[0]);

                if (first.millisecondsSinceEpoch >=
                    second.millisecondsSinceEpoch) {
                  chatbot
                      .getKey()
                      .currentState
                      ?.aiResponce(second, first, period);
                } else {
                  chatbot
                      .getKey()
                      .currentState
                      ?.aiResponce(first, second, period);
                }
                Navigator.pop(context);
              }
            },
            child: const Icon(Icons.add_task_outlined, color: Colors.white)));
  }

  Widget buildCalendarBox() {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 36),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        constraints:
            BoxConstraints(minHeight: MediaQuery.of(context).size.height * 0.5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
                color: Color.fromRGBO(149, 157, 165, 0.1),
                offset: Offset.zero,
                spreadRadius: 4,
                blurRadius: 10)
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildCaledarMonthChange(),
            buildCalendarInterface(month, year, [[], [], []])
          ],
        ));
  }

  Future<List<List<int>>> getTickedDates(month) async {
    // SETTING YEAR WILL FAIL ON DEC <-> JAN
    List<TrackTmGV> prevList = await databaseHelperGV
        .selectMonth(DateTime(year, month == 1 ? 12 : month - 1, 1));
    List<TrackTmGV> curList =
        await databaseHelperGV.selectMonth(DateTime(year, month, 1));
    List<TrackTmGV> nextList = await databaseHelperGV
        .selectMonth(DateTime(year, month == 12 ? 1 : month + 1, 1));
    Set<int> prevMonth = {};
    Set<int> curMonth = {};
    Set<int> nextMonth = {};
    for (TrackTmGV i in prevList) {
      prevMonth.add(i.day);
    }
    for (TrackTmGV i in curList) {
      curMonth.add(i.day);
    }
    for (TrackTmGV i in nextList) {
      nextMonth.add(i.day);
    }

    List<int> prevMonthL = prevMonth.toList();
    List<int> curMonthL = curMonth.toList();
    List<int> nextMonthL = nextMonth.toList();

    prevMonthL.sort();
    curMonthL.sort();
    nextMonthL.sort();

    return [prevMonthL, curMonthL, nextMonthL];
  }

  Widget buildCalendarInterface(int month, int year, List<List<int>> isTicked) {
    int lastDay = daysInMonth(year, month);
    int lastDayPrevMonth = daysInMonth(year, month == 1 ? 12 : month - 1);
    List<List<int>> allDays = [
      [0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0]
    ];
    List<List<bool>> allTicks = [
      [false, false, false, false, false, false, false],
      [false, false, false, false, false, false, false],
      [false, false, false, false, false, false, false],
      [false, false, false, false, false, false, false],
      [false, false, false, false, false, false, false],
      [false, false, false, false, false, false, false]
    ];

    List<List<bool>> selectedList = [
      [false, false, false, false, false, false, false],
      [false, false, false, false, false, false, false],
      [false, false, false, false, false, false, false],
      [false, false, false, false, false, false, false],
      [false, false, false, false, false, false, false],
      [false, false, false, false, false, false, false]
    ];

    int dayTemp = 1;
    for (int i = 0; i < 6; i++) {
      for (int j = 0; j < 7; j++) {
        int pos = DateTime(year, month, dayTemp).weekday;
        if (isTicked[1].contains(dayTemp)) {
          allTicks[i][pos - 1] = true;
        }
        allDays[i][pos - 1] = dayTemp;

        dayTemp++;
        if (dayTemp > lastDay) {
          break;
        }
        if (pos == 7) {
          break;
        }
      }
      if (dayTemp > lastDay) {
        break;
      }
    }

    dayTemp = lastDayPrevMonth;
    if (allDays[0][0] == 0) {
      for (int i = 6; i >= 0; i--) {
        if (allDays[0][i] == 0) {
          if (isTicked[0].contains(dayTemp)) {
            allTicks[0][i] = true;
          }
          allDays[0][i] = dayTemp;
          dayTemp--;
        }
      }
    }

    if (allDays[4][6] == 0) {
      dayTemp = 1;
      for (int i = 0; i < 7; i++) {
        if (allDays[4][i] == 0) {
          if (isTicked[2].contains(dayTemp)) {
            allTicks[4][i] = true;
          }
          allDays[4][i] = dayTemp;
          dayTemp++;
        }
      }

      for (int i = 0; i < 7; i++) {
        if (allDays[5][i] == 0) {
          if (isTicked[2].contains(dayTemp)) {
            allTicks[5][i] = true;
          }
          allDays[5][i] = dayTemp;
          dayTemp++;
        }
      }
    } else if (allDays[4][6] != 0 && allDays[5][6] == 0) {
      dayTemp = 1;
      for (int i = 0; i < 7; i++) {
        if (allDays[5][i] == 0) {
          if (isTicked[2].contains(dayTemp)) {
            allTicks[5][i] = true;
          }
          allDays[5][i] = dayTemp;
          dayTemp++;
        }
      }
    }
    for (int i = 0; i < 6; i++) {
      for (int j = 0; j < 7; j++) {
        int newMonth = month;
        if (allDays[i][j] >= 20 && i <= 1) {
          // strip of previous month
          newMonth = month == 1 ? 12 : month - 1;
        } else if (allDays[i][j] <= 15 && i >= 4) {
          // strip of next month
          newMonth = month == 12 ? 1 : month + 1;
        }

        if (firstTap.isNotEmpty && secondTap.isEmpty) {
          if (year == firstTap[2] &&
              newMonth == firstTap[1] &&
              allDays[i][j] == firstTap[0]) {
            selectedList[i][j] = true;
          }
        } else if (firstTap.isNotEmpty && secondTap.isNotEmpty) {
          if (directionUp) {
            if (DateTime(year, newMonth, allDays[i][j])
                        .millisecondsSinceEpoch <=
                    DateTime(firstTap[2], firstTap[1], firstTap[0])
                        .millisecondsSinceEpoch &&
                DateTime(year, newMonth, allDays[i][j])
                        .millisecondsSinceEpoch >=
                    DateTime(secondTap[2], secondTap[1], secondTap[0])
                        .millisecondsSinceEpoch) {
              selectedList[i][j] = true;
            }
          } else {
            if (DateTime(year, newMonth, allDays[i][j])
                        .millisecondsSinceEpoch >=
                    DateTime(firstTap[2], firstTap[1], firstTap[0])
                        .millisecondsSinceEpoch &&
                DateTime(year, newMonth, allDays[i][j])
                        .millisecondsSinceEpoch <=
                    DateTime(secondTap[2], secondTap[1], secondTap[0])
                        .millisecondsSinceEpoch) {
              selectedList[i][j] = true;
            }
          }
        }
      }
    }

    List<List<Map<String, dynamic>>> allMap = [];

    for (int i = 0; i < 6; i++) {
      List<Map<String, dynamic>> listTemp = [];
      for (int j = 0; j < 7; j++) {
        listTemp.add({
          "date": allDays[i][j],
          "tick": allTicks[i][j],
          "selected": selectedList[i][j]
        });
      }
      allMap.add(listTemp);
    }

    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      buildWeekNames(),
      buildWeekDays(allMap[0], 1),
      buildWeekDays(allMap[1], 2),
      buildWeekDays(allMap[2], 3),
      buildWeekDays(allMap[3], 4),
      buildWeekDays(allMap[4], 5),
      buildWeekDays(allMap[5], 6)
    ]);
  }

  Widget buildWeekNames() {
    List<Widget> getWeekNames() {
      List<String> weekNames = [
        'Mon',
        'Tue',
        'Wed',
        'Thu',
        'Fri',
        'Sat',
        'Sun'
      ];
      List<Widget> list = [];
      for (String i in weekNames) {
        Widget weekName = SizedBox(
            width: 50,
            height: 50,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(i,
                  style: const TextStyle(
                      fontFamily: 'Inter-Regular',
                      fontSize: 12,
                      color: Colors.black))
            ]));
        list.add(weekName);
      }
      return list;
    }

    return Row(
        mainAxisAlignment: MainAxisAlignment.center, children: getWeekNames());
  }

  Widget buildWeekDays(List<Map<String, dynamic>> weekMap, int weekNum) {
    List<Widget> getWeekDays() {
      List<Widget> list = [];
      bool isPrevMonth = false;
      bool isNextMonth = false;
      for (int idx = 0; idx < weekMap.length; idx++) {
        Color color = Colors.black;

        if (weekNum == 1) {
          if (weekMap[idx]["date"] > 20) {
            isPrevMonth = true;
            color = AppColors.text_sub;
          }
        } else if (weekNum == 6) {
          isNextMonth = true;
          if (weekMap[idx]["date"] < 15) {
            color = AppColors.text_sub;
          }
        }

        TextStyle textStyle =
            TextStyle(fontFamily: 'Inter-Regular', fontSize: 12, color: color);

        if (weekMap[idx]["tick"] == true) {
          textStyle = TextStyle(
              fontFamily: 'Inter-Regular',
              fontSize: 12,
              color: color,
              decoration: TextDecoration.underline);
        }

        if (weekMap[idx]["selected"] == true) {
          textStyle = const TextStyle(
              fontFamily: 'Inter-Regular',
              fontSize: 12,
              color: AppColors.lavender,
              decoration: TextDecoration.underline);
        }

        Widget weekName = GestureDetector(
            onTap: () {
              int newMonth = month;
              int newYear = year;
              if (isPrevMonth) {
                newMonth = month == 1 ? 12 : month - 1;
                newYear = month == 1 ? year - 1 : year;
              } else if (isNextMonth) {
                newMonth = month == 12 ? 1 : month + 1;
                newYear = month == 12 ? year + 1 : year;
              }

              if (firstTap.isEmpty && secondTap.isEmpty) {
                setState(() {
                  firstTap = [weekMap[idx]["date"], newMonth, newYear];
                });
              } else if (secondTap.isEmpty) {
                setState(() {
                  secondTap = [weekMap[idx]["date"], newMonth, newYear];
                  if (DateTime(firstTap[2], firstTap[1], firstTap[0])
                          .millisecondsSinceEpoch >=
                      DateTime(secondTap[2], secondTap[1], secondTap[0])
                          .millisecondsSinceEpoch) {
                    directionUp = true;
                  } else {
                    directionUp = false;
                  }
                });
              } else {
                setState(() {
                  firstTap = [];
                  secondTap = [];
                });
              }
            },
            child: Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(weekMap[idx]["date"].toString(), style: textStyle)
                    ])));
        list.add(weekName);
      }
      return list;
    }

    return Row(
        mainAxisAlignment: MainAxisAlignment.center, children: getWeekDays());
  }

  Widget buildCaledarMonthChange() {
    List<String> months = [
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
      'Novermber',
      'December'
    ];

    return Container(
        height: 50,
        decoration: const BoxDecoration(color: Colors.white),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              color: Colors.black,
              onPressed: () {
                setState(() {
                  year = month == 1 ? year - 1 : year;
                  month = month == 1 ? 12 : month - 1;
                });
              }),
          Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width * 0.5,
              child: Text(months[month - 1],
                  style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'Inter-Medium',
                      fontSize: 16))),
          IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              color: Colors.black,
              onPressed: () {
                setState(() {
                  year = month == 12 ? year + 1 : year;
                  month = month == 12 ? 1 : month + 1;
                });
              }),
        ]));
  }
}
