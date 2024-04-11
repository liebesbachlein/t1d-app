// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:core';

import 'package:flutter_app/assets/colors.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/server/models/TrackGV.dart';
import 'package:flutter_app/server/models/TrackTmGV.dart';

//final dataLogKey = GlobalKey<_DataViewState>();
Map dataLogKey = <int, GlobalKey<_DataViewState>>{};
GlobalKey draggableKey = GlobalKey();

const List<List<int>> list_hours = [
  [23, 59],
  [21, 0],
  [18, 0],
  [15, 0],
  [12, 0],
  [9, 0],
  [6, 0],
  [0, 0]
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

class DataPrototype extends StatefulWidget {
  const DataPrototype({super.key});

  @override
  State<DataPrototype> createState() => _DataPrototypeState();
}

class _DataPrototypeState extends State<DataPrototype> {
  Widget buildDataView(BuildContext context, int position) {
    GlobalKey<_DataViewState> key = GlobalKey<_DataViewState>();
    dataLogKey.putIfAbsent(position, () => key);
    return DataView(key: dataLogKey[position], position: position);
  }

  final ScrollController _controller = ScrollController();
  int curIndex = 0;
  late List<List<TrackGV>> fixedGlucoseValues;
  late List<Color> upperPallete;

  @override
  void initState() {
    _controller.addListener(() {
      List<int> indeces = [];
      for (int i = 0; i < dataLogKey.length; i++) {
        int index = dataLogKey[i].currentState?.position ?? -1;
        if (index != -1) {
          indeces.add(index);
        }
      }
      int newIndex = indeces.length == 1 ? 0 : indeces[indeces.length - 2];
      if (newIndex != curIndex) {
        setState(() {
          curIndex = newIndex;
        });
      }
    });

    fixedGlucoseValues = [];
    for (int i = 0; i < 26; i++) {
      List<TrackGV> list = [];
      for (int j = 0; j < 10; j++) {
        list.add(TrackGV(i + j * 0.1));
      }
      fixedGlucoseValues.add(list);
    }

    upperPallete = [];
    for (int i in AppColors.hex_colors_upper) {
      upperPallete.add(Color(i));
    }

    super.initState();
  }

  String getCurDate() {
    if (curIndex == 0) {
      return 'Today';
    }

    DateTime dateNow = DateTime.now().subtract(Duration(days: curIndex));
    if (dateNow.year == DateTime.now().year) {
      return '${months[dateNow.month - 1]} ${dateNow.day}';
    } else {
      return '${dateNow.day}${dateNow.month}/${dateNow.year}';
    }
  }

  @override
  void dispose() {
    // dispose stuff later
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
            backgroundColor: Colors.white,
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.white,
              statusBarIconBrightness: Brightness.dark, // Android dark???
              statusBarBrightness: Brightness.light, // iOS dark???
            ),
            toolbarHeight: 0,
            elevation: 0),
        body: Stack(children: [
          ListView.builder(
              // what about changing to SilverList bc LV is slow ???
              controller: _controller,
              reverse: true,
              itemBuilder: (BuildContext context, int index) {
                return buildDataView(context, index);
              }),
          buildUpperScale()
        ]),
        floatingActionButton: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                      color: Color.fromARGB(30, 205, 194, 237),
                      offset: Offset(2, 2),
                      blurRadius: 4,
                      spreadRadius: 2),
                  BoxShadow(
                      color: Color.fromARGB(30, 205, 194, 237),
                      offset: Offset(-2, -2),
                      blurRadius: 4,
                      spreadRadius: 2)
                ]),
            child: Text(getCurDate(),
                style: const TextStyle(
                    color: Colors.black,
                    fontFamily: 'Inter-Thin',
                    fontSize: 14))));
  }

  Widget buildUpperScale() {
    List<GlucoseUpper> upperScale = [];

    for (int i = 0; i < upperPallete.length; i++) {
      upperScale.add(GlucoseUpper(upperPallete[i], fixedGlucoseValues[i]));
    }
    return Container(
        height: 70,
        decoration: const BoxDecoration(color: Colors.white),
        padding: const EdgeInsets.only(top: 16),
        child: ListView(
          controller: ScrollController(
            initialScrollOffset: 160.0,
            keepScrollOffset: false,
          ),
          scrollDirection: Axis.horizontal,
          children: upperScale,
        ));
  }
}

