import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/colors.dart';
import 'package:flutter_app/data_log/data_log.dart';
import 'dart:core';
import 'package:fl_chart/fl_chart.dart';

import 'package:flutter_app/profile_settings/profile.dart';
import 'package:flutter_app/test.dart';
import 'dart:math';

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

List<double> listY = funcY();
//List<String> listY3 = ['0', '5', '9', '', '9', '11', '13'];
List<String> listY2 = ['0', '4', '7', '10', '13', '16', '19'];
List<String> listY1 = ['0', '3', '5', '7', '9', '11', '13'];

List<double> funcY() {
  List<double> jj = [];
  for (int i = 0; i < 24; i++) {
    jj.add(i.toDouble());
    jj.add(i.toDouble() + 0.5);
  }
  return jj;
}

List<String> funcX() {
  List<String> ii = [];
  for (int i = 0; i < 26; i++) {
    for (int j = 0; j < 10; j++) {
      //ii.add('${i}.');
    }
  }
  return ii;
}

int g_pos = 0;
final dpKey = new GlobalKey<_DateAndProfilePicState>();
final sKey = new GlobalKey<_SeePlotState>();

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPageIndex = 0;

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
        bottomNavigationBar: Container(
            height: 60,
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  color: Color.fromRGBO(149, 157, 165, 0.1),
                  offset: Offset.zero,
                  spreadRadius: 4,
                  blurRadius: 10)
            ]),
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
              child: Column(children: [TopPlashka(), SeePlot(key: sKey)])),
          Container(
              color: Colors.green,
              alignment: Alignment.center,
              child: const Text('Page 2')),
          DataLog(key: lkey),
          Container(
              color: Colors.blue,
              alignment: Alignment.center,
              child: const Text('Page 4')),
          ExampleDragAndDrop()
        ][currentPageIndex]);
  }
}

class DateAndProfilePic extends StatefulWidget {
  DateAndProfilePic({required Key key}) : super(key: key);

  @override
  State<DateAndProfilePic> createState() => _DateAndProfilePicState();
}

class _DateAndProfilePicState extends State<DateAndProfilePic> {
  String tx = 'Today';

  _DateAndProfilePicState() {
    int pos = g_pos;
    if (pos != 0) {
      DateTime this_date = DateTime.now();
      if (pos > 0) {
        this_date = this_date.subtract(Duration(days: pos));
      } else {
        this_date = this_date.add(Duration(days: -pos));
      }
      tx = weekdays[this_date.weekday - 1] +
          ' ' +
          this_date.day.toString() +
          ' ' +
          months[this_date.month - 1];
    } else {
      tx = 'Today';
    }
  }

  void getTx() {
    setState(() {
      int pos = g_pos;
      if (pos != 0) {
        DateTime this_date = DateTime.now();
        if (pos > 0) {
          this_date = this_date.subtract(Duration(days: pos));
        } else {
          this_date = this_date.add(Duration(days: -pos));
        }
        tx = weekdays[this_date.weekday - 1] +
            ' ' +
            this_date.day.toString() +
            ' ' +
            months[this_date.month - 1];
      } else {
        tx = 'Today';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Container(
          child: Padding(
              padding: EdgeInsets.only(left: 29, right: 29),
              /*child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return FadeTransition(opacity: animation, child: child);
                  },*/
              child: Text(tx,
                  key: ValueKey<String>(tx),
                  style:
                      TextStyle(fontFamily: 'Inter-Regular', fontSize: 24)))),
      Align(
          alignment: Alignment.centerRight,
          child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(color: Colors.transparent),
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
                      child: CircleAvatar(
                        backgroundColor: AppColors.lavender,
                        backgroundImage: AssetImage(
                            'lib/assets/images/profile_default1.png'),
                      )))))
    ]));
  }
}

class CalendarScroll extends Container {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(bottom: 18),
        alignment: Alignment.bottomCenter,
        child: Week());
  }
}

