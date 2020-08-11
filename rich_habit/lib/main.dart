import 'package:flutter/material.dart';
import 'package:richhabit/screens/init.dart';
import 'main_page.dart';
import 'screens/profile.dart';

void main() {
  runApp(MyApp());
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

  Future<double> whenNotZero(Stream<double> source) async{
    await for (double value in source){
      if(value>0) return value;
    }
  }
}
