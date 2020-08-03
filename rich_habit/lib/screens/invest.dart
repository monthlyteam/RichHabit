import 'package:flutter/material.dart';
import 'package:richhabit/constants.dart';

class Invest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: kPurpleColor,
        child: Center(
          child: Text(
            "invest",
            style: TextStyle(color: kIvoryColor),
          ),
        ),
      ),
    );
  }
}
