import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:richhabit/constants.dart';

import '../user_provider.dart';

class SetAlarmPage extends StatefulWidget {
  @override
  _SetAlarmPageState createState() => _SetAlarmPageState();
}

class _SetAlarmPageState extends State<SetAlarmPage> {
  bool isAlarmOn;
  bool isSoundOn = true;

  @override
  void initState() {
    super.initState();

    isAlarmOn = context.read<UserProvider>().isAlarm;
  }

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
              icon: Icon(
                Icons.arrow_back_ios,
                color: kWhiteIvoryColor,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          title: Text(
            "알림",
            style: TextStyle(
                color: kWhiteIvoryColor,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Column(
        children: [
          _buildContents(Icons.notifications, "알람", () {
            context.read<UserProvider>().setisAlarm(isAlarmOn);
            if (isAlarmOn) {
              context.read<UserProvider>().setTriggerNotification();
            } else {
              context.read<UserProvider>().resetNotification();
            }
          }, 0),
        ],
      ),
    );
  }

  _buildContents(IconData icon, String text, VoidCallback callback, index) {
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
            value: (index == 0) ? isAlarmOn : isSoundOn,
            onChanged: (bool value) {
              if (!isAlarmOn && index == 1) {
                //알람이꺼져있고, 클릭한게 소리에 관한거라면 반응안함.
              } else {
                setState(() {
                  if (index == 0) {
                    //알람이 움직이면 소리도 같이 움직임
                    isAlarmOn = value;
                    isSoundOn = isAlarmOn; //알람 바꾸면 소리도 자동으로 바뀜
                  } else {
                    isSoundOn = value;
                  }
                  callback();
                });
              }
            },
            activeColor: Color(0xffDE711E),
            trackColor: Color(0xff7B7B7B),
          )
        ],
      ),
    );
  }
}