class TopPlashka extends Container {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 200,
        //constraints: BoxConstraints(
        //  minHeight: MediaQuery.of(context).size.height * 0.22),
        decoration: BoxDecoration(
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
            children: [
              DateAndProfilePic(key: dpKey),
              Align(alignment: Alignment.bottomCenter, child: CalendarScroll())
            ]));
  }
}

class SeePlot extends StatefulWidget {
  SeePlot({required Key key}) : super(key: key);

  @override
  State<SeePlot> createState() => _SeePlotState();
}

bool isThereInfo = false;

class _SeePlotState extends State<SeePlot> {
  Future<List<Map<String, dynamic>>> doPlot() async {
    print('Doing initialization plot');
    int poss = g_pos;
    DateTime time = DateTime.now();
    DateTime this_date =
        DateTime(time.year, time.month, time.day, 0, 0, 0, 0, 0);
    if (poss != 0) {
      if (poss > 0) {
        this_date = this_date.subtract(Duration(days: poss));
      } else {
        this_date = this_date.add(Duration(days: -poss));
      }
    }
    List<Map<String, dynamic>> dat =
        await databaseHelper.selectGV(this_date.toIso8601String());
    return dat;
  }

  Future<bool> doPlotSecond() async {
    print('Doing secondary plot');
    int poss = g_pos;
    DateTime time = DateTime.now();
    DateTime this_date =
        DateTime(time.year, time.month, time.day, 0, 0, 0, 0, 0);
    if (poss != 0) {
      if (poss > 0) {
        this_date = this_date.subtract(Duration(days: poss));
      } else {
        this_date = this_date.add(Duration(days: -poss));
      }
    }
    List<Map<String, dynamic>> dat =
        await databaseHelper.selectGV(this_date.toIso8601String());
    setState(() {
      if (dat.length != 0) {
        isThereInfo = true;
      } else {
        isThereInfo = false;
      }
    });

    return isThereInfo;
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
                  style: TextStyle(fontSize: 18),
                ),
              );
            } else if (snapshot.hasData) {
              final isIt = snapshot.data as List<Map<String, dynamic>>;
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
                  child: Column(children: [
                    Container(
                        padding: EdgeInsets.only(
                            left: 10, right: 10, top: 26, bottom: 26),
                        alignment: Alignment.topLeft,
                        child: (isIt.length != 0)
                            ? LineChartSample5(
                                isIt) /*Container(
                                padding: EdgeInsets.only(
                                    left: 0, right: 10, top: 0, bottom: 0),
                                child: Text(tx,
                                    style: TextStyle(
                                        fontFamily: 'Inter-Regular',
                                        fontSize: 16)))*/
                            : Row(children: [
                                Container(
                                    padding: EdgeInsets.only(
                                        left: 0, right: 10, top: 0, bottom: 0),
                                    child: Icon(Icons.info_outline,
                                        color: AppColors.lavender)),
                                Text('Log your data to see graph for today',
                                    style: TextStyle(
                                        fontFamily: 'Inter-Regular',
                                        fontSize: 16))
                              ]))
                  ]));
            }
          }
          return Center(
            child: CircularProgressIndicator(color: AppColors.lavender),
          );
        },
        future: doPlot());
  }
}

class DayCont extends StatelessWidget {
  String date = 'Err';
  String day_str = 'Err';
  Color tx = Colors.black;
  BoxDecoration dec = BoxDecoration();
  bool tick = false;
  int pos = 0;
  bool isPoint = false;

  DayCont(this.pos, this.isPoint) {
    if (isPoint == true) {
      tx = Colors.white;
      dec = BoxDecoration(
          color: AppColors.lavender,
          borderRadius: BorderRadius.all(Radius.circular(14)));
    }
    DateTime this_date = DateTime.now();
    if (pos >= 0) {
      this_date = this_date.subtract(Duration(days: pos));
    } else {
      this_date = this_date.add(Duration(days: -pos));
    }
    date = this_date.day.toString();
    day_str = weekdays[this_date.weekday - 1];

    if (this_date.day == DateTime.now().day &&
        this_date.month == DateTime.now().month &&
        isPoint != true) {
      dec = BoxDecoration(
          border: Border.all(color: AppColors.mint, width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(14)));
    }
  }

