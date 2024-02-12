import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/db_user.dart';

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

/*
  Stream<List<UserModel>> getUsername(String email) {
    final userCollection = firestore.collection("userPublicData");

    return userCollection.snapshots().map((querySnapshot) => querySnapshot.docs.map((e) =>
    UserModel.fromSnapshot(e)).toList());
  }
  */
}
