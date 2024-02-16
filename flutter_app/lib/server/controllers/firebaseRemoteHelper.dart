import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/server/models/TrackTmGV.dart';
import 'package:flutter_app/server/models/UserModel.dart';
import 'package:flutter_app/server/controllers/sharedPreferences.dart';
import 'package:flutter_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseRemoteHelper {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  void addUser(String username, String email) {
    final userCollection = firestore.collection("userPublicData");
    UserModel newUser = UserModel.generate(username, email);
    userCollection.doc(newUser.id).set(newUser.toMap());
  }

  void changeToken(String email, int authToken) {
    final userCollection = firestore.collection("authTokens");
    userCollection
        .doc(email)
        .set({"email": email, "authToken": authToken}, SetOptions(merge: true));
  }

  Future<UserModel> getUsername(String email) async {
    final userCollection = firestore.collection("userPublicData");
    UserModel user = await userCollection
        .where('email', isEqualTo: email)
        .get()
        .then((res) => UserModel.fromQuerySnapshot(res));
    return user;
  }

  Future<bool> uploadGVdata() async {
    String email = await getEmail();

    final userCollection = firestore.collection("gluValData");
    List<TrackTmGV> list = await databaseHelperGV.queryAllRowsGV();

    for (TrackTmGV i in list) {
      userCollection.doc(i.id).set(
          i.toMapFirebase(deleted: false, email: email),
          SetOptions(merge: true));
    }

    Map<String, TrackTmGV> mapId = {};
    list.forEach((e) => mapId.addAll({e.id: e}));

    userCollection
        .where('email', isEqualTo: email)
        .get()
        .then((querySnapshot) => {
              querySnapshot.docs.forEach((i) {
                if (!mapId.containsKey(i.id)) {
                  userCollection.doc(i.id).update({'deleted': true});
                }
              })
            });

    return true;
  }

  Future<bool> downloadGVdata() async {
    String email = await getEmail();

    final userCollection = firestore.collection("gluValData");
    List<TrackTmGV> listGV = await userCollection
        .where('email', isEqualTo: email)
        .where('deleted', isEqualTo: false)
        .get()
        .then((res) => TrackTmGV.fromQuerySnapshot(res));

    databaseHelperGV.deleteDatabase();
    databaseHelperGV.init(dbName: email).then((database) =>
        listGV.forEach((trackTmGV) => databaseHelperGV.insert(trackTmGV)));

    return true;
  }
}
