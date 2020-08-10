import 'package:flutter/material.dart';
import 'package:richhabit/noti_test.dart';
import 'package:richhabit/screens/init.dart';
import 'main_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RichHabit',
      theme: ThemeData(),
      home: NotiTest(),
      debugShowCheckedModeBanner: false,
    );
  }
}
