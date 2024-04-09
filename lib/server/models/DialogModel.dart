// ignore_for_file: file_names

import 'dart:math';

String getRandomString() {
  const String chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random rnd = Random();
  return String.fromCharCodes(Iterable.generate(
      10, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
}

class DialogModel {
  String id = '0';
  int fromWho = 1; // ai = 0; user = 1
  String content = "default";
  int command = 0; // none = 0; average = 1;
  DateTime displayDate = DateTime(2024, 1, 1, 0, 0);
  DateTime fromDate = DateTime(2024, 1, 1, 0, 0);
  DateTime toDate = DateTime(2024, 1, 2, 0, 0);

  DialogModel.createAICommand(this.displayDate, this.content, this.command) {
    fromWho = 0;
    id = getRandomString();
  }

  DialogModel.createAIText(this.displayDate, this.content) {
    fromWho = 0;
    id = getRandomString();
  }

  DialogModel.createUserCommand(
      this.displayDate, this.command, this.fromDate, this.toDate) {
    fromWho = 1;
    id = getRandomString();
  }

  DialogModel.createUserText(this.displayDate, this.content) {
    fromWho = 1;
    id = getRandomString();
  }

  DialogModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    fromWho = map['fromWho'];
    content = map['content'];
    command = map['command'];
    displayDate = DateTime.fromMillisecondsSinceEpoch(map['displayDate']);
    fromDate = DateTime.fromMillisecondsSinceEpoch(map['fromDate']);
    toDate = DateTime.fromMillisecondsSinceEpoch(map['toDate']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fromWho': fromWho,
      'command': command,
      'content': content,
      'displayDate': displayDate.millisecondsSinceEpoch,
      'fromDate': fromDate.millisecondsSinceEpoch,
      'toDate': toDate.millisecondsSinceEpoch,
    };
  }

  @override
  String toString() {
    return '$id | $fromWho | $content | $command | $displayDate | $fromDate | $toDate';
  }
}
