// ignore_for_file: avoid_print, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/assets/colors.dart';
import 'package:flutter_app/server/models/TrackTmGV.dart';
import 'package:flutter_app/server/models/TrackGV.dart';
import 'dart:core';
import 'package:flutter_app/main.dart';

GlobalKey<_DataFieldState> dkey = GlobalKey<_DataFieldState>();
GlobalKey<_DataLogState> lkey = GlobalKey<_DataLogState>();

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
int _g_pos_data = 0;

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
      col.add(DataletTm('0$i:00'));
      col.add(DataletTm('0$i:30'));
    } else {
      col.add(DataletTm('$i:00'));
      col.add(DataletTm('$i:30'));
    }
  }
  return col;
}

GlobalKey tgableKey = GlobalKey();
GlobalKey draggableKey = GlobalKey();

////////////////////////////////////////////////////////////////////////////////////////////////////////

class DataLog extends StatefulWidget {
  const DataLog({required Key key}) : super(key: key);

  @override
  State<DataLog> createState() => _DataLogState();
}

class _DataLogState extends State<DataLog> {
  TopSetDL top = const TopSetDL();
  bool isChanged = false;

  void setIsChanged(bool newChanged) {
    setState(() {
      isChanged = newChanged;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.white,
              statusBarIconBrightness: Brightness.dark, // Android dark???
              statusBarBrightness: Brightness.light, // iOS dark???
            ),
            toolbarHeight: 0,
            elevation: 0),
        body: Stack(children: <Widget>[
          DataField(key: dkey),
          Container(
              height: 110,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(12)),
                boxShadow: [
                  BoxShadow(
                      color: Color.fromRGBO(149, 157, 165, 0.1),
                      offset: Offset.zero,
                      spreadRadius: 4,
                      blurRadius: 10)
                ],
              ),
              child: Column(children: [const TopSetDL(), Scale1()]))
        ]),
        floatingActionButton: FloatingActionButton(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            backgroundColor: isChanged ? AppColors.mint : AppColors.text_sub,
            onPressed: () {
              setState(() {
                dkey.currentState?.pushVals();
              });
            },
            child: isChanged
                ? const Icon(Icons.add_task_outlined)
                : const Icon(Icons.task_alt)));
  }
}

class DataField extends StatefulWidget {
  const DataField({required Key key}) : super(key: key);

  @override
  State<DataField> createState() => _DataFieldState(true);
}

class _DataFieldState extends State<DataField> {
  List<DataletGV> gvCol = [];
  List<TrackTmGV> tmgvs = [];
  List<DragTarget<TrackGV>> dragt = [];
  int position = 0;
  bool isChanged = false;

  bool load = false;

  _DataFieldState(this.load) {
    tmgvs = getTMGVArr(DateTime.now());
    gvCol.add(DataletGV(tmgvs.elementAt(0), 50, false, false));
    for (int i = 1; i < tmgvs.length; i++) {
      gvCol.add(DataletGV(tmgvs.elementAt(i), 0, false, false));
    }

    if (load) {
      load = false;
      loadData();
    }
  }

  void loadData() async {
    List<TrackTmGV> listmaps = await databaseHelperGV
        .selectDay(DateTime.now().add(Duration(days: _g_pos_data)));

    setState(() {
      if (listmaps.isNotEmpty) {
        for (TrackTmGV i in listmaps) {
          int add = 0;
          if (i.minute == 30) {
            add = 1;
          }
          tmgvs[i.hour * 2 + add] = i;
        }
      }

      gvCol = [];
      gvCol.add(DataletGV(tmgvs.elementAt(0), 50, false, false));
      for (int i = 1; i < tmgvs.length; i++) {
        gvCol.add(DataletGV(tmgvs.elementAt(i), 0, false, false));
      }
    });
  }

  void change() async {
    DateTime thisDate = DateTime.now().add(Duration(days: _g_pos_data));

    setState(() {
      tmgvs = getTMGVArr(thisDate);
    });

    List<TrackTmGV> listmaps = await databaseHelperGV.selectDay(thisDate);

    setState(() {
      if (listmaps.isNotEmpty) {
        for (TrackTmGV i in listmaps) {
          int add = 0;
          if (i.minute == 30) {
            add = 1;
          }
          tmgvs[i.hour * 2 + add] = i;
        }
      }

      gvCol = [];
      gvCol.add(DataletGV(tmgvs.elementAt(0), 50, false, false));
      for (int i = 1; i < tmgvs.length; i++) {
        gvCol.add(DataletGV(tmgvs.elementAt(i), 0, false, false));
      }
    });
  }