Widget buildOutlinedCircle(Color color, String value) {
  return Container(
      alignment: Alignment.center,
      width: 35,
      height: 35,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 254, 251, 255),
        border: Border.all(color: color, width: 1.5),
        shape: BoxShape.circle,
      ),
      child: Text(value,
          style: const TextStyle(fontFamily: 'Inter-Thin', fontSize: 12)));
}

class GlucoseUpper extends StatefulWidget {
  final Color color;
  final List<TrackGV> glucoseValues;
  const GlucoseUpper(this.color, this.glucoseValues, {super.key});

  @override
  State<GlucoseUpper> createState() => _GlucoseUpperState();
}

class _GlucoseUpperState extends State<GlucoseUpper> {
  late Color color;
  late List<TrackGV> glucoseValues;
  late List<Widget> lowerScale;
  late List<Color> lowerPallete;

  BorderSide bs = const BorderSide(width: 1.5, color: AppColors.trans);

  @override
  void initState() {
    super.initState();
    color = widget.color;
    glucoseValues = widget.glucoseValues;
    lowerPallete = [];
    for (int i in AppColors.hex_colors_lower) {
      lowerPallete.add(Color(i));
    }
    lowerScale = buildLowerScale(glucoseValues);
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
                    buildFilledCircle(color, glucoseValues[0].GV1),
                    Text(glucoseValues[0].GV1.toString(),
                        style: const TextStyle(
                            fontFamily: 'Inter-Thin',
                            fontSize: 12,
                            color: Colors.black))
                  ])));
        },
        alignmentOffset: const Offset(0, 32),
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
                  children: lowerScale))
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

  List<Widget> buildLowerScale(List<TrackGV> gvs) {
    List<Widget> lowerScale = [];

    for (int i = 0; i < lowerPallete.length; i++) {
      lowerScale.add(buildGlucoseLower(lowerPallete[i], gvs[i]));
    }

    return lowerScale;
  }

  Widget buildGlucoseLower(Color color, TrackGV trackGV) {
    return LongPressDraggable<TrackGV>(
      data: trackGV,
      dragAnchorStrategy: pointerDragAnchorStrategy,
      feedback:
          DraggingGlucose(draggableKey, '${trackGV.GV1}.${trackGV.GV2}', color),
      child: Container(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: buildOutlinedCircle(color, '${trackGV.GV1}.${trackGV.GV2}')),
    );
  }

  Widget buildFilledCircle(Color color, int value) {
    return Container(
        alignment: Alignment.center,
        width: 30,
        height: 30,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle));
  }
}

class DraggingGlucose extends StatelessWidget {
  const DraggingGlucose(this.dragKey, this.glucoseValue, this.color,
      {super.key});
  final GlobalKey dragKey;
  final String glucoseValue;
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
                child: Text(glucoseValue))));
  }
}

class DataView extends StatefulWidget {
  final int position;
  const DataView({required Key key, required this.position}) : super(key: key);

  @override
  State<DataView> createState() => _DataViewState();
}

class _DataViewState extends State<DataView> {
  late int position;
  late DateTime dateNow;
  late List<List<int>> LIST_HOURS;
  late List<double> LIST_GLUCOSE;
  late List<String> LIST_ID;
  late Map<int, TrackGV> timeToGlucoseMap;
  late Map<int, String> timeToIdMap;

  @override
  void initState() {
    LIST_HOURS = [];
    LIST_GLUCOSE = [];
    LIST_ID = [];
    position = widget.position;
    dateNow = DateTime.now().subtract(Duration(days: position));
    loadData();
    super.initState();
  }

  void loadData() async {
    List<TrackTmGV> dataList = await databaseHelperGV.selectDay(dateNow);
    timeToGlucoseMap = {};
    timeToIdMap = {};
    for (TrackTmGV i in dataList) {
      timeToGlucoseMap.putIfAbsent(i.hour * 60 + i.minute, () => i.gluval);
      timeToIdMap.putIfAbsent(i.hour * 60 + i.minute, () => i.id);
    }
    setState(() {});
  }

  void acceptNewGlucoseValue(TrackGV newValue, int hours, int minutes) {
    TrackTmGV newData = TrackTmGV.create(
        DateTime(dateNow.year, dateNow.month, dateNow.day, hours, minutes),
        newValue);
    databaseHelperGV.insert(newData);
    setState(() {
      timeToGlucoseMap.update(hours * 60 + minutes, (value) => newValue,
          ifAbsent: () => newValue);
      timeToIdMap.update(hours * 60 + minutes, (value) => newData.id,
          ifAbsent: () => newData.id);
    });
  }

