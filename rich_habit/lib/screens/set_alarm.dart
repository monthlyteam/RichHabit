import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:richhabit/constants.dart';

class SetAlarmPage extends StatefulWidget {
  @override
  _SetAlarmPageState createState() => _SetAlarmPageState();
}



class _SetAlarmPageState extends State<SetAlarmPage> {
  bool isAlarmOn =true;
  bool isSoundOn =true;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPurpleColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90),
        child: AppBar(
          centerTitle: true,
          backgroundColor: kPurpleColor,
          elevation: 0,
          leading: IconButton(
            padding: EdgeInsets.only(left: 20),
            icon: Icon(Icons.arrow_back_ios,color: kWhiteIvoryColor,size: 25,),
            onPressed: (){Navigator.of(context).pop();}
          ),
          title:Text("알림",style: TextStyle(color: kWhiteIvoryColor,fontSize: 20,fontWeight: FontWeight.bold),),
        ),
      ),
      body: Column(
        children: [
          _buildContents(Icons.notifications, "알람", () {print("alarm is on");}, 0),
          _buildContents(Icons.notifications, "소리", () {print("sound is on");}, 1),
        ],
      ),
    );
  }
  _buildContents(IconData icon, String text, VoidCallback callback,index) {
    return Container(
      decoration: BoxDecoration(
          color: kIvoryColor,
          border: Border.symmetric(
              vertical:
              BorderSide(color: Colors.grey.withOpacity(0.1), width: 1))),
      height: 45,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Icon(
            icon,
            color: kPurpleColor,
            size: kTitleFontSize,
          ),
          SizedBox(width: 12),
          Text(text,
              style: TextStyle(
                  fontSize: kSubTitleFontSize - 3, color: kPurpleColor)),
          Expanded(child: SizedBox()),
          CupertinoSwitch(
            value : (index==0)?isAlarmOn:isSoundOn,
            onChanged: (bool value){
              setState(() {
                (index==0)? isAlarmOn = value : isSoundOn=value;
                callback;
              });
            },
            activeColor: Color(0xffDE711E),
            trackColor: Color(0xff7B7B7B),
          )
        ],
      ),
    );
  }
}
