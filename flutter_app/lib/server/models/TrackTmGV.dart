import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/server/models/TrackGV.dart';

String getRandomString() {
  final String chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random rnd = Random();
  return String.fromCharCodes(Iterable.generate(
      10, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
}

class TrackTmGV {
  String id = '0';
  DateTime dateSeconds = DateTime(2024, 1, 1, 0, 0);
  int year = 2024;
  int month = 1;
  int day = 1;
  int hour = 0;
  int minute = 0;
  TrackGV gluval = TrackGV(6);
  bool isGV = false;

  TrackTmGV.create(this.dateSeconds, this.gluval) {
    id = getRandomString();
    year = dateSeconds.year;
    month = dateSeconds.month;
    day = dateSeconds.day;
    hour = dateSeconds.hour;
    minute = dateSeconds.minute;
    isGV = true;
  }

  TrackTmGV.empty(this.dateSeconds) {
    id = getRandomString();
    year = dateSeconds.year;
    month = dateSeconds.month;
    day = dateSeconds.day;
    hour = dateSeconds.hour;
    minute = dateSeconds.minute;
    isGV = false;
  }

  TrackTmGV.fromData(this.id, this.dateSeconds, this.gluval) {
    year = dateSeconds.year;
    month = dateSeconds.month;
    day = dateSeconds.day;
    hour = dateSeconds.hour;
    minute = dateSeconds.minute;
    isGV = true;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dateSeconds': dateSeconds.millisecondsSinceEpoch,
      'year': year,
      'month': month,
      'day': day,
      'hour': hour,
      'minute': minute,
      'glucose_val': gluval.toDouble()
    };
  }

  Map<String, dynamic> toMapFirebase(
      {required bool deleted, required String email}) {
    return {
      'id': id,
      'dateSeconds': dateSeconds.millisecondsSinceEpoch,
      'year': year,
      'month': month,
      'day': day,
      'hour': hour,
      'minute': minute,
      'glucose_val': gluval.toDouble(),
      'deleted': deleted,
      'email': email
    };
  }

  TrackTmGV.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    dateSeconds = DateTime.fromMillisecondsSinceEpoch(map['dateSeconds']);
    year = dateSeconds.year;
    month = dateSeconds.month;
    day = dateSeconds.day;
    hour = dateSeconds.hour;
    minute = dateSeconds.minute;
    gluval = TrackGV(map['glucose_val']);
    isGV = true;
  }

  TrackTmGV.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> map) {
    id = map['id'];
    dateSeconds = DateTime.fromMillisecondsSinceEpoch(map['dateSeconds']);
    year = dateSeconds.year;
    month = dateSeconds.month;
    day = dateSeconds.day;
    hour = dateSeconds.hour;
    minute = dateSeconds.minute;
    gluval = TrackGV(map['glucose_val']);
    isGV = true;
  }

  static List<TrackTmGV> fromQuerySnapshot(
      QuerySnapshot<Map<String, dynamic>> snapshot) {
    List<TrackTmGV> list = [];
    snapshot.docs.forEach((doc) {
      list.add(TrackTmGV.fromDocumentSnapshot(doc));
    });

    return list;
  }

  void setDate(DateTime dateSeconds) {
    this.dateSeconds = dateSeconds;
    year = dateSeconds.year;
    month = dateSeconds.month;
    day = dateSeconds.day;
    hour = dateSeconds.hour;
    minute = dateSeconds.minute;
    isGV = false;
  }

  void nulled() {
    isGV = false;
  }

  void setGV(TrackGV newGV) {
    gluval = newGV;
    isGV = true;
  }

  @override
  String toString() {
    String str1 = dateSeconds.toIso8601String();
    String str2 = gluval.toString();
    return '$id | $str1 | $year | $month | $day | $hour | $minute | $str2  | $isGV';
  }
}
