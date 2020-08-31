import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  bool isLogin = false;

  String id = '';
  String userName = '';
  String title = '';
  String profileURL = '';

  bool isAlarm = true;
  bool isInit; //when navigated from InitNext true
  String pushTriggerName;
  DateTime pushAlarmTime;

  String language = 'KO';

  SharedPreferences sp;

  UserProvider(
      {this.sp,
      this.pushTriggerName,
      this.pushAlarmTime,
      this.isAlarm,
      this.isInit}) {}

  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void setAlarmData(String name, DateTime time) async {
    this.pushTriggerName = name;
    this.pushAlarmTime = time;

    await saveAlarmData();

    if (isAlarm && !isInit) {
      await setTriggerNotification();
    }
  }

  void setisInit(bool isInit) {
    this.isInit = isInit;
    saveAlarmData();
  }

  Future<void> saveAlarmData() async {
    Map<String, dynamic> map = {
      'name': pushTriggerName,
      'time': pushAlarmTime.toString(),
      'isalarm': isAlarm ? 1 : 0,
      'isinit': isInit ? 1 : 0
    };
    String json = jsonEncode(map);
    sp.setString('alarm', json);
    notifyListeners();
  }

  void resetNotification() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  void setNotiPlugin(FlutterLocalNotificationsPlugin plugin) {
    this._flutterLocalNotificationsPlugin = plugin;
  }

  //for test
  Future<void> showNotification() async {
    var android = AndroidNotificationDetails(
        'channelId', 'channelName', 'channelDescription');
    var iOS = IOSNotificationDetails();
    var platform = NotificationDetails(android, iOS);

    await FlutterLocalNotificationsPlugin().show(0, 'title', 'body', platform);
  }

  Future<void> setTriggerNotification() async {
    Time time =
        Time(pushAlarmTime.hour, pushAlarmTime.minute, pushAlarmTime.second);

    var android = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max,
        priority: Priority.High,
        icon: '@mipmap/ic_launcher',
        largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'));

    var ios = IOSNotificationDetails();
    var detail = NotificationDetails(android, ios);
    print(
        "${pushAlarmTime.hour}, ${pushAlarmTime.minute}, ${pushAlarmTime.second}");
    await _flutterLocalNotificationsPlugin.showDailyAtTime(
      0,
      'RichHabit',
      '$pushTriggerName 할 시간입니다!!',
      time,
      detail,
      payload: 'trigger',
    );
  }

  void resetData() {
    isAlarm = true;
    isInit = true;
    pushTriggerName = "";
    pushAlarmTime = null;
    resetNotification();
  }
}
