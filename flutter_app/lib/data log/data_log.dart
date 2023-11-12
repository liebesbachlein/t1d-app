import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/colors.dart';
import 'dart:core';

final AppColors ac = AppColors();
List<Color> pallete1 = getColArr(ac.hex_arr);
List<Color> pallete2 = getColArr(ac.hex_arr2);

List<Color> getColArr(List<int> arr) {
  final List<Color> col = [];

  for (int i in arr) {
    col.add(Color(i));
  }
  return col;
}

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

class DataLog extends StatefulWidget {
  const DataLog({super.key});

  @override
  State<DataLog> createState() => _DataLogState();
}

class _DataLogState extends State<DataLog> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: AppColors.background,
        child: Column(children: [TopSetDL(), Scale1()]));
  }
}

class TopSetDL extends StatefulWidget {
  const TopSetDL({super.key});
  @override
  State<TopSetDL> createState() => _TopSetDLState();
}

class _TopSetDLState extends State<TopSetDL> {
  int pos = 0;
  String tx = 'Today';

  String getTx() {
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
    return tx;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        height: 50,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Container(
              child: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  color: Colors.black,
                  onPressed: () {
                    setState(() {
                      pos = pos + 1;
                    });
                  })),
          Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width * 0.5,
              child: Text(getTx(),
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
                      pos = pos - 1;
                    });
                  })),
        ]));
  }
}

class Scale1 extends Container {
  List<GluVal1> scale1 = [];

  Scale1() {
    scale1 = [];
    int s = pallete1.length;
    for (int i = 0; i < s; i++) {
      scale1.add(GluVal1(pallete1[i], i));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 43,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: scale1,
        ));
  }
}

class GluVal2 extends Container {
  Color col = Colors.black;
  int gv = 0;

  GluVal2(Color c, int g) {
    col = c;
    gv = g;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 8, right: 8),
        child: ColoredCircle2(col, gv));
  }
}

class ColoredCircle1 extends Container {
  Color col = Colors.black;
  String tx = '';
  Scale2 scale2 = Scale2();
  BorderSide bs = BorderSide(width: 1.5, color: AppColors.trans);

  ColoredCircle1(Color c, int t) {
    col = c;
    tx = t.toString();
  }

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
        builder:
            (BuildContext context, MenuController controller, Widget? child) {
          return GestureDetector(
              onTap: () {
                if (controller.isOpen) {
                  controller.close();
                  bs = BorderSide(width: 1.5, color: AppColors.trans);
                } else {
                  controller.open();
                  bs = BorderSide(width: 1.5, color: AppColors.lavender);
                }
              },
              child: Container(
                  decoration: BoxDecoration(border: Border(top: bs)),
                  child: Container(
                      alignment: Alignment.center,
                      width: 20,
                      height: 20,
                      decoration:
                          BoxDecoration(color: col, shape: BoxShape.circle))));
        },
        alignmentOffset: Offset(0, 20),
        menuChildren: scale2.getScale2(),
        style: MenuStyle(
            backgroundColor: MaterialStateProperty.resolveWith((states) {
          return Colors.white;
        }), elevation: MaterialStateProperty.resolveWith((states) {
          return 0;
        }), padding: MaterialStateProperty.resolveWith((states) {
          return EdgeInsets.all(0);
        })));
  }
}

class ColoredCircle2 extends Container {
  Color col = Colors.black;
  BoxDecoration dec = BoxDecoration();
  String tx = '';
  bool isBorder = false;
  Scale2 scale2 = Scale2();

  ColoredCircle2(Color c, int t) {
    col = c;
    tx = t.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        width: 20,
        height: 20,
        decoration: BoxDecoration(
            border: Border.all(color: col, width: 1.5), shape: BoxShape.circle),
        child:
            Text(tx, style: TextStyle(fontFamily: 'Inter-Thin', fontSize: 12)));
  }
}

class GluVal1 extends StatefulWidget {
  Color col = Colors.black;
  int gv = 0;
  GluVal1(Color c, int g) {
    col = c;
    gv = g;
  }

  @override
  State<GluVal1> createState() => _GluVal1State(col, gv);
}

class _GluVal1State extends State<GluVal1> {
  Color col = Colors.black;
  int gv = 0;

  _GluVal1State(Color c, int g) {
    col = c;
    gv = g;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          setState(() {
            print('Hello');
          });
        },
        child: Container(
            padding: EdgeInsets.only(right: 9, left: 9),
            alignment: Alignment.center,
            child: Column(children: [
              ColoredCircle1(col, gv),
              Container(
                  child: Text(gv.toString(),
                      style: TextStyle(fontFamily: 'Inter-Thin', fontSize: 12)))
            ])));
  }
}

class Scale2 {
  List<Widget> scale2 = [];

  Scale2() {
    scale2 = [];
    int s = pallete2.length;
    for (int i = 0; i < s; i++) {
      scale2.add(GluVal2(pallete2[i], i + 1));
    }
  }

  List<Widget> getScale2() {
    List<Widget> scale = [];
    scale.add(Container(
        margin: EdgeInsets.only(right: 5, left: 5),
        alignment: Alignment.center,
        width: 335,
        height: 45,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.mint, width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: scale2,
        )));
    return scale;
  }
}

class Scale22 extends Container {
  List<Widget> scale2 = [];

  Scale22() {
    scale2 = [];
    int s = pallete2.length;
    for (int i = 0; i < s; i++) {
      scale2.add(GluVal2(pallete2[i], i + 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(right: 5, left: 5),
        alignment: Alignment.center,
        width: 335,
        height: 45,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.mint, width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: scale2,
        ));
  }
}
