import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:richhabit/habit_provider.dart';
import 'package:richhabit/screens/init.dart';
import 'package:provider/provider.dart';
import 'package:richhabit/user_provider.dart';

import 'habit.dart';
import 'main_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Map<DateTime, List<Habit>> dailyHabit = Map<DateTime, List<Habit>>();

  var now = DateTime.now();
  Habit test1 = Habit(
      addedTimeID: now,
      name: 'Habit1',
      iconURL: 'assets/images/icon/custom_coin.svg',
      price: 1000,
      usualIsWeek: false,
      usualAmount: 5,
      goalIsWeek: false,
      goalAmount: 1,
      nowAmount: 0);
  Habit test2 = Habit(
      addedTimeID: now,
      name: 'Habit2',
      iconURL: 'assets/images/icon/custom_coin.svg',
      price: 1000,
      usualIsWeek: false,
      usualAmount: 5,
      goalIsWeek: false,
      goalAmount: 1,
      nowAmount: 0);
  Habit test3 = Habit(
      addedTimeID: now,
      name: 'Habit3',
      iconURL: 'assets/images/icon/custom_coin.svg',
      price: 1000,
      usualIsWeek: false,
      usualAmount: 5,
      goalIsWeek: false,
      goalAmount: 1,
      nowAmount: 0);
  Habit test4 = Habit(
      addedTimeID: now,
      name: 'Habit4',
      iconURL: 'assets/images/icon/custom_coin.svg',
      price: 1000,
      usualIsWeek: false,
      usualAmount: 5,
      goalIsWeek: false,
      goalAmount: 1,
      nowAmount: 0);

  dailyHabit[DateTime(now.year, now.month, now.day)] = [test1];
  dailyHabit[DateTime(now.year, now.month, now.day)].add(test2);
  dailyHabit[DateTime(now.year, now.month, now.day).add(Duration(days: 1))] = [
    test3
  ];
  dailyHabit[DateTime(now.year, now.month, now.day).add(Duration(days: 1))]
      .add(test4);

  dailyHabit[DateTime(now.year, now.month, now.day).add(Duration(days: 2))] =
      [];
  print(
      'dailyHabit : ${dailyHabit[DateTime(now.year, now.month, now.day).add(Duration(days: 2))]}');
  dailyHabit.forEach((key, value) {
    value.forEach((element) {
      print('element: ${element.name}');
    });
  });

  print('daily: $dailyHabit');

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => HabitProvider()),
          ChangeNotifierProvider(create: (_) => UserProvider()),
        ],
        child: MyApp(),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RichHabit',
      theme: ThemeData(),
      home: Init(),
      debugShowCheckedModeBanner: false,
    );
  }
}
