import 'package:flutter/material.dart';
import 'package:richhabit/screens/Init_next.dart';

class Init extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: GestureDetector(
          child: Text("Go Init Next"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => InitNext()),
            );
          },
        ),
      ),
    );
  }
}
