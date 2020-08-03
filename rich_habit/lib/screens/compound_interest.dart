import 'package:flutter/material.dart';
import 'package:richhabit/constants.dart';

class CompoundInterest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: kPurpleColor,
        child: Center(
          child: Text(
            "Compound Interest",
            style: TextStyle(color: kIvoryColor),
          ),
        ),
      ),
    );
  }
}