  void pushVals() async {
    if (isChanged) {
      print("pushVals");
      DateTime thisDate = DateTime.now().add(Duration(days: _g_pos_data));

      List<TrackTmGV> listmaps = await databaseHelperGV.selectDay(thisDate);
      print(['listmaps', listmaps]);
      for (TrackTmGV i in listmaps) {
        databaseHelperGV.deleteTmGV(i.id);
      }

      setState(() {
        for (int i = 0; i < tmgvs.length; i++) {
          if (tmgvs[i].isGV == true) {
            databaseHelperGV.insert(tmgvs[i]);
          }
        }
        isChanged = false;
        lkey.currentState?.setIsChanged(false);
      });
    }
  }

  List<TrackTmGV> getTMGVArr(DateTime time) {
    List<TrackTmGV> col = [];
    DateTime thisTime = DateTime(time.year, time.month, time.day);

    col.add(TrackTmGV.empty(thisTime));
    thisTime = thisTime.add(const Duration(minutes: 30));
    col.add(TrackTmGV.empty(thisTime));
    for (int i = 1; i < 24; i++) {
      thisTime = thisTime.add(const Duration(minutes: 30));
      col.add(TrackTmGV.empty(thisTime));
      thisTime = thisTime.add(const Duration(minutes: 30));
      col.add(TrackTmGV.empty(thisTime));
    }
    return col;
  }

  void dropGV(TrackGV gv, TrackTmGV tmgv) {
    setState(() {
      isChanged = true;
      lkey.currentState?.setIsChanged(true);
      tmgv.setGV(gv);
    });
  }

  void deleteGV(TrackTmGV tmgv) {
    setState(() {
      isChanged = true;
      lkey.currentState?.setIsChanged(true);
      int index = tmgv.hour * 2;
      if (tmgv.minute > 0) {
        index = index + 1;
      }
      print(gvCol[index].trackTmGV.toString());
      gvCol[index].trackTmGV.nulled();
      print(gvCol[index].trackTmGV.toString());
    });
  }

  Widget buildRow(BuildContext context, int index) {
    if (index == -1) {
      return Container(height: 179);
    } else {
      return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [tmCol[index], tmgvs.map(DropZone).toList()[index]]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: AppColors.background,
        child: ListView.builder(
          controller: ScrollController(
            initialScrollOffset: 900.0,
            keepScrollOffset: false,
          ),
          itemCount: 49,
          itemBuilder: (BuildContext context, int index) {
            return buildRow(context, index - 1);
          },
        ));
  }

  Widget DropZone(TrackTmGV trackC) {
    return DragTarget<TrackGV>(
        builder: (context, candidateItems, rejectedItems) {
      double offset = 0;
      if (trackC.hour == 0 && trackC.minute == 0) {
        offset = 0;
      }
      return DataletGV(
        trackC,
        offset,
        candidateItems.isNotEmpty,
        trackC.isGV,
      );
    }, onAccept: (item) {
      dropGV(
        item,
        trackC,
      );
    });
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
    if (_g_pos_data == 0) {
      tx = 'Today';
    } else if (_g_pos_data == -1) {
      tx = 'Yesterday';
    } else {
      DateTime thisDate = DateTime.now().add(Duration(days: _g_pos_data));
      tx = '${months[thisDate.month - 1]} ${thisDate.day}';
    }
    return tx;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        decoration: const BoxDecoration(color: Colors.white),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              color: Colors.black,
              onPressed: () {
                setState(() {
                  _g_pos_data--;
                  dkey.currentState?.change();
                });
              }),
          Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width * 0.5,
              child: Text(getTx(),
                  style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'Inter-Medium',
                      fontSize: 16))),
          IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              color: Colors.black,
              onPressed: () {
                setState(() {
                  _g_pos_data++;
                  dkey.currentState?.change();
                });
              }),
        ]));
  }
}

List<Widget> Scale2(List<TrackGV> gvs) {
  List<Widget> scale2 = [];
  //List<Widget> scale = [];

  int s = pallete2.length;
  for (int i = 0; i < s; i++) {
    scale2.add(buildGV(pallete2[i], gvs[i]));
  }

  return scale2;
}

