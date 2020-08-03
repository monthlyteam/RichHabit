import 'package:flutter/material.dart';
import 'package:richhabit/constants.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: kPurpleColor,
        child: Center(
          child: Text(
            "profile",
            style: TextStyle(color: kIvoryColor),
          ),
        ),
      ),
    );
  }
}
