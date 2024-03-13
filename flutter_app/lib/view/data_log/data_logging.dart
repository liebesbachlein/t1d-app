// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:core';

import 'package:flutter_app/assets/colors.dart';
//import 'package:flutter_app/main.dart';
import 'package:flutter_app/server/models/TrackGV.dart';
//import 'package:flutter_app/server/models/TrackTmGV.dart';

//final dataLogKey = GlobalKey<_DataViewState>();
Map dataLogKey = <int, GlobalKey<_DataViewState>>{};

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
    super.initState();
  }

  String getCurDate() {
    if (curIndex == 0) {
      return 'September 30';
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
    TextEditingController textController = TextEditingController();
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.white,
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.white,
              statusBarIconBrightness: Brightness.dark, // Android dark???
              statusBarBrightness: Brightness.light, // iOS dark???
            ),
            toolbarHeight: 0,
            elevation: 0),
        body: ListView.builder(
            // what about changing to SilverList bc LV is slow ???
            controller: _controller,
            reverse: true,
            itemBuilder: (BuildContext context, int index) {
              return buildDataView(context, index);
            }),
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
}

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
  final Map<Duration, double> dataMap = {
    const Duration(hours: 2): 2,
    const Duration(hours: 5): 5,
    const Duration(hours: 8): 8,
    const Duration(hours: 11): 11,
    const Duration(hours: 14): 14,
    const Duration(hours: 17): 17
  };
  late Map<List<int>, TrackGV>
      corMap; // of all collection leave only Map<List<int>, TrackGV>, dataMap is a function return

  @override
  void initState() {
    LIST_HOURS = [];
    corMap = {};
    position = widget.position;
    dateNow = DateTime.now().subtract(Duration(days: position));
    super.initState();
  }
/*
  Future<Map<Duration, double>> loadData() async {
    List<TrackTmGV> dataList = await databaseHelperGV
        .selectDay(DateTime.now().add(Duration(days: position)));
    Map<Duration, double> map = {};
    for (TrackTmGV i in dataList) {
      map.putIfAbsent(
          Duration(hours: i.hour, minutes: i.minute), () => i.gluval.GV);
    }
    return map;
  }*/

  void populateTimeBlocks() {
    //put retrived gluval into 1 hour TimeBlock with correct relative position
    //for (Duration i in dataMap.keys) {}
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
            timeBorders: TimeBorders(timeStampStart, DateTime.now()),
            isNow: true,
            idx: index,
            position: position);
      }
    }

    return TimeBlock(
        timeBorders: TimeBorders(timeStampStart, timeStampEnd),
        isNow: false,
        idx: index,
        position: position);
  }

  void insertTimeBlock(TimeBlock newBlock) {
    setState(() {
      LIST_HOURS.insert(newBlock.idx, newBlock.getBordersInt()[0]);
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
              return LIST_HOURS.length;
            }
            LIST_HOURS = LIST_HOURS.reversed.toList();
            return LIST_HOURS.length - 1;
          }
        }
        LIST_HOURS.add(list_hours[i]);
      }
      LIST_HOURS = LIST_HOURS.reversed.toList();
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
            return LIST_HOURS.length - 1 - i;
          }
        }
      }

      return LIST_HOURS.length - 1;
    }
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
  //when inserting new gluval, store as timestamp the nearest inside start timeBorder

  List<TimeBorders> getInsideTimeBorders() {
    return timeBorders._getInsideTimeBorders();
  } //make it return a list of widget to feed it to a Column with Alignment stretch

  const TimeBlock(
      {Key? key,
      required this.timeBorders,
      required this.isNow,
      required this.idx,
      required this.position})
      : super(key: key);

  List<String> getBorders() {
    return [timeBorders.getStartString(), timeBorders.getEndString()];
  }

  double getLenght() {
    return 50 * log(timeBorders.getDistance().inMinutes / 30 + 1);
  }

  void _expandTimeBlock() {
    List<TimeBorders> newBlocks = timeBorders.expandTimeBorders();
    if (newBlocks.isEmpty) {
      return;
    }
    dataLogKey[position].currentState?.insertTimeBlock(TimeBlock(
          timeBorders: newBlocks[1],
          isNow: isNow,
          idx: idx + 1,
          position: position,
        ));
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
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
              alignment: Alignment.centerRight,
              width: 64,
              height: 40,
              child: Text(isNow ? 'now' : getBorders()[1],
                  style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'Inter-Thin',
                      fontSize: 14))),
          Column(children: [
            GestureDetector(
                onDoubleTap: () => _expandTimeBlock(),
                child: Container(
                    height: getLenght(),
                    width: 63,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(color: AppColors.trans),
                    child: Container(
                        width: 0,
                        decoration: const BoxDecoration(
                            border: Border(
                          left: BorderSide(
                              width: 1.0, color: AppColors.lavender_light),
                          right: BorderSide(
                              width: 1.0, color: AppColors.lavender_light),
                        ))))),
            GestureDetector(
                onDoubleTap: () => _collapseTimeBorders(this),
                child: Container(
                    height: 40,
                    width: 63,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(color: AppColors.trans),
                    child: Column(children: [
                      Container(
                          height: 16,
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
                          ? Container()
                          : Container(
                              height: 16,
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
  TimeBorders(this.start, this.end);
  DateTime start; // can be 13:00 or 13:30
  DateTime end; // can be 13:00 or 13:30
  final Duration minSplitDistance = const Duration(minutes: 30);

  List<TimeBorders> _getInsideTimeBorders() {
    if (getDistance().inMinutes < 30) {
      return [];
    } else if (getDistance().inMinutes < 45) {
      DateTime split = start.add(const Duration(minutes: 15));
      return [TimeBorders(start, split), TimeBorders(split, start)];
    } else {
      int splitValue = ((getDistance().inMinutes / 15).floor() * 15).floor();
      DateTime firstSplit = start.add(Duration(minutes: splitValue));
      DateTime secondSplit = firstSplit.add(Duration(minutes: splitValue));
      return [
        TimeBorders(start, firstSplit),
        TimeBorders(firstSplit, secondSplit),
        TimeBorders(secondSplit, start)
      ];
    }
  }

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