Widget buildGV(Color color, TrackGV item) {
  return LongPressDraggable<TrackGV>(
    data: item,
    dragAnchorStrategy: pointerDragAnchorStrategy,
    feedback: DraggingGV(draggableKey, '${item.GV1}.${item.GV2}', color),
    child: GluVal2(color, item),
  );
}

class DraggingGV extends StatelessWidget {
  const DraggingGV(this.dragKey, this.GV, this.color, {super.key});
  final GlobalKey dragKey;
  final String GV;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return FractionalTranslation(
        translation: const Offset(-1, -1),
        child: Container(
            key: dragKey,
            alignment: Alignment.center,
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: color, width: 3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: DefaultTextStyle(
                style: const TextStyle(
                    color: Colors.black,
                    fontFamily: 'Inter-Thin',
                    fontSize: 14),
                child: Text(GV))));
  }
}

class DataletTm extends Container {
  DataletTm(this.tx, {super.key});

  final String tx;

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        height: 60,
        width: MediaQuery.of(context).size.width * 0.15,
        child: Text(tx,
            style: const TextStyle(
                fontFamily: 'Inter-Thin', fontSize: 16, color: Colors.black)));
  }
}

class DataletGV extends StatelessWidget {
  const DataletGV(this.trackTmGV, this.offset, this.highlighted, this.hasItems,
      {super.key});
  final TrackTmGV trackTmGV;
  final double offset;
  final bool highlighted;
  final bool hasItems;
  //Widget child = Widget();

  @override
  Widget build(BuildContext context) {
    //Color textColor = highlighted ? Colors.white : Colors.black;
    MenuController controller1 = MenuController();
    return Transform.scale(
        scale: highlighted ? 1.0 : 1.0,
        child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: offset),
            height: 60,
            width: 50,
            decoration: BoxDecoration(
                color: Colors.white, //AppColors.lavender_light,
                border: Border(
                    left: BorderSide(
                        width: highlighted ? 2.0 : 1.0,
                        color: highlighted
                            ? const Color(0xFFF64209)
                            : AppColors.lavender_light),
                    right: BorderSide(
                        width: highlighted ? 2.0 : 1.0,
                        color: highlighted
                            ? const Color(0xFFF64209)
                            : AppColors.lavender_light))),
            child: Visibility(
                visible: hasItems,
                maintainState: true,
                maintainAnimation: true,
                maintainSize: true,
                child: Stack(alignment: Alignment.center, children: [
                  MenuAnchor(
                      onOpen: () {
                        //setState(() {});
                      },
                      onClose: () {
                        //setState(() {});
                      },
                      builder: (BuildContext context, MenuController controller,
                          Widget? child) {
                        controller1 = controller;
                        return GestureDetector(
                            onLongPress: () {
                              print('long press!');
                              if (controller.isOpen) {
                                controller.close();
                              } else {
                                controller.open();
                              }
                            },
                            child: ColoredCircle2(
                                hasItems
                                    ? pallete2[trackTmGV.gluval.GV2]
                                    : AppColors.trans,
                                hasItems ? trackTmGV.gluval.toString() : ''));
                      },
                      alignmentOffset: const Offset(-18, -18),
                      menuChildren: [
                        GestureDetector(
                            onTap: () {
                              if (controller1.isOpen) {
                                print('delete! NEW');
                                print(trackTmGV.gluval);
                                print('0');
                                dkey.currentState?.deleteGV(trackTmGV);
                                controller1.close();
                              }
                            },
                            child: Container(
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(25)),
                                alignment: Alignment.center,
                                child: const Icon(Icons.close,
                                    color: Colors.white)))
                      ],
                      style: const MenuStyle(
                          elevation: MaterialStatePropertyAll<double>(0),
                          backgroundColor:
                              MaterialStatePropertyAll<Color>(AppColors.trans),
                          shape: MaterialStatePropertyAll<OutlinedBorder>(
                              RoundedRectangleBorder()),
                          alignment: AlignmentDirectional.center,
                          //side:
                          padding: MaterialStatePropertyAll<EdgeInsets>(
                              EdgeInsets.only(left: 0)),
                          fixedSize:
                              MaterialStatePropertyAll<Size>(Size(50, 50)),
                          maximumSize:
                              MaterialStatePropertyAll<Size>(Size(50, 100))))
                ]))));
  }
}

