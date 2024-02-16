import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/assets/colors.dart';
import 'package:flutter_app/server/models/TrackTmGV.dart';
import 'package:flutter_app/main.dart';
import 'dart:core';
import 'package:quiver/time.dart';

class CalendarPage extends StatefulWidget {
  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  int month = DateTime.now().month;
  int year = DateTime.now().year;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            foregroundColor: AppColors.background,
            surfaceTintColor: AppColors.background,
            backgroundColor: AppColors.background,
            systemOverlayStyle: SystemUiOverlayStyle(
              systemNavigationBarColor: AppColors.background,
              systemNavigationBarDividerColor: AppColors.background,
              statusBarColor: AppColors.background,
              statusBarIconBrightness: Brightness.dark, // Android dark???
              statusBarBrightness: Brightness.light, // iOS dark???
            ),
            toolbarHeight: 0,
            elevation: 0),
        body: Container(
            color: AppColors.background,
            child: Column(
              children: [CalendarBox(), Target()],
            )));
  }

  Widget CalendarBox() {
    late List<List<int>> isTicked;
    return FutureBuilder(
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  '${snapshot.error} occurred',
                  style: TextStyle(fontSize: 18),
                ),
              );
            } else if (snapshot.hasData) {
              return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(left: 17, right: 17, top: 37),
                  constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height * 0.45),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
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
                      CaledarMonthChange(),
                      CalendarInterface(month, year, isTicked)
                    ],
                  ));
            }
          }
          return Center(
            child: CircularProgressIndicator(color: AppColors.lavender),
          );
        }, //builder
        future: getTickedDates(month).then((e) => isTicked = e));
  }

  Future<List<List<int>>> getTickedDates(month) async {
    // SETTING YEAR WILL FAIL ON DEC <-> JAN
    List<TrackTmGV> prevList = await databaseHelperGV
        .selectMonth(DateTime(year, month == 1 ? 12 : month - 1, 1));
    print(DateTime(year, month == 1 ? 12 : month - 1, 1).toIso8601String());
    List<TrackTmGV> curList =
        await databaseHelperGV.selectMonth(DateTime(year, month, 1));
    List<TrackTmGV> nextList = await databaseHelperGV
        .selectMonth(DateTime(year, month == 12 ? 1 : month + 1, 1));
    print(DateTime(year, month == 12 ? 1 : month + 1, 1).toIso8601String());
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

    print([prevMonthL, curMonthL, nextMonthL]);
    return [prevMonthL, curMonthL, nextMonthL];
  }

  Widget CalendarInterface(int month, int year, List<List<int>> isTicked) {
    int lastDay = daysInMonth(year, month);
    int lastDayPrevMonth = daysInMonth(year, month == 1 ? 12 : month - 1);
    int firstWeekday = DateTime(year, month, 1).weekday;
    int lastWeekday = DateTime(year, month, lastDay).weekday;
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

    List<List<Map<String, dynamic>>> allMap = [];

    for (int i = 0; i < 6; i++) {
      List<Map<String, dynamic>> listTemp = [];
      for (int j = 0; j < 7; j++) {
        listTemp.add({"date": allDays[i][j], "tick": allTicks[i][j]});
      }
      allMap.add(listTemp);
    }

    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      WeekNames(),
      WeekDays(allMap[0], 1, false, allMap[1][0]["tick"]),
      WeekDays(allMap[1], 2, allMap[0][6]["tick"], allMap[2][0]["tick"]),
      WeekDays(allMap[2], 3, allMap[1][6]["tick"], allMap[3][0]["tick"]),
      WeekDays(allMap[3], 4, allMap[2][6]["tick"], allMap[4][0]["tick"]),
      WeekDays(allMap[4], 5, allMap[3][6]["tick"], allMap[5][0]["tick"]),
      WeekDays(allMap[5], 6, allMap[4][6]["tick"], false)
    ]);
  }

  Widget WeekNames() {
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
        Widget weekName = Container(
            width: 50,
            height: 50,
            //decoration: dec,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(i,
                  style: TextStyle(
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

  Widget WeekDays(
      List<Map<String, dynamic>> monthMap, int weekNum, bool prev, bool next) {
    List<Widget> getWeekDays() {
      List<Widget> list = [];
      double rad = 8;
      for (int idx = 0; idx < monthMap.length; idx++) {
        Color color = Colors.black;
        Color backColor = Colors.white;
        double width = 50;
        double height = 50;
        EdgeInsets margin = EdgeInsets.symmetric(vertical: 0);

        BoxDecoration dec = BoxDecoration(
          borderRadius: BorderRadius.circular(0),
          color: backColor,
        );
        if (weekNum == 1) {
          if (monthMap[idx]["date"] > 20) {
            color = AppColors.text_sub;
          }
        } else if (weekNum == 6 || weekNum == rad) {
          if (monthMap[idx]["date"] < 15) {
            color = AppColors.text_sub;
          }
        }

        if (monthMap[idx]["tick"] == true) {
          backColor = AppColors.mint_light;

          if (idx != 0 && idx != monthMap.length - 1) {
            if (monthMap[idx - 1]["tick"] == false &&
                monthMap[idx + 1]["tick"] == false) {
              width = 40;
              height = 40;
              margin = EdgeInsets.all(rad);
              dec = BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(rad)),
                color: backColor,
              );
            } else if (monthMap[idx - 1]["tick"] == false) {
              width = 45;
              height = 40;
              margin = EdgeInsets.only(top: rad, bottom: rad, left: rad);
              dec = BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(rad),
                  bottomLeft: Radius.circular(rad),
                ),
                color: backColor,
              );
            } else if (monthMap[idx + 1]["tick"] == false) {
              width = 45;
              height = 40;
              margin = EdgeInsets.only(top: rad, bottom: rad, right: rad);
              ;
              dec = BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(rad),
                  bottomRight: Radius.circular(rad),
                ),
                color: backColor,
              );
            } else {
              width = 50;
              height = 40;
              margin = EdgeInsets.symmetric(vertical: rad);
              dec = BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(0)),
                color: backColor,
              );
            }
          } else {
            if (idx == 0) {
              if (prev == true && monthMap[idx + 1]["tick"] == false) {
                width = 45;
                height = 40;
                margin = EdgeInsets.only(top: rad, bottom: rad, right: rad);
                dec = BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(rad),
                    bottomRight: Radius.circular(rad),
                  ),
                  color: backColor,
                );
              } else if (prev == false && monthMap[idx + 1]["tick"] == true) {
                width = 45;
                height = 40;
                margin = EdgeInsets.only(top: rad, bottom: rad, left: rad);
                dec = BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(rad),
                    bottomLeft: Radius.circular(rad),
                  ),
                  color: backColor,
                );
              } else if (prev == false && monthMap[idx + 1]["tick"] == false) {
                width = 40;
                height = 40;
                margin = EdgeInsets.all(rad);
                dec = BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(rad)),
                  color: backColor,
                );
              } else {
                width = 50;
                height = 40;
                margin = EdgeInsets.symmetric(vertical: rad);
                dec = BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(0)),
                  color: backColor,
                );
              }
            } else if (idx == 6) {
              if (next == true && monthMap[idx - 1]["tick"] == false) {
                width = 45;
                height = 40;
                margin = EdgeInsets.only(top: rad, bottom: rad, left: rad);
                dec = BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(rad),
                    bottomLeft: Radius.circular(rad),
                  ),
                  color: backColor,
                );
              } else if (next == false && monthMap[idx - 1]["tick"] == true) {
                width = 45;
                height = 40;
                margin = EdgeInsets.only(top: rad, bottom: rad, right: rad);
                dec = BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(rad),
                    bottomRight: Radius.circular(rad),
                  ),
                  color: backColor,
                );
              } else if (next == false && monthMap[idx - 1]["tick"] == false) {
                width = 40;
                height = 40;
                margin = EdgeInsets.all(rad);
                dec = BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(rad)),
                  color: backColor,
                );
              } else {
                width = 50;
                height = 40;
                margin = EdgeInsets.symmetric(vertical: rad);
                dec = BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(0)),
                  color: backColor,
                );
              }
            }
          }
        }

        Widget weekName = Container(
            width: width,
            height: height,
            margin: margin,
            decoration: dec,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(monthMap[idx]["date"].toString(),
                  style: TextStyle(
                      fontFamily: 'Inter-Regular', fontSize: 12, color: color))
            ]));
        list.add(weekName);
      }
      return list;
    }

    return Row(
        mainAxisAlignment: MainAxisAlignment.center, children: getWeekDays());
  }

  Widget CaledarMonthChange() {
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
        decoration: BoxDecoration(color: Colors.white),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Container(
              child: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  color: Colors.black,
                  onPressed: () {
                    setState(() {
                      year = month == 1 ? year - 1 : year;
                      month = month == 1 ? 12 : month - 1;
                    });
                  })),
          Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width * 0.5,
              child: Text(months[month - 1],
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Inter-Medium',
                      fontSize: 16))),
          Container(
              //padding: EdgeInsets.only(left: 8, right: 3),
              child: IconButton(
                  icon: Icon(Icons.arrow_forward_ios),
                  color: Colors.black,
                  onPressed: () {
                    setState(() {
                      year = month == 12 ? year + 1 : year;
                      month = month == 12 ? 1 : month + 1;
                    });
                  })),
        ]));
  }

  Widget Target() {
    return Container();
  }
}
