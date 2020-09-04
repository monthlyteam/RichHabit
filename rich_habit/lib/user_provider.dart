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
      this.isInit});

  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void setAlarmData(String name, DateTime time) async {
    this.pushTriggerName = name;
    this.pushAlarmTime = time;

    saveAlarmData();
    notifyListeners();

    if (isAlarm && !isInit) {
      await setTriggerNotification();
    }
  }

  void setisAlarm(bool isAlarm) {
    this.isAlarm = isAlarm;
    saveAlarmData();
    notifyListeners();
  }

  void setisInit(bool isInit) {
    this.isInit = isInit;
    saveAlarmData();
  }

  void saveAlarmData() {
    Map<String, dynamic> map = {
      'name': pushTriggerName,
      'time': pushAlarmTime.toString(),
      'isalarm': isAlarm ? 1 : 0,
      'isinit': isInit ? 1 : 0
    };
    String json = jsonEncode(map);
    sp.setString('alarm', json);
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
        'RichHabit', '습관 입력하기', '주기적으로 습관 입력을 돕는 알림입니다.',
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
      '$pushTriggerName 할 시간입니다!! 오늘의 소비습관을 기록해 봐요.',
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
