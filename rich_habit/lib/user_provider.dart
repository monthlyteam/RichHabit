import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class UserProvider with ChangeNotifier {
  bool isLogin = false;

  String id = '';
  String userName = '';
  String title = '';
  String profileURL = '';

  bool isAlarm = false;
  DateTime pushAlarmTime;

  String language = 'KO';

  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  UserProvider() {
    //Android
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    //IOS
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);

    _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    //for when notification pressed.
    //_flutterLocalNotificationsPlugin.initialize(initializationSettings,
    //    onSelectNotification: onSelectNotification);
  }

  void setNotiPlugin(FlutterLocalNotificationsPlugin plugin) {
    this._flutterLocalNotificationsPlugin = plugin;
  }

  Future<void> setTriggerNotification() async {
    Time time =
        Time(pushAlarmTime.hour, pushAlarmTime.minute, pushAlarmTime.second);

    var android = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High);

    var ios = IOSNotificationDetails();
    var detail = NotificationDetails(android, ios);

    await _flutterLocalNotificationsPlugin.showDailyAtTime(
      0,
      'RichHabit',
      '빨리 양치해!',
      time,
      detail,
      payload: 'trigger',
    );
  }
}