  void deleteGlucoseValue(String id, int hours, int minutes) {
    /*String newId = timeToIdMap[hours * 60 + minutes] ?? '';
    if (newId != '') {
      
      databaseHelperGV.deleteTmGV(id);
    }*/

    databaseHelperGV.deleteTmGV(id);
    timeToGlucoseMap.remove(hours * 60 + minutes);
    timeToIdMap.remove(hours * 60 + minutes);
    loadData();
    setState(() {});
  }

  Widget buildRow(BuildContext context, int index) {
    DateTime template = DateTime(dateNow.year, dateNow.month, dateNow.day);
    DateTime timeStampStart = template.add(Duration(
        hours: LIST_HOURS[index + 1][0], minutes: LIST_HOURS[index + 1][1]));
    DateTime timeStampEnd = template.add(
        Duration(hours: LIST_HOURS[index][0], minutes: LIST_HOURS[index][1]));
    if (position == 0) {
      if ((timeStampEnd.millisecondsSinceEpoch >=
              DateTime.now().millisecondsSinceEpoch) ||
          DateTime.now().millisecondsSinceEpoch -
                  timeStampEnd.millisecondsSinceEpoch <
              const Duration(minutes: 15).inMilliseconds) {
        return TimeBlock(
            glucoseId: LIST_ID[index],
            glucoseValue: TrackGV(LIST_GLUCOSE[index]),
            timeBorders: TimeBorders(timeStampStart, DateTime.now()),
            isNow: true,
            idx: index,
            position: position);
      }
    }

    return TimeBlock(
        glucoseId: LIST_ID[index],
        glucoseValue: TrackGV(LIST_GLUCOSE[index]),
        timeBorders: TimeBorders(timeStampStart, timeStampEnd),
        isNow: false,
        idx: index,
        position: position);
  }

  void insertTimeBlock(TimeBorders newBorders, bool isNow, int index) {
    setState(() {
      LIST_HOURS
          .insert(index + 1, [newBorders.start.hour, newBorders.start.minute]);
    });
  }

  void removeTimeBlock(int idx) {
    setState(() {
      LIST_HOURS.removeAt(idx);
    });
  }

  int getListLength() {
    DateTime template =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    if (LIST_HOURS.isEmpty) {
      for (int i = list_hours.length - 1; i >= 0; i--) {
        DateTime timeStamp = template
            .add(Duration(hours: list_hours[i][0], minutes: list_hours[i][1]));
        if (position == 0) {
          if (timeStamp.millisecondsSinceEpoch >=
                  DateTime.now().millisecondsSinceEpoch ||
              DateTime.now().millisecondsSinceEpoch -
                      timeStamp.millisecondsSinceEpoch <
                  const Duration(minutes: 15).inMilliseconds) {
            LIST_HOURS.add([DateTime.now().hour, DateTime.now().minute]);
            if (LIST_HOURS.length == 1 && !LIST_HOURS.contains([0, 0])) {
              LIST_HOURS.add([0, 0]);
              fillGlucoseValues();
              return LIST_HOURS.length;
            }
            LIST_HOURS = LIST_HOURS.reversed.toList();
            fillGlucoseValues();
            return LIST_HOURS.length - 1;
          }
        }
        LIST_HOURS.add(list_hours[i]);
      }
      LIST_HOURS = LIST_HOURS.reversed.toList();
      fillGlucoseValues();
      return LIST_HOURS.length == 1 ? 1 : LIST_HOURS.length - 1;
    } else {
      if (position == 0) {
        for (int i = LIST_HOURS.length - 1; i >= 0; i--) {
          DateTime timeStamp = template.add(
              Duration(hours: LIST_HOURS[i][0], minutes: LIST_HOURS[i][1]));
          if (timeStamp.millisecondsSinceEpoch >=
                  DateTime.now().millisecondsSinceEpoch ||
              DateTime.now().millisecondsSinceEpoch -
                      timeStamp.millisecondsSinceEpoch <
                  const Duration(minutes: 15).inMilliseconds) {
            LIST_HOURS[i] = [DateTime.now().hour, DateTime.now().minute];
            fillGlucoseValues();
            return LIST_HOURS.length - 1 - i;
          }
        }
      }
      fillGlucoseValues();
      return LIST_HOURS.length - 1;
    }
  }

