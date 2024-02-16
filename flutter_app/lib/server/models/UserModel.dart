import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

String getRandomString() {
  final String chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random rnd = Random();
  return String.fromCharCodes(Iterable.generate(
      15, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
}

class UserModel {
  String id = '0';
  String username = 'default';
  String email = 'default@email.com';

  UserModel(this.id, this.username, this.email);

  UserModel.generate(this.username, this.email) {
    id = email + getRandomString();
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'username': username, 'email': email};
  }

  UserModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    username = map['username'];
    email = map['email'];
  }

  UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    id = snapshot['id'];
    username = snapshot['username'];
    email = snapshot['email'];
  }

  static UserModel fromQuerySnapshot(
      QuerySnapshot<Map<String, dynamic>> snapshot) {
    List<UserModel> list = [];
    snapshot.docs.forEach(
        (doc) => list.add(UserModel(doc.id, doc['username'], doc['email'])));

    return list.last;
  }
}
