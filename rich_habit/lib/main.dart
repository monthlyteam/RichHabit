import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:richhabit/habit_provider.dart';
import 'package:richhabit/screens/home.dart';
import 'package:richhabit/screens/init.dart';
import 'package:provider/provider.dart';
import 'package:richhabit/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'habit.dart';
import 'main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences sp = await SharedPreferences.getInstance();
  bool isEmpty = sp.getKeys().isEmpty;

  Map<DateTime, List<Habit>> triggerHabit = Map<DateTime, List<Habit>>();
  Map<DateTime, List<Habit>> dailyHabit = Map<DateTime, List<Habit>>();
  Map<int, List<Habit>> weeklyHabit = Map<int, List<Habit>>();

  if (!isEmpty) {
    Map<String, dynamic> json = jsonDecode(sp.getString('triggerHabit'));
    json.forEach((key, value) {
      var list = value as List;
      List<Habit> habitList = list.map((e) => Habit.fromJson(e)).toList();
      triggerHabit[DateTime.parse(key)] = habitList;
    });
  }

  Map<String, dynamic> jsonMap = {};
  jsonMap[dailyHabit.keys.toList().first.toString()] =
      dailyHabit[dailyHabit.keys.toList().first]
          .map((e) => e.toJson())
          .toList();

  var json = jsonEncode(jsonMap);

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => HabitProvider()),
          ChangeNotifierProvider(create: (_) => UserProvider()),
        ],
        child: MyApp(isEmpty),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  final bool isEmpty;

  MyApp(this.isEmpty);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RichHabit',
      theme: ThemeData(),
      home: isEmpty ? Init() : Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}
