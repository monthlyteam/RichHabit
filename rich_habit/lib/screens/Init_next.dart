import 'package:flutter/material.dart';
import 'package:richhabit/main_page.dart';

class InitNext extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: GestureDetector(
          child: Text("Go Main Page"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MainPage()),
            );
          },
        ),
      ),
    );
  }
}
