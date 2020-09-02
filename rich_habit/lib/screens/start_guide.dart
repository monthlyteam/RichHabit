import 'package:flutter/material.dart';
import 'package:richhabit/screens/init.dart';

class StartGuide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Center(
      child: Column(
        children: [
          Text("guide"),
          GestureDetector(
              child: Text("NEXT"),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Init(isFirst: true)))),
        ],
      ),
    ));
  }
}
