import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/colors.dart';
import 'dart:core';

import 'package:flutter_app/db.dart';

final dkey = new GlobalKey<_DataFieldState>();

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

List<List<TrackGV>> gvsGlob = getGVArr();

List<List<TrackGV>> getGVArr() {
  List<List<TrackGV>> col = [];
  for (int i = 0; i < 26; i++) {
    List<TrackGV> s = [];
    for (int j = 0; j < 10; j++) {
      s.add(TrackGV(i + j * 0.1));
    }
    col.add(s);
  }
  return col;
}

List<DataletTm> tmCol = getTMArr();

List<DataletTm> getTMArr() {
  List<DataletTm> col = [];
  for (int i = 0; i < 24; i++) {
    if (i < 10) {
      col.add(DataletTm('0' + i.toString() + ':' + '00'));
      col.add(DataletTm('0' + i.toString() + ':' + '30'));
    } else {
      col.add(DataletTm(i.toString() + ':' + '00'));
      col.add(DataletTm(i.toString() + ':' + '30'));
    }
  }
  return col;
}

GlobalKey draggableKey = GlobalKey();
////////////////////////////////////////////////////////////////////////////////////////////////////////

class DataLog extends StatefulWidget {
  const DataLog({super.key});

  @override
  State<DataLog> createState() => _DataLogState();
}

class _DataLogState extends State<DataLog> {
  TopSetDL top = TopSetDL();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.white,
              statusBarIconBrightness: Brightness.dark, // Android dark???
              statusBarBrightness: Brightness.light, // iOS dark???
            ),
            toolbarHeight: 100,
            elevation: 0,
            title: Column(children: [TopSetDL(), Scale1()])),
        body: DataField(key: dkey),
        floatingActionButton: FloatingActionButton.small(
            onPressed: () {
              setState(() {
                print('Helo');
                dkey.currentState?.pushVals();
              });
            },
            backgroundColor: AppColors.mint,
            child: const Icon(Icons.add)));
  }
}

class DataField extends StatefulWidget {
  DataField({required Key key}) : super(key: key);
  @override
  State<DataField> createState() => _DataFieldState();
}

class _DataFieldState extends State<DataField> {
  List<DataletGV> gvCol = [];
  List<TrackTmGV> tmgvs = [];
  List<DragTarget<TrackGV>> dragt = [];
  DatabaseHelper databaseHelper = DatabaseHelper();

  _DataFieldState() {
    //databaseHelper.init();
    //databaseHelper.deleteDatabase();
    databaseHelper.init();
    tmgvs = getTMGVArr();
    gvCol.add(DataletGV(tmgvs.elementAt(0), 50, false, false));
    for (int i = 1; i < tmgvs.length; i++) {
      gvCol.add(DataletGV(tmgvs.elementAt(i), 0, false, false));
    }
  }

  void change(int pos) async {
    DateTime time = DateTime.now();
    DateTime this_date =
        DateTime(time.year, time.month, time.day, 0, 0, 0, 0, 0);
    if (pos != 0) {
      if (pos > 0) {
        this_date = this_date.subtract(Duration(days: pos));
      } else {
        this_date = this_date.add(Duration(days: -pos));
      }
    }
    List<Map<String, dynamic>> listmaps =
        await databaseHelper.selectGV(this_date.toIso8601String());
    setState(() {
      if (listmaps.length != 0) {
        if (listmaps.length != tmgvs.length) {
          print(listmaps.length);
          print('ПРИКИНЬ ЧЕЕЕЕ');
        }
      } else {
        for (int i = 0; i < tmgvs.length; i++) {
          tmgvs[i].nulled();
        }

        for (int i = 0; i < listmaps.length; i++) {
          TrackTmGV s = TrackTmGV.fromMapObject(listmaps[i]);
          tmgvs[i] = s;
        }
      }
    });
  }

  void pushVals() {
    setState(() {
      for (int i = 0; i < tmgvs.length; i++) {
        databaseHelper.insert(tmgvs[i]);
      }

      print(databaseHelper.queryAllRowsGV().toString());
    });
  }