  void fillGlucoseValues() {
    List<double> newList = [];
    List<String> newIds = [];
    if (LIST_GLUCOSE.isEmpty) {
      for (int i = 1; i < LIST_HOURS.length; i++) {
        newList.add(-1);
        newIds.add('');
      }
    } else {
      List<int> list = timeToGlucoseMap.keys.toList(); // [540, ..]

      for (int i = 1; i < LIST_HOURS.length; i++) {
        //  O(n2)!!! NAUR!!!
        double sumGlucose = 0;
        int counter = 0;
        String putId = '';
        for (int item in list) {
          putId = '';
          if (item >= LIST_HOURS[i][0] * 60 + LIST_HOURS[i][1] &&
              item < LIST_HOURS[i - 1][0] * 60 + LIST_HOURS[i - 1][1]) {
            sumGlucose = sumGlucose + (timeToGlucoseMap[item]?.GV ?? 0);
            counter++;
            putId = timeToIdMap[item] ?? '';
          }
        }
        newList.add(sumGlucose == 0 ? -1 : sumGlucose / counter);
        newIds.add(putId);
      }
    }

    LIST_GLUCOSE = newList;
    LIST_ID = newIds;
  }

  @override
  void dispose() {
    // dispose stuff later
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      reverse: true,
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemCount: getListLength(),
      itemBuilder: (BuildContext context, int index) {
        return buildRow(context, index);
      },
    );
  }
}

class TimeBlock extends StatelessWidget {
  final TimeBorders timeBorders;
  final bool isNow;
  final int idx;
  final int position;
  final TrackGV glucoseValue;
  final String glucoseId;
  final List<Color> pallete = [];

  TimeBlock(
      {Key? key,
      required this.timeBorders,
      required this.isNow,
      required this.idx,
      required this.position,
      required this.glucoseValue,
      required this.glucoseId})
      : super(key: key) {
    pallete.clear();
    for (int i in AppColors.hex_colors_lower) {
      pallete.add(Color(i));
    }
  }

  List<String> getBorders() {
    return [timeBorders.getStartString(), timeBorders.getEndString()];
  }

  double getLenght() {
    return 50 * log(timeBorders.getDistance().inMinutes / 30 + 1);
  }

  void _expandTimeBlock() {
    List<TimeBorders> newBorders = timeBorders.expandTimeBorders();
    if (newBorders.isEmpty) {
      return;
    }
    dataLogKey[position]
        .currentState
        ?.insertTimeBlock(newBorders[1], isNow, idx);
  }

  void _collapseTimeBorders(TimeBlock prev) {
    const Duration maxSplitDistance = Duration(hours: 6);
    DateTime toRemove = DateTime(
        prev.timeBorders.end.year,
        prev.timeBorders.end.month,
        prev.timeBorders.end.day,
        dataLogKey[position].currentState?.LIST_HOURS[prev.idx + 1][0],
        dataLogKey[position].currentState?.LIST_HOURS[prev.idx + 1][1]);

    Duration distance = Duration(
        milliseconds: toRemove.millisecondsSinceEpoch -
            prev.timeBorders.start.millisecondsSinceEpoch);

    if (distance.inMilliseconds < maxSplitDistance.inMilliseconds) {
      dataLogKey[position].currentState?.removeTimeBlock(prev.idx);
    }
  }

  void _acceptNewGlucoseValue(TrackGV glucoseValue) {
    dataLogKey[position].currentState?.acceptNewGlucoseValue(
        glucoseValue, getBordersInt()[0][0], getBordersInt()[0][1]);
  }

  void _deleteGlucoseValue() {
    dataLogKey[position].currentState?.deleteGlucoseValue(
        glucoseId, getBordersInt()[0][0], getBordersInt()[0][1]);
  }

  String describe() {
    return '[$idx, $timeBorders, $isNow]';
  }

  List<List<int>> getBordersInt() {
    return [
      [timeBorders.start.hour, timeBorders.start.minute],
      [timeBorders.end.hour, timeBorders.end.minute]
    ];
  }

