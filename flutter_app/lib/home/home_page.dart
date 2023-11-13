import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/colors.dart';
import 'package:flutter_app/data%20log/data_log.dart';
import 'dart:core';

import 'package:flutter_app/profile_settings/profile.dart';

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

int g_pos = 0;
final key = new GlobalKey<_DateAndProfilePicState>();

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
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
              child: Column(children: [TopPlashka(), SeePlot()])),
          Container(
              color: Colors.green,
              alignment: Alignment.center,
              child: const Text('Page 2')),
          DataLog(),
          Container(
              color: Colors.blue,
              alignment: Alignment.center,
              child: const Text('Page 4')),
          Container(
              color: Colors.purple,
              alignment: Alignment.center,
              child: const Text('Page 3'))
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
            color: Colors.white,
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(24),
                bottomLeft: Radius.circular(24))),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DateAndProfilePic(key: key),
              Align(alignment: Alignment.bottomCenter, child: CalendarScroll())
            ]));
  }
}

class SeePlot extends Container {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(left: 17, right: 17, top: 37),
        constraints:
            BoxConstraints(minHeight: MediaQuery.of(context).size.height * 0.3),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(24)),
        child: Column(children: [
          Container(
              padding:
                  EdgeInsets.only(left: 10, right: 10, top: 26, bottom: 26),
              alignment: Alignment.topLeft,
              child: Row(children: [
                Container(
                    padding:
                        EdgeInsets.only(left: 0, right: 10, top: 0, bottom: 0),
                    child: Icon(Icons.info_outline, color: AppColors.lavender)),
                Text('Log your data to see graph for today',
                    style: TextStyle(fontFamily: 'Inter-Regular', fontSize: 16))
              ]))
        ]));
  }
}

class DayCont extends Container {
  Color ic = AppColors.trans;
  String date = 'Err';
  String day_str = 'Err';
  Color tx = Colors.black;
  BoxDecoration dec = BoxDecoration();

  DayCont(int pos, bool isPoint) {
    if (isPoint == false) {
      if (isTick(pos) == true) {
        ic = AppColors.mint;
      }
    } else {
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

    /*if (this_date.day == DateTime.now().day &&
        this_date.month == DateTime.now().month &&
        isPoint != true) {
      dec = BoxDecoration(
          border: Border.all(color: AppColors.mint, width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(14)));
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 50,
        alignment: Alignment.center,
        child: Column(children: [
          Container(
              padding: EdgeInsets.only(bottom: 10),
              child: Icon(Icons.done_outline_rounded, color: ic)),
          Container(
              width: 50,
              height: 50,
              decoration: dec,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(day_str,
                        style: TextStyle(
                            fontFamily: 'Inter-Regular',
                            fontSize: 12,
                            color: tx)),
                    Text(date,
                        style: TextStyle(
                            fontFamily: 'Inter-Regular',
                            fontSize: 20,
                            color: tx))
                  ]))
        ]));
  }
}

class Week extends StatefulWidget {
  @override
  State<Week> createState() => _WeekState();
}

class _WeekState extends State<Week> {
  int pos = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Container(
          //padding: EdgeInsets.only(left: 8),
          child: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                setState(() {
                  this.pos = this.pos + 1;
                  g_pos = this.pos;
                  key.currentState?.getTx();
                });
              })),
      DayCont(pos + 5, false),
      DayCont(pos + 4, false),
      DayCont(pos + 3, false),
      DayCont(pos + 2, false),
      DayCont(pos + 1, false),
      DayCont(pos, true),
      Container(
          //padding: EdgeInsets.only(left: 8, right: 3),
          child: IconButton(
              icon: Icon(Icons.arrow_forward_ios),
              onPressed: () {
                setState(() {
                  this.pos = this.pos - 1;
                  g_pos = this.pos;
                  key.currentState?.getTx();
                  //key.currentState?.build(context);
                });
              })),
    ]));
  }
}

bool isTick(int date) {
  if (date % 2 == 0) {
    return true;
  } else {
    return false;
  }
}