  void doChange(int position) {
    pos = position;

    if (isPoint == true) {
      tx = Colors.white;
      dec = BoxDecoration(
          color: AppColors.lavender,
          borderRadius: BorderRadius.all(Radius.circular(14)));
    }
    DateTime this_date = DateTime.now();
    if (position >= 0) {
      this_date = this_date.subtract(Duration(days: position));
    } else {
      this_date = this_date.add(Duration(days: -position));
    }
    date = this_date.day.toString();
    day_str = weekdays[this_date.weekday - 1];

    if (this_date.day == DateTime.now().day &&
        this_date.month == DateTime.now().month &&
        isPoint != true) {
      dec = BoxDecoration(
          border: Border.all(color: AppColors.mint, width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(14)));
    }
  }

  String tostring() {
    return 'position: $pos, $date, $day_str, $isPoint';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 50,
        height: 50,
        decoration: dec,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(day_str,
              style: TextStyle(
                  fontFamily: 'Inter-Regular', fontSize: 12, color: tx)),
          Text(date,
              style: TextStyle(
                  fontFamily: 'Inter-Regular', fontSize: 20, color: tx))
        ]));
  }
}

class Week extends StatefulWidget {
  @override
  State<Week> createState() => _WeekState();
}

class _WeekState extends State<Week> {
  int pos = 0;
  late List<DayCont> dayconts;
  List<Map<String, dynamic>> cur = [];

  _WeekState() {
    updateDC(pos);
  }

  Future<List<bool>> isTicks(int position) async {
    List<bool> ticks = [false, false, false, false, false, false];
    for (int i = 0; i < 6; i++) {
      int poss = g_pos + i;
      DateTime time = DateTime.now();
      DateTime this_date =
          DateTime(time.year, time.month, time.day, 0, 0, 0, 0, 0);
      if (poss != 0) {
        if (poss > 0) {
          this_date = this_date.subtract(Duration(days: poss));
        } else {
          this_date = this_date.add(Duration(days: -poss));
        }
      }
      List<Map<String, dynamic>> listmaps =
          await databaseHelper.selectGV(this_date.toIso8601String());

      if (listmaps.length != 0) {
        ticks[i] = true;
      } else {
        ticks[i] = false;
      }
    }
    return ticks;
  }

  DayCont getDC(int idx, int pos) {
    updateDC(pos);
    return dayconts[idx];
  }

