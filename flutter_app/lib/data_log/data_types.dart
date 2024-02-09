class TrackGV {
  double GV = 0.0;
  int GV1 = 0;
  int GV2 = 0;

  TrackGV(this.GV) {
    GV1 = GV.floor();
    double g = ((GV - GV1.toDouble()) * 10);
    GV2 = g.round();
  }

  @override
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

  void setDate(DateTime d) {
    time = d;
    date = DateTime(d.year, d.month, d.day, 0, 0, 0, 0, 0).toIso8601String();
    month = d.month;
  }

  List<TrackGV> listOfGV = [];

  void nulled() {
    listOfGV = [];
    gluval = -1;
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

  @override
  String toString() {
    return '$id||$date||$hour||$minute||$listOfGV';
  }
}