  @override
  Widget build(BuildContext context) {
    MenuController menuController = MenuController();
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
              alignment: Alignment.centerRight,
              width: 64,
              height: 24,
              child: Text(isNow ? 'now' : getBorders()[1],
                  style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'Inter-Thin',
                      fontSize: 14))),
          Column(children: [
            GestureDetector(
                onDoubleTap: () => _expandTimeBlock(),
                child: DragTarget<TrackGV>(
                    builder: (context, candidateItems, rejectedItems) {
                  return Container(
                      constraints: const BoxConstraints(minHeight: 50),
                      height: getLenght(),
                      width: 50,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          boxShadow: [
                            BoxShadow(
                                color: Color.fromARGB(60, 205, 194, 237),
                                offset: Offset(2, 2),
                                blurRadius: 8,
                                spreadRadius: 2),
                            BoxShadow(
                                color: Color.fromARGB(60, 205, 194, 237),
                                offset: Offset(-2, -2),
                                blurRadius: 8,
                                spreadRadius: 2)
                          ]),
                      child: glucoseValue.GV == -1
                          ? Container()
                          : Stack(alignment: Alignment.center, children: [
                              MenuAnchor(
                                  builder: (BuildContext context,
                                      MenuController controller,
                                      Widget? child) {
                                    menuController = controller;
                                    return GestureDetector(
                                        onLongPress: () {
                                          if (controller.isOpen) {
                                            controller.close();
                                          } else {
                                            controller.open();
                                          }
                                        },
                                        child: Container(
                                            alignment: Alignment.center,
                                            width: 35,
                                            height: 35,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color:
                                                      pallete[glucoseValue.GV2],
                                                  width: 1.5),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Text(glucoseValue.toString(),
                                                style: const TextStyle(
                                                    fontFamily: 'Inter-Thin',
                                                    fontSize: 12))));
                                  },
                                  alignmentOffset: const Offset(-18, -18),
                                  menuChildren: [
                                    GestureDetector(
                                        onTap: () {
                                          if (menuController.isOpen) {
                                            _deleteGlucoseValue();
                                            menuController.close();
                                          }
                                        },
                                        child: Container(
                                            width: 35,
                                            height: 35,
                                            decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius:
                                                    BorderRadius.circular(25)),
                                            alignment: Alignment.center,
                                            child: const Icon(Icons.close,
                                                color: Colors.white)))
                                  ],
                                  style: const MenuStyle(
                                      elevation:
                                          MaterialStatePropertyAll<double>(0),
                                      backgroundColor:
                                          MaterialStatePropertyAll<Color>(
                                              AppColors.trans),
                                      shape: MaterialStatePropertyAll<
                                              OutlinedBorder>(
                                          RoundedRectangleBorder()),
                                      alignment: AlignmentDirectional.center,
                                      //side:
                                      padding:
                                          MaterialStatePropertyAll<EdgeInsets>(
                                              EdgeInsets.only(left: 0)),
                                      fixedSize: MaterialStatePropertyAll<Size>(
                                          Size(50, 50)),
                                      maximumSize:
                                          MaterialStatePropertyAll<Size>(
                                              Size(50, 100))))
                            ]));
                }, onAcceptWithDetails: (glucoseValue) {
                  _acceptNewGlucoseValue(glucoseValue.data);
                })),
            GestureDetector(
                onDoubleTap: () => _collapseTimeBorders(this),
                child: Container(
                    height: 24,
                    width: 50,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(color: AppColors.trans),
                    child: Column(children: [
                      Container(
                          height: 8,
                          width: 0,
                          decoration: const BoxDecoration(
                              border: Border(
                                  left: BorderSide(
                                      width: 1.0,
                                      color: AppColors.lavender_light),
                                  right: BorderSide(
                                      width: 1.0,
                                      color: AppColors.lavender_light)))),
                      isNow
                          ? Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: AppColors.lavender, width: 1),
                                  borderRadius: BorderRadius.circular(4)))
                          : Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                  color: AppColors.mint,
                                  borderRadius: BorderRadius.circular(4))),
                      isNow
                          ? const SizedBox(height: 8)
                          : Container(
                              height: 8,
                              width: 0,
                              decoration: const BoxDecoration(
                                  border: Border(
                                      left: BorderSide(
                                          width: 1.0,
                                          color: AppColors.lavender_light),
                                      right: BorderSide(
                                          width: 1.0,
                                          color: AppColors.lavender_light))))
                    ])))
          ]),
          Container(alignment: Alignment.centerRight, width: 64, height: 40)
        ]);
  }
}

class TimeBorders {
  // 2+ hours (<- divide), 60 min, 30 min
  const TimeBorders(this.start, this.end);
  final DateTime start; // can be 13:00 or 13:30
  final DateTime end; // can be 13:00 or 13:30
  final Duration minSplitDistance = const Duration(minutes: 30);

  String getStartString() {
    return '${start.hour}:${start.minute < 10 ? '0${start.minute}' : start.minute}';
  }

  String getEndString() {
    if (end.hour == 23 && end.minute == 59) {
      return '00:00';
    }
    return '${end.hour}:${end.minute < 10 ? '0${end.minute}' : end.minute}';
  }

