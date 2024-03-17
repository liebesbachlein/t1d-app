// ignore_for_file: non_constant_identifier_names, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/server/models/TrackTmGV.dart';
import 'package:flutter_app/view/calendar/calendar.dart';
import 'package:flutter_app/view/chatbot_dialogbox/calendar_chatbot.dart';
import 'package:flutter_app/view/chatbot_dialogbox/chatbot.dart';
import 'package:flutter_app/assets/colors.dart';
import 'dart:core';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/view/data_log/data_logging.dart';
import 'package:flutter_app/view/profile_settings/profile.dart';
import 'dart:math';
import 'package:infinite_listview/infinite_listview.dart';

const List<String> weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
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

DateTime pointTo =
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<double> listY;

  int currentPageIndex = 0;
  String dateString = 'Today';
  int _g_pos = 0;
  //bool _isThereInfo = false;

  _HomePageState() {
    //set Date Text at the top
    if (_g_pos != 0) {
      DateTime thisDate = DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .add(Duration(days: _g_pos));
      dateString =
          '${weekdays[thisDate.weekday - 1]} ${thisDate.day} ${months[thisDate.month - 1]}';
    } else {
      dateString = 'Today';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //resizeToAvoidBottomInset: false,
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
        bottomNavigationBar: SizedBox(
            height: 60,
            /*decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  color: Color.fromRGBO(149, 157, 165, 0.1),
                  offset: Offset.zero,
                  spreadRadius: 4,
                  blurRadius: 10)
            ]),*/
            child: BottomNavigationBar(
              onTap: (int index) {
                setState(() {
                  currentPageIndex = index;
                });
              },
              iconSize: 25,
              backgroundColor: Colors.white,
              selectedItemColor: AppColors.lavender,
              unselectedItemColor: Colors.black,
              currentIndex: currentPageIndex,
              showSelectedLabels: false,
              selectedFontSize: 0.0,
              unselectedFontSize: 0.0,
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.access_time_outlined),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.add_circle_outline),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.recent_actors_outlined),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.area_chart_outlined),
                  label: '',
                ),
              ],
            )),
        body: <Widget>[
          Container(
              color: AppColors.background,
              child: Column(children: [TopBox(), PlotBox()])),
          const CalendarPage(),
          const DataPrototype(),
          const ChatbotPage(),
          const ChatbotCalendar(), //const ProfileSettings()
        ][currentPageIndex]);
  }

  Widget DateAndProfilePic() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Padding(
          padding: const EdgeInsets.only(left: 29, right: 29),
          child: Text(dateString,
              style:
                  const TextStyle(fontFamily: 'Inter-Regular', fontSize: 24))),
      Align(
          alignment: Alignment.centerRight,
          child: Container(
              width: 90,
              height: 90,
              decoration: const BoxDecoration(color: Colors.transparent),
              alignment: Alignment.center,
              child: Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(29),
                    color: Colors.black,
                  ),
                  child: GestureDetector(
                      onTap: () {
                        setState(() {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ProfileSettings()),
                          );
                        });
                      },
                      child: const CircleAvatar(
                        backgroundColor: AppColors.lavender,
                        backgroundImage: AssetImage(
                            'lib/assets/images/profile_default1.png'),
                      )))))
    ]);
  }

  Widget CalendarScroll() {
    return Expanded(
        child: SizedBox(
            height: 100.0,
            child: InfiniteListView.builder(
                controller: InfiniteScrollController(
                    initialScrollOffset:
                        -MediaQuery.of(context).size.width * 0.8),
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return DateBox(index);
                })));
  }

  Widget DateBox(int relativePos) {
    String date = 'Err';
    String day_str = 'Err';
    Color dateTextColor = Colors.black;
    Color dateTextColorPointing = Colors.white;
    BoxDecoration dec = const BoxDecoration();
    BoxDecoration decPointing = const BoxDecoration(
        color: AppColors.lavender,
        borderRadius: BorderRadius.all(Radius.circular(14)));
    BoxDecoration decToday = BoxDecoration(
        border: Border.all(color: AppColors.mint, width: 1.0),
        borderRadius: const BorderRadius.all(Radius.circular(14)));

    bool tick = false;
    bool isPointing = false;
    bool isToday = false;
    DateTime thisDate =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
            .add(Duration(days: relativePos));

    if (thisDate.year == pointTo.year &&
        thisDate.month == pointTo.month &&
        thisDate.day == pointTo.day) {
      isPointing = true;
    } else if (thisDate.day == DateTime.now().day &&
        thisDate.month == DateTime.now().month) {
      isToday = true;
    }

    date = thisDate.day.toString();
    day_str = weekdays[thisDate.weekday - 1];

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
              return GestureDetector(
                  onTap: () {
                    setState(() {
                      pointTo = DateTime(
                          thisDate.year, thisDate.month, thisDate.day, 0, 0, 0);
                      _g_pos = relativePos;
                      if (thisDate.year == pointTo.year &&
                          thisDate.month == pointTo.month &&
                          thisDate.day == pointTo.day) {
                        isPointing = true;
                        if (relativePos == 0) {
                          dateString = 'Today';
                        } else if (relativePos == -1) {
                          dateString = 'Yesterday';
                        } else if (thisDate.year == DateTime.now().year) {
                          dateString =
                              '${months[thisDate.month]} ${thisDate.day}';
                        } else {
                          dateString =
                              '${months[thisDate.month]} ${thisDate.day}, ${thisDate.year}';
                        }
                      } else {
                        isPointing = false;
                      }
                    });
                  },
                  child: Container(
                      width: 50,
                      alignment: Alignment.center,
                      child: Column(children: [
                        Container(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Icon(Icons.done_outline_rounded,
                                color:
                                    tick ? AppColors.mint : AppColors.trans)),
                        Container(
                            width: 50,
                            height: 50,
                            decoration: isPointing
                                ? decPointing
                                : isToday
                                    ? decToday
                                    : dec,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(day_str,
                                      style: TextStyle(
                                          fontFamily: 'Inter-Regular',
                                          fontSize: 12,
                                          color: isPointing
                                              ? dateTextColorPointing
                                              : dateTextColor)),
                                  Text(date,
                                      style: TextStyle(
                                          fontFamily: 'Inter-Regular',
                                          fontSize: 20,
                                          color: isPointing
                                              ? dateTextColorPointing
                                              : dateTextColor))
                                ])),
                      ])));
            }
          }
          return const Center(
            child: CircularProgressIndicator(color: AppColors.trans),
          );
        },
        future: isTicks(thisDate).then((e) => tick = e));
  }

  Future<bool> isTicks(DateTime time) async {
    List<TrackTmGV> listmaps = await databaseHelperGV.selectDay(time);
    return listmaps.isNotEmpty ? true : false;
  }

  Widget TopBox() {
    return Container(
        height: 200,
        //constraints: BoxConstraints(
        //  minHeight: MediaQuery.of(context).size.height * 0.22),
        decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Color.fromRGBO(149, 157, 165, 0.1),
                  offset: Offset.zero,
                  spreadRadius: 4,
                  blurRadius: 10)
            ],
            color: Colors.white,
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(24),
                bottomLeft: Radius.circular(24))),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [DateAndProfilePic(), CalendarScroll()]));
  }

  Future<List<TrackTmGV>> doPlot() async {
    DateTime thisDate =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
            .add(Duration(days: _g_pos));
    List<TrackTmGV> d = await databaseHelperGV.selectDay(thisDate);
    await databaseHelperGV.queryAllRowsMap();

    return d;
  }

  Widget PlotBox() {
    late List<TrackTmGV> dayData;

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
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(left: 17, right: 17, top: 37),
                  constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height * 0.45),
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
                  child: Column(children: [
                    Container(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, top: 26, bottom: 26),
                        alignment: Alignment.topLeft,
                        child: (dayData.isNotEmpty)
                            ? LineChartBox(
                                dayData) /*Container(
                                padding: EdgeInsets.only(
                                    left: 0, right: 10, top: 0, bottom: 0),
                                child: Text(tx,
                                    style: TextStyle(
                                        fontFamily: 'Inter-Regular',
                                        fontSize: 16)))*/
                            : Row(children: [
                                Container(
                                    padding: const EdgeInsets.only(
                                        left: 0, right: 10, top: 0, bottom: 0),
                                    child: const Icon(Icons.info_outline,
                                        color: AppColors.lavender)),
                                const Text(
                                    'Log your data to see graph for today',
                                    style: TextStyle(
                                        fontFamily: 'Inter-Regular',
                                        fontSize: 16))
                              ]))
                  ]));
            }
          }
          return const Center(
            child: CircularProgressIndicator(color: AppColors.trans),
          );
        },
        future: doPlot().then((e) => dayData = e));
  }

  Widget LineChartBox(List<TrackTmGV> listofmaps) {
    late List<int> showingTooltipOnSpots;
    late List<FlSpot> allSpots;
    late List<double> listY;
    late List<double> listX;
    double minX = 0;
    double maxX = 0;
    double minY = 0;
    double maxY = 0;

    int j = 0;
    showingTooltipOnSpots = [];
    allSpots = [];
    listY = [];
    listX = [];
    for (TrackTmGV i in listofmaps) {
      double tt = 0;
      if (i.minute == 0) {
        tt = i.hour.toDouble();
      } else {
        tt = i.hour.toDouble();
        tt = tt + 0.5;
      }

      listX.add(tt);
      listY.add(i.gluval.GV);
      allSpots.add(FlSpot(tt, i.gluval.GV));
      showingTooltipOnSpots.add(j);
      j++;
    }

    double MinX = listX.reduce(min);
    if (MinX < 6) {
      if (MinX % 2 == 0) {
        minX = MinX;
      } else {
        minX = MinX - 1;
      }
    } else {
      minX = 6;
    }

    maxX = 24;

    double MaxY = listY.reduce(max);
    if (MaxY > 14) {
      if (MaxY % 2 == 0) {
        maxY = MaxY;
      } else {
        maxY = MaxY + 1;
      }
    } else {
      maxY = 14;
    }
    final lineBarsData = [
      LineChartBarData(
        showingIndicators: showingTooltipOnSpots,
        spots: allSpots,
        isCurved: true,
        barWidth: 2,
        belowBarData: BarAreaData(
          show: true,
          gradient: LinearGradient(
            begin: Alignment.center,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.lavender.withOpacity(0.2),
              AppColors.lavender.withOpacity(0),
            ],
            //stops: const [0.1, 0.4, 0.9],
          ),
        ),
        dotData: const FlDotData(show: false),
        color: AppColors.lavender,
      )
    ];

    final tooltipsOnBar = lineBarsData[0];

    return AspectRatio(
        aspectRatio: 1.2,
        child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 0,
              vertical: 30,
            ),
            child: LayoutBuilder(builder: (context, constraints) {
              return LineChart(LineChartData(
                  extraLinesData: ExtraLinesData(horizontalLines: [
                    HorizontalLine(
                      y: listY.reduce((a, b) => a + b) / listY.length,
                      color: AppColors.mint,
                      strokeWidth: 3,
                    )
                  ]),
                  minX: minX,
                  maxX: maxX,
                  minY: minY,
                  maxY: maxY,
                  showingTooltipIndicators: showingTooltipOnSpots.map((index) {
                    return ShowingTooltipIndicators([
                      LineBarSpot(
                        tooltipsOnBar,
                        lineBarsData.indexOf(tooltipsOnBar),
                        tooltipsOnBar.spots[index],
                      ),
                    ]);
                  }).toList(),
                  lineTouchData: LineTouchData(
                      enabled: true,
                      handleBuiltInTouches: false,
                      getTouchedSpotIndicator:
                          (LineChartBarData barData, List<int> spotIndexes) {
                        return spotIndexes.map((index) {
                          return TouchedSpotIndicatorData(
                              const FlLine(
                                color: AppColors.trans,
                              ),
                              FlDotData(
                                  show: true,
                                  getDotPainter:
                                      (spot, percent, barData, index) =>
                                          FlDotCirclePainter(
                                            radius: 5,
                                            color: Colors.white,
                                            strokeWidth: 2,
                                            strokeColor: AppColors.lavender,
                                          )));
                        }).toList();
                      },
                      touchTooltipData: LineTouchTooltipData(
                          tooltipBgColor: AppColors.lavender_light,
                          tooltipRoundedRadius: 12,
                          //tooltipMargin: 12,
                          tooltipPadding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 8),
                          getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
                            return lineBarsSpot.map((lineBarSpot) {
                              return LineTooltipItem(
                                  lineBarSpot.y.toString(),
                                  const TextStyle(
                                    color: AppColors.text_info,
                                    fontFamily: 'Inter-Regular',
                                    fontSize: 12,
                                  ));
                            }).toList();
                          })),
                  lineBarsData: lineBarsData,
                  titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                          axisNameSize: 0,
                          sideTitles: SideTitles(
                              showTitles: true,
                              interval: 2,
                              getTitlesWidget: (value, meta) {
                                String s;
                                if (value == 0) {
                                  s = '';
                                } else {
                                  s = value.round().toString();
                                }

                                return SideTitleWidget(
                                    axisSide: meta.axisSide,
                                    child: Text(s.toString(),
                                        style: const TextStyle(
                                            color: AppColors.text_info,
                                            fontFamily: 'Inter-Regular',
                                            fontSize: 12)));
                              },
                              reservedSize: 25)),
                      bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                        showTitles: true,
                        interval: 2,
                        getTitlesWidget: (value, meta) {
                          String s;
                          if (value == 24) {
                            s = '';
                          } else {
                            s = value.round().toString();
                          }

                          return SideTitleWidget(
                              axisSide: meta.axisSide,
                              child: Text(s,
                                  style: const TextStyle(
                                      color: AppColors.text_info,
                                      fontFamily: 'Inter-Regular',
                                      fontSize: 12)));
                        },
                        reservedSize: 30,
                      )),
                      rightTitles: const AxisTitles(),
                      topTitles: const AxisTitles()),
                  gridData: const FlGridData(show: true),
                  borderData: FlBorderData(
                      show: true,
                      border: Border.all(
                        color: AppColors.trans,
                      ))));
            })));
  }

  /// Lerps between a [LinearGradient] colors, based on [t]
  Color lerpGradient(List<Color> colors, List<double> stops, double t) {
    if (colors.isEmpty) {
      throw ArgumentError('"colors" is empty.');
    } else if (colors.length == 1) {
      return colors[0];
    }

    if (stops.length != colors.length) {
      stops = [];

      /// provided gradientColorStops is invalid and we calculate it here
      colors.asMap().forEach((index, color) {
        final percent = 1.0 / (colors.length - 1);
        stops.add(percent * index);
      });
    }

    for (var s = 0; s < stops.length - 1; s++) {
      final leftStop = stops[s];
      final rightStop = stops[s + 1];
      final leftColor = colors[s];
      final rightColor = colors[s + 1];
      if (t <= leftStop) {
        return leftColor;
      } else if (t < rightStop) {
        final sectionT = (t - leftStop) / (rightStop - leftStop);
        return Color.lerp(leftColor, rightColor, sectionT)!;
      }
    }
    return colors.last;
  }
}
