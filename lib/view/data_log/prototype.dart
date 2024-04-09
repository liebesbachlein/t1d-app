// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:core';

import 'package:flutter_app/assets/colors.dart';

final dataLogKey = GlobalKey<_DataViewState>();

const List<List<List<double>>> paths = [
  [
    [0, 0],
    [0, 0.2],
    [0.5, 0.2]
  ],
  [
    [0.5, 0.2],
    [0.5, 0],
    [0.5, 0.2]
  ]
];

final List<List<int>> LIST_HOURS = [
  [6, 0],
  [12, 0],
  [16, 0],
  [17, 0],
  [18, 0],
  [19, 0],
  [20, 0],
  [21, 0],
  [22, 0],
  [23, 0],
  [24, 0]
];

class DataPrototype extends StatefulWidget {
  const DataPrototype({super.key});

  @override
  State<DataPrototype> createState() => _DataPrototypeState();
}

class _DataPrototypeState extends State<DataPrototype> {
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
        body: /*const BoxLayout(2)*/ DataView(key: dataLogKey));
  }
}

class BoxLayout extends StatefulWidget {
  final int length;
  const BoxLayout(this.length, {super.key});

  @override
  State<BoxLayout> createState() => _BoxLayoutState();
}

class _BoxLayoutState extends State<BoxLayout> {
  late int length;

  @override
  void initState() {
    length = widget.length;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: length,
      itemBuilder: (BuildContext context, int index) {
        return buildLayout(context, index);
      },
    );
  }

  Widget buildLayout(BuildContext context, int index) {
    return BoxContainer(index, index.isEven ? 3 : 2);
  }
}

class BoxContainer extends StatelessWidget {
  final int index;
  final int num;
  const BoxContainer(this.index, this.num, {super.key});

  bool isToLeft() {
    return index.isEven ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
          BoxLine(
              index, isToLeft() ? 3 : 2, isToLeft() ? true : false, isToLeft()),
          BoxLine(
              index, isToLeft() ? 2 : 3, isToLeft() ? false : true, isToLeft())
        ]));
  }
}

class BoxLine extends StatelessWidget {
  final int index;
  final int num;
  final bool isVertical;
  final bool isLeftToRight;
  const BoxLine(this.index, this.num, this.isVertical, this.isLeftToRight,
      {super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> list = [];
    for (int i = 0; i < num; i++) {
      list.add(RoundedBox(isVertical, '12:00', isLeftToRight));
    }

    return isVertical
        ? Column(mainAxisAlignment: MainAxisAlignment.center, children: list)
        : SizedBox(
            width: MediaQuery.of(context).size.width - 40 - 32,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center, children: list));
  }
}

class RoundedBox extends StatelessWidget {
  const RoundedBox(this.isVertical, this.time, this.isLeftToRight, {super.key});
  final bool isVertical;
  final bool isLeftToRight;
  final String time;

  @override
  Widget build(BuildContext context) {
    return isVertical
        ? Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Container(
                width: 40,
                height: 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.lavender, width: 1))),
            Container(
                height: 40,
                alignment: Alignment.center,
                child: Text(time,
                    style: const TextStyle(
                        color: Colors.black,
                        fontFamily: 'Inter-Thin',
                        fontSize: 12)))
          ])
        : Expanded(
            child: isLeftToRight
                ? Row(children: [
                    Expanded(
                        child: Container(
                      constraints: const BoxConstraints(minWidth: 40),
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border:
                              Border.all(color: AppColors.lavender, width: 1)),
                    )),
                    Container(
                        height: 40,
                        constraints: const BoxConstraints(minWidth: 40),
                        alignment: Alignment.center,
                        child: Text(time,
                            style: const TextStyle(
                                color: Colors.black,
                                fontFamily: 'Inter-Thin',
                                fontSize: 12)))
                  ])
                : Row(children: [
                    Container(
                        height: 40,
                        constraints: const BoxConstraints(minWidth: 40),
                        alignment: Alignment.center,
                        child: Text(time,
                            style: const TextStyle(
                                color: Colors.black,
                                fontFamily: 'Inter-Thin',
                                fontSize: 12))),
                    Expanded(
                        child: Container(
                      constraints: const BoxConstraints(minWidth: 40),
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border:
                              Border.all(color: AppColors.lavender, width: 1)),
                    ))
                  ]));
  }
}

