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
  /*
  addedTimeID: json['addedTimeID'],
        name: json['name'],
        iconURL: json['iconURL'],
        price: json['price'],
        usualIsWeek: json['usualIsWeek'],
        usualAmount: json['usualAmount'],
        goalIsWeek: json['goalIsWeek'],
        goalAmount: json['goalAmount'],
        nowAmount: json['nowAmount'],
   */
  var now = DateTime.now();
  Habit test = Habit(
    addedTimeID: now,
  );

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
