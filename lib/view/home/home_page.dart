// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/server/models/TrackTmGV.dart';
import 'package:flutter_app/view/calendar/calendar.dart';
import 'package:flutter_app/view/chatbot_dialogbox/chatbot.dart';
import 'package:flutter_app/assets/colors.dart';
import 'dart:core';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/view/data_log/data_logging.dart';
import 'package:flutter_app/view/profile_settings/profile.dart';
import 'dart:math';
import 'package:infinite_listview/infinite_listview.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

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
  int currentPageIndex = 0;
  late String dateString;
  int _g_pos = 0;
  late List<TrackTmGV> dataList;
  late Interpreter _interpreter;
  final String model = 'lib/assets/my_model.tflite';
  late List<int> showingTooltipOnSpots;
  late List<double> predictedList;

  @override
  void initState() {
    super.initState();
    showingTooltipOnSpots = [];
    predictedList = [];
    if (_g_pos != 0) {
      DateTime thisDate = DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .add(Duration(days: _g_pos));
      dateString =
          '${weekdays[thisDate.weekday - 1]} ${thisDate.day} ${months[thisDate.month - 1]}';
    } else {
      dateString = 'Today';
    }
    dataList = [];
    loadData().then((res) => loadModel());
  }

  Future<int> loadData() async {
    DateTime thisDate =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
            .add(Duration(days: _g_pos));
    dataList = await databaseHelperGV.selectDay(thisDate);
    return 1;
  }

  void loadModel() async {
    _interpreter = await Interpreter.fromAsset(model);
    predict();
  }

  Map<int, int> getTimeMap() {
    List<int> hours = [
      6,
      7,
      8,
      9,
      10,
      11,
      12,
      13,
      14,
      15,
      16,
      17,
      18,
      19,
      20,
      21,
      22,
      23
    ];
    List<int> minutes = [0, 10, 20, 30, 40, 50];
    Map<int, int> map = {};
    int index = 0;
    for (int i = 0; i < hours.length; i++) {
      for (int j = 0; j < minutes.length; j++) {
        map.putIfAbsent(hours[i] * 60 + minutes[j], () => index);
        index++;
      }
    }

    return map;
  }

  void predict() {
    Map<int, int> timeMap = getTimeMap();
    List<double> input = List.filled(108, 0);
    showingTooltipOnSpots = [];
    for (TrackTmGV i in dataList) {
      int reading = i.hour * 60 + (i.minute / 10).floor() * 10;
      if (timeMap.containsKey(reading)) {
        input[timeMap[reading] ?? 0] = i.gluval.GV;
        showingTooltipOnSpots.add(timeMap[reading] ?? 0);
      }
    }
    List<dynamic> output = input.reshape<double>([1, 108]);
    _interpreter.run(input.reshape<double>([1, 108, 1]), output);
    List<double> result = [];
    output.reshape([108]).forEach((element) => result.add(element));
    for (int i in showingTooltipOnSpots) {
      result[i] = input[i];
    }
    predictedList = result;
  }

  @override
  Widget build(BuildContext context) {
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
        bottomNavigationBar: SizedBox(
            height: 60,
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
                  icon: Icon(Icons.area_chart_outlined),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.recent_actors_outlined),
                  label: '',
                ),
              ],
            )),
        body: <Widget>[
          Container(
              color: AppColors.background,
              child: Column(children: [buildTopBox(), buildPlotBox()])),
          const CalendarPage(),
          const DataPrototype(),
          const ChatbotPage(),
          const ProfileSettings()
        ][currentPageIndex]);
  }

  Widget buildDateAndProfilePic() {
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

  Widget buildCalendarScroll() {
    return Expanded(
        child: SizedBox(
            height: 100.0,
            child: InfiniteListView.builder(
                controller: InfiniteScrollController(
                    initialScrollOffset:
                        -MediaQuery.of(context).size.width * 0.8),
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return buildDateBox(index);
                })));
  }

  Widget buildDateBox(int relativePos) {
    String date = 'Err';
    String day_str = 'Err';
    Color dateTextColor = Colors.black;
    Color dateTextColorPointing = Colors.white;
    BoxDecoration dec = const BoxDecoration();
    BoxDecoration decPointing = BoxDecoration(
        color: AppColors.lavender,
        border: Border.all(color: AppColors.lavender, width: 1.0),
        borderRadius: const BorderRadius.all(Radius.circular(14)));
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
                      loadData().then((res) => loadModel());
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
                            height: 52,
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

  Widget buildTopBox() {
    return Container(
        height: 200,
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
            children: [buildDateAndProfilePic(), buildCalendarScroll()]));
  }

  Widget buildPlotBox() {
    //loadData().then((res) => loadModel());
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
                        child: (dataList.isNotEmpty)
                            ? buildLineChartBox()
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
                              ])),
                    (dataList.isNotEmpty)
                        ? Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Row(children: [
                              const Text('Predicted average:   ',
                                  style: TextStyle(
                                      fontFamily: 'Inter-Regular',
                                      fontSize: 16,
                                      color: Colors.black)),
                              Text(
                                  predictedList.isNotEmpty
                                      ? '${(predictedList.reduce((a, b) => a + b) / predictedList.length).toStringAsPrecision(2)} mmol/L'
                                      : '',
                                  style: const TextStyle(
                                      fontFamily: 'Inter-Regular',
                                      fontSize: 16,
                                      color: AppColors.text_info))
                            ]))
                        : Container()
                  ]));
            }
          }
          return const Center(
            child: CircularProgressIndicator(color: AppColors.trans),
          );
        },
        future: loadData().then((res) {
          loadModel();
          return 1;
        }));
  }

  Widget buildLineChartBox() {
    late List<FlSpot> allSpots;
    late List<double> listY;
    late List<double> listX;
    double minX = 0;
    double maxX = 0;
    double minY = 0;
    double maxY = 0;
    Map<int, int> timeMap = getTimeMap();

    allSpots = [];
    listY = [];
    listX = [];
    int breakPoint = _g_pos == 0
        ? DateTime.now().hour * 60 + DateTime.now().minute
        : 1000000;
    for (int timeKey in timeMap.keys) {
      if (timeKey >= breakPoint) {
        break;
      }
      double timePoint = (timeKey / 60 * 100).round() / 100;
      double gvPoint = (predictedList[timeMap[timeKey] ?? 0] * 10).round() / 10;
      listX.add(timePoint);
      listY.add(gvPoint);
      allSpots.add(FlSpot(timePoint, gvPoint));
    }

    double MinX = listX.isEmpty ? 6 : listX.reduce(min);
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

    double MaxY = listY.isEmpty ? 14 : listY.reduce(max);
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
        isCurved: false,
        barWidth: 1,
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
                      enabled: false,
                      handleBuiltInTouches: true,
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
                      show: true, border: Border.all(color: AppColors.trans))));
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