class DataView extends StatefulWidget {
  const DataView({required Key key}) : super(key: key);

  @override
  State<DataView> createState() => _DataViewState();
}

class _DataViewState extends State<DataView> {
  final nowDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  /*
      int nowMinutes = DateTime.now().minute + 60 * DateTime.now().hour;
      int timeStampMinutes = 60 * LIST_HOURS[i][0] + LIST_HOURS[i][1];
      if((nowMinutes - timeStampMinutes).abs() < 15) { 
        break;
      } */

  Widget buildRow(BuildContext context, int index) {
    DateTime template =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    DateTime timeStampStart = template.add(
        Duration(hours: LIST_HOURS[index][0], minutes: LIST_HOURS[index][1]));
    DateTime timeStampEnd = template.add(Duration(
        hours: LIST_HOURS[index + 1][0], minutes: LIST_HOURS[index + 1][1]));

    return TimeBlock(
        timeBorders: TimeBorders(timeStampStart, timeStampEnd),
        isTwoSided: index + 2 == LIST_HOURS.length,
        idx: index);
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

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: LIST_HOURS.length - 1,
      itemBuilder: (BuildContext context, int index) {
        return buildRow(context, index);
      },
    );
  }
}

class TimeBlock extends StatelessWidget {
  final TimeBorders timeBorders;
  final bool isTwoSided;
  final int idx;

  const TimeBlock(
      {Key? key,
      required this.timeBorders,
      required this.isTwoSided,
      required this.idx})
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
    dataLogKey.currentState?.insertTimeBlock(TimeBlock(
        timeBorders: newBlocks[1], isTwoSided: isTwoSided, idx: idx + 1));
  }

  void _collapseTimeBorders(TimeBlock prev) {
    const Duration maxSplitDistance = Duration(hours: 6);
    DateTime toRemove = DateTime(
        prev.timeBorders.end.year,
        prev.timeBorders.end.month,
        prev.timeBorders.end.day,
        LIST_HOURS[prev.idx][0],
        LIST_HOURS[prev.idx][1]);

    Duration distance = Duration(
        milliseconds: toRemove.millisecondsSinceEpoch -
            prev.timeBorders.start.millisecondsSinceEpoch);

    if (distance.inMilliseconds < maxSplitDistance.inMilliseconds) {
      dataLogKey.currentState?.removeTimeBlock(prev.idx + 1);
    }
  }

  String describe() {
    return '[$idx, $timeBorders, $isTwoSided]';
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
              padding: const EdgeInsets.only(right: 8),
              width: 64,
              height: 34,
              child: Text(
                getBorders()[1],
                style: const TextStyle(
                    color: Colors.black,
                    fontFamily: 'Inter-Thin',
                    fontSize: 14),
              )),
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
                      Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                              color: AppColors.mint,
                              borderRadius: BorderRadius.circular(4))),
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
                                      color: AppColors.lavender_light))))
                    ])))
          ])
        ]);
  }
}

class TimeBorders {
  // 2+ hours (<- divide), 60 min, 30 min
  TimeBorders(this.start, this.end);
  DateTime start; // can be 13:00 or 13:30
  DateTime end; // can be 13:00 or 13:30
  final Duration minSplitDistance = const Duration(minutes: 30);

  String getStartString() {
    return '${start.hour}:${start.minute < 10 ? '0${start.minute}' : start.minute}';
  }

  String getEndString() {
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

        return [TimeBorders(start, split), TimeBorders(split, end)];
      }
    }

    return [];
  }

  @override
  String toString() {
    return '${getStartString()} | ${getEndString()}';
  }
}