  Duration getDistance() {
    return Duration(
        milliseconds:
            end.millisecondsSinceEpoch - start.millisecondsSinceEpoch);
  }

  List<TimeBorders> expandTimeBorders() {
    Duration distance = getDistance();
    if (distance > minSplitDistance) {
      if (distance.inMinutes >= 120) {
        // start=13:00; end=16:00 --> 13:00+14:00; 14:00+16:00
        DateTime split =
            start.add(Duration(hours: (distance.inHours / 2).floor()));
        return [TimeBorders(start, split), TimeBorders(split, end)];
      } else {
        // start=13:00; end=14:30 --> 13:00+13:30; 13:30+14:30
        // or
        // start=13:00; end=14:00 --> 13:00+13:30; 13:30+14:00
        DateTime split = start.add(const Duration(minutes: 30));

        if (TimeBorders(start, split).getDistance() >= minSplitDistance &&
            TimeBorders(split, end).getDistance() >= minSplitDistance) {
          return [TimeBorders(start, split), TimeBorders(split, end)];
        } else {
          return [];
        }
      }
    }

    return [];
  }

  @override
  String toString() {
    return '${getStartString()} | ${getEndString()}';
  }
}



/*
class NumericKeypad extends StatefulWidget {
  final int position;
  final TextEditingController controller;
  //final TimeBlock timeBlock;
  const NumericKeypad(
      {super.key, required this.position, required this.controller});

  @override
  State<NumericKeypad> createState() => _NumericKeypadState();
}

class _NumericKeypadState extends State<NumericKeypad> {
  late TextEditingController controller;
  //late TimeBlock timeBlock;
  @override
  initState() {
    // TODO: implement initState
    controller = widget.controller;
    //timeBlock = widget.timeBlock;
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double height = 80;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            height: height,
            //margin: const EdgeInsets.only(top: 16, bottom: 16),
            /*decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1)),*/
            child: Row(
              children: [
                buildNumButton('1'),
                buildNumButton('2'),
                buildNumButton('3'),
                buildNumButton('X')
              ],
            )),
        Container(
            height: height,
            //margin: const EdgeInsets.only(bottom: 16),
            /*decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1)),*/
            child: Row(
              children: [
                buildNumButton('4'),
                buildNumButton('5'),
                buildNumButton('6'),
                buildNumButton(' ')
              ],
            )),
        Container(
            height: height,
            //margin: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                buildNumButton('7'),
                buildNumButton('8'),
                buildNumButton('9'),
                buildNumButton(' ')
              ],
            )),
        Container(
            height: height,
            //margin: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                buildSepButton(),
                buildNumButton('0'),
                buildEraseButton(),
                buildNumButton('A')
              ],
            ))
      ],
    );
  }

  Widget buildNumButton(String text) {
    final MaterialStatesController statesController =
        MaterialStatesController();
    return Expanded(
        child: ElevatedButton(
            onPressed: () => inputNum(text),
            statesController: statesController,
            style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll<Color>(Colors.white),
              shadowColor: MaterialStatePropertyAll<Color>(
                  Color.fromARGB(99, 190, 179, 225)),
              elevation: MaterialStatePropertyAll<double>(2),
              shape: MaterialStatePropertyAll<OutlinedBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)))),
            ),
            child: Text(text,
                style: const TextStyle(
                    color: Colors.black,
                    fontFamily: 'Inter-Thin',
                    fontSize: 20))));
  }

  Widget buildEmpty() {
    return Expanded(child: Container());
  }

  Widget buildSepButton() {
    return Expanded(
        child: OutlinedButton(
            onPressed: () => inputSep(), child: const Text('.')));
  }

  Widget buildEraseButton() {
    return Expanded(
        child:
            OutlinedButton(onPressed: () => erase(), child: const Text('<-')));
  }

  void inputNum(String text) {
    final String value = controller.text + text;
    if (RegExp(r'^[1-3]([0-9]|[0-9]\.|[0-9]\.[0-9])?$').hasMatch(value)) {
      controller.text = value;
    }
  }

  void inputSep() {
    final String value = '${controller.text}.';
    if (RegExp(r'^[0-9]+\.$').hasMatch(value)) {
      controller.text = value;
    }
  }

  void erase() {
    final String value = controller.text;
    if (value.isNotEmpty) {
      controller.text = value.substring(0, value.length - 1);
    }
  }
}
*/