  List<TrackTmGV> getTMGVArr() {
    List<TrackTmGV> col = [];
    DateTime time = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, 0, 0, 0, 0, 0);

    col.add(TrackTmGV(time));
    time = time.add(Duration(minutes: 30));
    col.add(TrackTmGV(time));
    for (int i = 1; i < 24; i++) {
      time = time.add(Duration(minutes: 30));
      col.add(TrackTmGV(time));
      time = time.add(Duration(minutes: 30));
      col.add(TrackTmGV(time));
    }
    return col;
  }

  void dropGV(TrackGV gv, TrackTmGV tmgv) {
    setState(() {
      tmgv.replace(gv);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(right: 10),
        color: Colors.white,
        child: SingleChildScrollView(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
              Column(children: tmCol),
              Column(children: tmgvs.map(DropZone).toList())
            ])));
  }

  Widget DropZone(TrackTmGV trackC) {
    return DragTarget<TrackGV>(
        builder: (context, candidateItems, rejectedItems) {
      return DataletGV(
        trackC,
        0,
        candidateItems.isNotEmpty,
        trackC.listOfGV.isNotEmpty,
      );
    }, onAccept: (item) {
      dropGV(
        item,
        trackC,
      );
    });
  }
}

List<Widget> Scale2(List<TrackGV> gvs) {
  List<Widget> scale2 = [];
  List<Widget> scale = [];

  int s = pallete2.length;
  for (int i = 0; i < s; i++) {
    scale2.add(buildGV(pallete2[i], gvs[i]));
  }

  scale.add(Container(
      margin: EdgeInsets.only(right: 5, left: 5),
      alignment: Alignment.center,
      width: 385,
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

Widget buildGV(Color color, TrackGV item) {
  return LongPressDraggable<TrackGV>(
    data: item,
    dragAnchorStrategy: pointerDragAnchorStrategy,
    feedback: DraggingGV(draggableKey),
    child: GluVal2(color, item),
  );
}

class DraggingGV extends StatelessWidget {
  GlobalKey dragKey = GlobalKey();

  DraggingGV(this.dragKey);

  @override
  Widget build(BuildContext context) {
    return FractionalTranslation(
      translation: const Offset(-1, -1),
      child: ClipRRect(
        key: dragKey,
        borderRadius: BorderRadius.circular(20),
        child: Container(width: 40, height: 40, color: Colors.red),
      ),
    );
  }
}

class DataletTm extends Container {
  String tx = '';

  DataletTm(String tx) {
    this.tx = tx;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 5),
        alignment: Alignment.center,
        height: 50,
        width: MediaQuery.of(context).size.width * 0.15,
        child: Text(tx,
            style: TextStyle(
                fontFamily: 'Inter-Thin', fontSize: 16, color: Colors.black)));
  }
}

class DataletGV extends StatelessWidget {
  TrackTmGV trackTmGV = TrackTmGV(DateTime.now());
  double offset = 0;
  bool highlighted = false;
  bool hasItems = false;
  DataletGV(this.trackTmGV, this.offset, this.highlighted, this.hasItems);

  @override
  Widget build(BuildContext context) {
    Color textColor = highlighted ? Colors.white : Colors.black;

    return Transform.scale(
        scale: highlighted ? 1.075 : 1.0,
        child: Container(
            margin: EdgeInsets.only(bottom: 5, top: offset),
            height: 50,
            width: MediaQuery.of(context).size.width * 0.6,
            decoration: BoxDecoration(
                border: Border.all(
                    width: 1,
                    color:
                        highlighted ? const Color(0xFFF64209) : Colors.green)),
            child: Visibility(
                visible: hasItems,
                maintainState: true,
                maintainAnimation: true,
                maintainSize: true,
                child: Container(
                    alignment: Alignment.centerLeft,
                    height: 50,
                    child: Text(
                      hasItems ? trackTmGV.listOfGV[0].toString() : '',
                      style: TextStyle(
                          color: textColor,
                          fontSize: 16,
                          fontFamily: 'Inter-Thin'),
                    )))));
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
      DateTime time = DateTime.now();
      DateTime this_date =
          DateTime(time.year, time.month, time.day, 0, 0, 0, 0, 0);
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
                      dkey.currentState?.change(pos);
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
                      dkey.currentState?.change(pos);
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
      scale1.add(GluVal1(pallete1[i], gvsGlob[i]));
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

class ColoredCircle1 extends Container {
  Color col = Colors.black;
  String tx = '';

  ColoredCircle1(this.col, int t) {
    tx = t.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Container(
            alignment: Alignment.center,
            width: 20,
            height: 20,
            decoration: BoxDecoration(color: col, shape: BoxShape.circle)));
  }
}

class ColoredCircle2 extends Container {
  Color col = Colors.black;
  BoxDecoration dec = BoxDecoration();
  String tx = '';
  bool isBorder = false;

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
  List<TrackGV> gvs = [];

  GluVal1(this.col, this.gvs);

  @override
  State<GluVal1> createState() => _GluVal1State(col, gvs);
}

class _GluVal1State extends State<GluVal1> {
  Color col = Colors.black;
  List<TrackGV> gvs = gvsGlob[0];
  List<Widget> scale2 = Scale2(gvsGlob[0]);
  BorderSide bs = BorderSide(width: 1.5, color: AppColors.trans);

  _GluVal1State(this.col, List<TrackGV> Gvs) {
    gvs = Gvs;
    scale2 = Scale2(Gvs);
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
                  padding: EdgeInsets.only(right: 9, left: 9),
                  alignment: Alignment.center,
                  child: Column(children: [
                    ColoredCircle1(col, gvs[0].GV1),
                    Text(gvs[0].GV1.toString(),
                        style: TextStyle(
                            fontFamily: 'Inter-Thin',
                            fontSize: 12,
                            color: Colors.black))
                  ])));
        },
        alignmentOffset: Offset(0, 20),
        menuChildren: scale2,
        style: MenuStyle(
            alignment: Alignment.center,
            backgroundColor: MaterialStateProperty.resolveWith((states) {
              return Colors.white;
            }),
            elevation: MaterialStateProperty.resolveWith((states) {
              return 0;
            }),
            padding: MaterialStateProperty.resolveWith((states) {
              return EdgeInsets.all(0);
            })));
  }
}

