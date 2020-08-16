import 'package:flutter/material.dart';
import 'package:richhabit/constants.dart';

class BottomPositionedBox extends StatelessWidget{
  final String txt;
  final VoidCallback onTap;
  BottomPositionedBox(this.txt,this.onTap);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration:BoxDecoration(
            color: kPurpleColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(19)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          width: size.width,
          height: 80,
          child: Center(
            child: Text(txt,style: TextStyle(fontSize: 20,color: kWhiteIvoryColor,fontWeight: FontWeight.w600)),
          ),
        ),
      ),
    );
  }
}