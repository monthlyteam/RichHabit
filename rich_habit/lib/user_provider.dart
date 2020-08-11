import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  bool isLogin = false;

  String id = '';
  String userName = '';
  String title = '';
  String profileURL = '';

  bool isAlarm = false;
  DateTime pushAlarmTime;

  String language = 'KO';
}