class GluVal2 extends StatelessWidget {
  Color color = Colors.black;
  TrackGV trackGV = TrackGV(0);

  GluVal2(this.color, this.trackGV);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 8, right: 8),
        child: ColoredCircle2(color, trackGV.GV2));
  }
}

class TrackGV {
  double GV = 0.0;
  int GV1 = 0;
  int GV2 = 0;

  TrackGV(this.GV) {
    GV1 = GV.floor();
    double g = ((GV - GV1.toDouble()) * 10);
    GV2 = g.round();
  }

  String toString() {
    return GV.toString();
  }
}

class TrackTmGV {
  int id = -1;

  int month = -1;
  String date = '';
  int hour = -1;
  int minute = -1;

  double gluval = -1;

  DateTime time = DateTime.now();

  TrackTmGV(this.time) {
    date = DateTime(time.year, time.month, time.day, 0, 0, 0, 0, 0)
        .toIso8601String();
    month = time.month;
    hour = time.hour;
    minute = time.minute;
  }

  List<TrackGV> listOfGV = [];

  void nulled() {
    listOfGV = [];
  }

  String toString() {
    return '$id||$date||$hour||$minute||$listOfGV';
  }

  void replace(TrackGV newgV) {
    if (listOfGV.isEmpty) {
      listOfGV.add(newgV);
      gluval = newgV.GV;
    } else {
      listOfGV[0] = newgV;
      gluval = newgV.GV;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'month': month,
      'hour': hour,
      'minute': minute,
      'glucose_val': gluval
    };
  }

  TrackTmGV.fromMapObject(Map<String, dynamic> map) {
    print(map.toString());
    id = map['id'];
    date = map['date'];
    month = map['month'];
    hour = map['hour'];
    minute = map['minute'];
    gluval = map['glucose_val'];

    DateTime time_ini = DateTime.parse(date);
    time = DateTime(
        time_ini.year, time_ini.month, time_ini.day, hour, minute, 0, 0, 0);
    replace(TrackGV(gluval));
  }
}
