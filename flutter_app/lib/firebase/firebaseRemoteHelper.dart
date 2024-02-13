import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/data_log/data_types.dart';
import 'package:flutter_app/db_user.dart';
import 'package:flutter_app/main.dart';

class FirebaseRemoteHelper {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  void addUser(String username, String email) {
    final userCollection = firestore.collection("userPublicData");
    String id = userCollection.doc().id;
    UserModel newUser = UserModel(email, username, email);
    userCollection.doc(id).set(newUser.toMap());
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
    List<UserModel> listUsers = await databaseHelperUser.queryAllRowsUsers();
    String email = listUsers.last.email;

    final userCollection = firestore.collection("gluValData");
    List<TrackTmGV> list = await databaseHelper.queryAllRowsGV();
    Map<String, TrackTmGV> mapId = {};
    list.forEach((e) => mapId.addAll({email + e.id.toString(): e}));
    print(mapId);

    for (TrackTmGV i in list) {
      userCollection.doc(email + i.id.toString()).set({
        'id': i.id,
        'date': i.date,
        'month': i.month,
        'hour': i.hour,
        'minute': i.minute,
        'glucose_val': i.gluval,
        'email': email,
        'deleted': false
      }, SetOptions(merge: true));
    }

    userCollection
        .where('email', isEqualTo: email)
        .get()
        .then((querySnapshot) => {
              querySnapshot.docs.forEach((i) {
                if (!mapId.containsKey(i.id)) {
                  print('indicating deleted: true');
                  print(i);
                  userCollection.doc(i.id).update({'deleted': true});
                }
              })
            });

    return true;
  }

  Future<bool> downloadGVdata() async {
    List<UserModel> listUsers = await databaseHelperUser.queryAllRowsUsers();
    String email = listUsers.last.email;

    final userCollection = firestore.collection("gluValData");
    List<TrackTmGV> listGV = await userCollection
        .where('email', isEqualTo: email)
        .where('deleted', isEqualTo: false)
        .get()
        .then((res) => TrackTmGV.fromQuerySnapshot(res));
    print('download');
    print(listGV);
    databaseHelper.deleteDatabase();
    databaseHelper.init(email).then((database) =>
        listGV.forEach((trackTmGV) => databaseHelper.insert(trackTmGV)));

    return true;
  }
}
