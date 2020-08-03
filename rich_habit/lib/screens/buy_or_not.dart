import 'package:flutter/material.dart';
import 'package:richhabit/constants.dart';

class BuyOrNot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: kPurpleColor,
        child: Center(
          child: Text(
            "Buy Or Not",
            style: TextStyle(color: kIvoryColor),
          ),
        ),
      ),
    );
  }
}
