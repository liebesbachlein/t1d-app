// ignore_for_file: file_names

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

Future<bool> setPersonalInfo(
    {required String email, required String username}) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('authToken', Random().nextInt(1000) + 1000);
  await prefs.setString('email', email);
  await prefs.setString('username', username);

  return true;
}

Future<bool> deletePersonalInfo() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('username', 'Default');
  await prefs.setString('assist_name', 'Default');

  return true;
}

Future<String> getUsername() async {
  final prefs = await SharedPreferences.getInstance();
  final username = prefs.getString('username');
  if (username == null) {
    return 'Default';
  } else {
    return username;
  }
}

Future<String> getAssistantName() async {
  final prefs = await SharedPreferences.getInstance();
  final username = prefs.getString('assist_name');
  if (username == null) {
    return 'John Wick';
  } else {
    return username;
  }
}

Future<bool> setAssistantName({required String username}) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('assist_name', username);

  return true;
}

Future<String> getEmail() async {
  final prefs = await SharedPreferences.getInstance();
  final email = prefs.getString('email');
  if (email == null) {
    return 'default@email.com';
  } else {
    return email;
  }
}
