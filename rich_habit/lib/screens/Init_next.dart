import 'package:flutter/material.dart';
import 'package:richhabit/main_page.dart';

class InitNext extends StatelessWidget {
  List<String> selectedItem;

  InitNext({@required this.selectedItem});
  @override
  Widget build(BuildContext context) {
    return Column(
        children:List<Text>.generate(selectedItem.length, (index) => Text(selectedItem[index])));
  }
}

//https://github.com/flutter/flutter/issues/18846
//https://medium.com/flutterpub/flutter-keyboard-actions-and-next-focus-field-3260dc4c694
//          onTap: () {
//            Navigator.push(
//              context,
//              MaterialPageRoute(builder: (context) => MainPage()),
//            );
//          },
