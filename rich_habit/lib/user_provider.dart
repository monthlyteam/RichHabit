import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class UserProvider with ChangeNotifier {
  bool isLogin = false;

  String id = '';
  String userName = '';
  String title = '';
  String profileURL = '';

  bool isAlarm = false;
  String pushTriggerName;
  DateTime pushAlarmTime;

  String language = 'KO';

  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void setAlarmData(String name, DateTime time) {
    this.pushTriggerName = name;
    this.pushAlarmTime = time;
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
        importance: Importance.Max, priority: Priority.High);

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
}
