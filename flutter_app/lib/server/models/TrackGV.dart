class TrackGV {
  double GV = 0.0;
  int GV1 = 0;
  int GV2 = 0;

  TrackGV(this.GV) {
    GV1 = GV.floor();
    double g = ((GV - GV1.toDouble()) * 10);
    GV2 = g.round();
  }

  double toDouble() {
    return GV;
  }

  @override
  String toString() {
    return GV.toString();
  }
}
