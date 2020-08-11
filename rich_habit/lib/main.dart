import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:richhabit/screens/init.dart';

import 'main_page.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RichHabit',
      theme: ThemeData(),
      home: MainPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