  void updateDC(int pos) {
    this.pos = pos;
    dayconts = [
      DayCont(pos + 5, false),
      DayCont(pos + 4, false),
      DayCont(pos + 3, false),
      DayCont(pos + 2, false),
      DayCont(pos + 1, false),
      DayCont(pos, true)
    ];
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
                  style: TextStyle(fontSize: 18),
                ),
              );
            } else if (snapshot.hasData) {
              final ticks = snapshot.data as List<bool>;
              return Container(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          icon: Icon(Icons.arrow_back_ios),
                          onPressed: () {
                            setState(() {
                              this.pos = this.pos + 1;
                              g_pos = this.pos;
                              dpKey.currentState?.getTx();
                              sKey.currentState?.doPlotSecond();
                              updateDC(pos);
                            });
                          }),
                      Container(
                          width: 50,
                          alignment: Alignment.center,
                          child: Column(children: [
                            Container(
                                padding: EdgeInsets.only(bottom: 10),
                                child: Icon(Icons.done_outline_rounded,
                                    color: ticks[5]
                                        ? AppColors.mint
                                        : AppColors.trans)),
                            getDC(0, g_pos)
                          ])),
                      Container(
                          width: 50,
                          alignment: Alignment.center,
                          child: Column(children: [
                            Container(
                                padding: EdgeInsets.only(bottom: 10),
                                child: Icon(Icons.done_outline_rounded,
                                    color: ticks[4]
                                        ? AppColors.mint
                                        : AppColors.trans)),
                            getDC(1, g_pos)
                          ])),
                      Container(
                          width: 50,
                          alignment: Alignment.center,
                          child: Column(children: [
                            Container(
                                padding: EdgeInsets.only(bottom: 10),
                                child: Icon(Icons.done_outline_rounded,
                                    color: ticks[3]
                                        ? AppColors.mint
                                        : AppColors.trans)),
                            getDC(2, g_pos)
                          ])),
                      Container(
                          width: 50,
                          alignment: Alignment.center,
                          child: Column(children: [
                            Container(
                                padding: EdgeInsets.only(bottom: 10),
                                child: Icon(Icons.done_outline_rounded,
                                    color: ticks[2]
                                        ? AppColors.mint
                                        : AppColors.trans)),
                            getDC(3, g_pos)
                          ])),
                      Container(
                          width: 50,
                          alignment: Alignment.center,
                          child: Column(children: [
                            Container(
                                padding: EdgeInsets.only(bottom: 10),
                                child: Icon(Icons.done_outline_rounded,
                                    color: ticks[1]
                                        ? AppColors.mint
                                        : AppColors.trans)),
                            getDC(4, g_pos)
                          ])),
                      Container(
                          width: 50,
                          alignment: Alignment.center,
                          child: Column(children: [
                            Container(
                                padding: EdgeInsets.only(bottom: 10),
                                child: Icon(Icons.done_outline_rounded,
                                    color: ticks[0]
                                        ? AppColors.mint
                                        : AppColors.trans)),
                            getDC(5, g_pos)
                          ])),
                      IconButton(
                          icon: Icon(Icons.arrow_forward_ios),
                          onPressed: () {
                            setState(() {
                              this.pos = this.pos - 1;
                              g_pos = this.pos;
                              dpKey.currentState?.getTx();
                              sKey.currentState?.doPlotSecond();
                              updateDC(pos);
                            });
                          })
                    ]),
              );
            }
          }
          return Center(
            child: CircularProgressIndicator(color: AppColors.lavender),
          );
        },
        future: isTicks(pos));
  }
}

class LineChartSample5 extends StatefulWidget {
  List<Map<String, dynamic>> listofmaps = [];

  LineChartSample5(this.listofmaps);

  @override
  State<LineChartSample5> createState() => _LineChartSample5State(listofmaps);
}

class _LineChartSample5State extends State<LineChartSample5> {
  late List<int> showingTooltipOnSpots;
  late List<FlSpot> allSpots;
  late List<double> listY;
  late List<double> listX;
  double minX = 0;
  double maxX = 0;
  double minY = 0;
  double maxY = 0;

  _LineChartSample5State(List<Map<String, dynamic>> listofmaps) {
    int j = 0;
    showingTooltipOnSpots = [];
    allSpots = [];
    listY = [];
    listX = [];
    for (Map<String, dynamic> i in listofmaps) {
      double tt = 0;
      if (i['"minute'] == 0) {
        tt = i['hour'];
      } else {
        tt = i['hour'].toDouble();
        tt = tt + 0.5;
      }

      listX.add(tt);
      listY.add(i['glucose_val']);
      allSpots.add(FlSpot(tt, i['glucose_val']));
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

    double minY = 0;
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
  }

  @override
  Widget build(BuildContext context) {
    print([minX, maxX, minY, maxY].toString());
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
                              FlLine(
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
                          tooltipPadding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
                            return lineBarsSpot.map((lineBarSpot) {
                              return LineTooltipItem(
                                  lineBarSpot.y.toString(),
                                  TextStyle(
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
                                        style: TextStyle(
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
                                  style: TextStyle(
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
