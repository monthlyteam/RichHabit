import 'package:flutter/material.dart';
import 'package:richhabit/constants.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: kPurpleColor,
        child: Center(
          child: Text(
            "Home",
            style: TextStyle(color: kIvoryColor),
          ),
        ),
      ),
    );
  }
}
