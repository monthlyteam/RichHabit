import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:richhabit/habit_provider.dart';
import 'package:richhabit/main_page.dart';
import 'package:richhabit/screens/init.dart';
import 'package:provider/provider.dart';
import 'package:richhabit/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'habit.dart';
import 'test_data.dart';

void main() async {
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isEmpty;
  SharedPreferences sp;

  Map<DateTime, List<Habit>> triggerHabit = Map<DateTime, List<Habit>>();
  Map<DateTime, List<Habit>> dailyHabit = Map<DateTime, List<Habit>>();
  Map<int, List<Habit>> weeklyHabit = Map<int, List<Habit>>();
  Map<DateTime, List<int>> calendarIcon = Map<DateTime, List<int>>();

  String pushTriggerName;
  DateTime pushAlarmTime;
  bool isAlarm = true;

  Future<bool> get() async {
    //Get Local DB data
    sp = await SharedPreferences.getInstance();
    isEmpty = sp.getKeys().isEmpty;
    //TODO: Must Erase Test Data after debug
    //testData Start
    if (isEmpty) {
      TestData.getData(sp);
      isEmpty = false;
      print("main.dart: Get TestData DONE");
    }
    //TestData Finish
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
          future: get(),
          builder: (context, snapshot) {
            if (isEmpty == null) {
              return CircularProgressIndicator();
            } else {
              if (!isEmpty) {
                List<Habit> habitList = [];

                if (sp.containsKey('trigger')) {
                  Map<String, dynamic> json =
                      jsonDecode(sp.getString('trigger'));

                  json.forEach((key, value) {
                    var list = value as List;
                    habitList = list.map((e) => Habit.fromJson(e)).toList();
                    triggerHabit[DateTime.parse(key)] = habitList;
                  });
                }

                if (sp.containsKey('daily')) {
                  Map<String, dynamic> json = jsonDecode(sp.getString('daily'));

                  json.forEach((key, value) {
                    var list = value as List;
                    habitList = list.map((e) => Habit.fromJson(e)).toList();
                    dailyHabit[DateTime.parse(key)] = habitList;
                  });
                }

                if (sp.containsKey('weekly')) {
                  Map<String, dynamic> json =
                      jsonDecode(sp.getString('weekly'));

                  json.forEach((key, value) {
                    var list = value as List;
                    habitList = list.map((e) => Habit.fromJson(e)).toList();
                    weeklyHabit[int.parse(key)] = habitList;
                  });
                }

                if (sp.containsKey('calendar')) {
                  Map<String, dynamic> json =
                      jsonDecode(sp.getString('calendar'));

                  json.forEach((key, value) {
                    calendarIcon[DateTime.parse(key)] = [value[0]];
                  });

                  if (sp.containsKey('alarm')) {
                    Map<String, dynamic> json =
                        jsonDecode(sp.getString('alarm'));

                    pushTriggerName = json['name'];
                    pushAlarmTime = DateTime.parse(json['time']);
                    isAlarm = json['isalarm'] == 1 ? true : false;
                  }
                }
              }
              return MultiProvider(
                providers: [
                  ChangeNotifierProvider(
                      create: (_) => HabitProvider(
                          sp: sp,
                          triggerHabit: triggerHabit,
                          dailyHabit: dailyHabit,
                          weeklyHabit: weeklyHabit,
                          calendarIcon: calendarIcon)),
                  ChangeNotifierProvider(
                      create: (_) => UserProvider(
                          sp: sp,
                          pushTriggerName: pushTriggerName,
                          pushAlarmTime: pushAlarmTime,
                          isAlarm: isAlarm)),
                ],
                child: MaterialApp(
                  builder: (context, child) {
                    return MediaQuery(
                      child: child,
                      data:
                          MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                    );
                  },
                  title: 'RichHabit',
                  theme: ThemeData(
                      textTheme: GoogleFonts.notoSansTextTheme(
                    Theme.of(context).textTheme,
                  )),
                  home: isEmpty ? Init(isFirst: true) : MainPage(),
                  debugShowCheckedModeBanner: false,
                ),
              );
            }
          }),
    );
  }
}