Widget Scale1() {
  List<GluVal1> scale1 = [];

  int s = pallete1.length;
  for (int i = 0; i < s; i++) {
    scale1.add(GluVal1(pallete1[i], gvsGlob[i]));
  }
  return SizedBox(
      height: 48,
      child: ListView(
        controller: ScrollController(
          initialScrollOffset: 160.0,
          keepScrollOffset: false,
        ),
        scrollDirection: Axis.horizontal,
        children: scale1,
      ));
}

Widget ColoredCircle1(Color col, int t) {
  return Container(
      alignment: Alignment.center,
      width: 30,
      height: 30,
      decoration: BoxDecoration(color: col, shape: BoxShape.circle));
}

Widget ColoredCircle2(Color col, String tx) {
  return Container(
      alignment: Alignment.center,
      width: 35,
      height: 35,
      decoration: BoxDecoration(
        border: Border.all(color: col, width: 1.5),
        shape: BoxShape.circle,
      ),
      child: Text(tx,
          style: const TextStyle(fontFamily: 'Inter-Thin', fontSize: 12)));
}

class GluVal1 extends StatefulWidget {
  const GluVal1(this.col, this.gvs, {super.key});
  final Color col;
  final List<TrackGV> gvs;

  @override
  State<GluVal1> createState() => _GluVal1State(col, gvs);
}

class _GluVal1State extends State<GluVal1> {
  Color col = Colors.black;
  List<TrackGV> gvs = gvsGlob[0];
  List<Widget> scale2 = Scale2(gvsGlob[0]);
  BorderSide bs = const BorderSide(width: 1.5, color: AppColors.trans);

  _GluVal1State(this.col, List<TrackGV> Gvs) {
    gvs = Gvs;
    scale2 = Scale2(Gvs);
  }
  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
        onOpen: () {
          setState(() {
            bs = const BorderSide(width: 1.5, color: AppColors.lavender);
          });
        },
        onClose: () {
          setState(() {
            bs = const BorderSide(width: 1.5, color: AppColors.trans);
          });
        },
        builder:
            (BuildContext context, MenuController controller, Widget? child) {
          return GestureDetector(
              onTap: () {
                if (controller.isOpen) {
                  controller.close();
                } else {
                  controller.open();
                }
              },
              child: Container(
                  decoration: BoxDecoration(border: Border(top: bs)),
                  margin: const EdgeInsets.only(right: 11, left: 11),
                  alignment: Alignment.center,
                  child: Column(children: [
                    ColoredCircle1(col, gvs[0].GV1),
                    Text(gvs[0].GV1.toString(),
                        style: const TextStyle(
                            fontFamily: 'Inter-Thin',
                            fontSize: 12,
                            color: Colors.black))
                  ])));
        },
        alignmentOffset: const Offset(0, 55),
        menuChildren: [
          Container(
              height: 50,
              padding: const EdgeInsets.only(left: 8, right: 10),
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                color: AppColors.lavender_light,
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListView(
                  controller: ScrollController(
                    initialScrollOffset: 100.0,
                    keepScrollOffset: false,
                  ),
                  scrollDirection: Axis.horizontal,
                  children: scale2))
        ],
        style: MenuStyle(
            elevation: const MaterialStatePropertyAll<double>(8),
            shadowColor: const MaterialStatePropertyAll<Color>(
                Color.fromRGBO(149, 157, 165, 0.2)),
            backgroundColor:
                const MaterialStatePropertyAll<Color>(AppColors.trans),
            shape: const MaterialStatePropertyAll<OutlinedBorder>(
                RoundedRectangleBorder()),
            alignment: AlignmentDirectional.center,
            //side:
            padding: const MaterialStatePropertyAll<EdgeInsets>(
                EdgeInsets.only(left: 0)),
            fixedSize: MaterialStatePropertyAll<Size>(
                Size(MediaQuery.of(context).size.width * 2, 50)),
            maximumSize: MaterialStatePropertyAll<Size>(
                Size(MediaQuery.of(context).size.width * 2, 100))));
  }
}

Widget GluVal2(Color color, TrackGV trackGV) {
  return Container(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: ColoredCircle2(color, '${trackGV.GV1}.${trackGV.GV2}'));
}
