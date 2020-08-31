import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:richhabit/constants.dart';
import 'package:richhabit/screens/init.dart';
import 'package:richhabit/screens/set_alarm.dart';
import 'package:provider/provider.dart';
import 'package:richhabit/habit_provider.dart';
import 'package:richhabit/user_provider.dart';
import '../constants.dart';

class Profile extends StatelessWidget {
//  String profileMessage;
//  String name;
//  String language;
//  AssetImage profileImage;
  bool isAlarmOn;

//  ProfileData profileData;
//  Profile({this.profileData});
//  Profile() {
//    profileMessage = "절약해서 100억 한번 벌어보자";
//    profileImage = AssetImage("assets/example/profileImage.jpg");
//    name = "장영환";
//    language = "한국어";
//  }

  @override
  Widget build(BuildContext context) {
//    profileMessage = profileData.profileMessage;
//    profileImage = profileData.image;
//    name = profileData.name;
//    language = profileData.language;
//    bool isAlarmOn = profileData.isAlarmOn;
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(color: kPurpleColor),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "설정",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: kTitleFontSize,
                          color: kWhiteIvoryColor),
                    ),
                    SizedBox(
                      height: 30,
                    ),
//                    Row( //프로필 사진, 이름 ,메시지 표시하는 부분
//                      crossAxisAlignment: CrossAxisAlignment.start,
//                      children: [
//                        Container(
//                            padding: null,
//                            height: 80,
//                            width: 80,
//                            decoration: BoxDecoration(
//                                border: null,
//                                shape: BoxShape.circle,
//                                image: DecorationImage(
//                                  image: profileImage,
//                                  fit: BoxFit.cover,
//                                ))),
//                        SizedBox(
//                          width: 10,
//                        ),
//                        Column(
//                          crossAxisAlignment: CrossAxisAlignment.start,
//                          children: [
//                            Row(
//                              children: [
//                                Text(
//                                  name,
//                                  style: TextStyle(
//                                      fontSize: kTitleFontSize,
//                                      color: kWhiteIvoryColor,
//                                      fontWeight: FontWeight.bold),
//                                ),
//                                SizedBox(
//                                  width: 6,
//                                ),
//                                GestureDetector(
//                                  child: Icon(
//                                    Icons.edit,
//                                    size: kTitleFontSize,
//                                    color: kWhiteIvoryColor,
//                                  ),
//                                )
//                              ],
//                            ),
//                            SizedBox(
//                              height: 5,
//                            ),
//                            Text(
//                              "\"$profileMessage\"",
//                              style: TextStyle(
//                                  fontSize: kNormalFontSize,
//                                  fontWeight: FontWeight.w200,
//                                  color: kWhiteIvoryColor),
//                            )
//                          ],
//                        )
//                      ],
//                    ),
                  ],
                )),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
//                _buildContents(Icons.lock, "계정", () {}),
                _buildContents(Icons.cached, "문의 & 피드백", () {}),
//                Container( //컨텐츠별 간격
//                  color: kPurpleColor,
//                  height: 25,
//                ),
                _buildContents(Icons.notifications, "알람", () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SetAlarmPage()));
                },
                    subData:
                        context.watch<UserProvider>().isAlarm ? "켜짐" : "꺼짐"),
//                    subData: true ? "켜짐" : "꺼짐"),
//                _buildContents(Icons.language, "언어", () {
//                  Navigator.push(context, MaterialPageRoute(builder: (context)=>SetLanguagePage()));
//                }, subData: language),
                Container(
                  color: kPurpleColor,
                  height: 25,
                ),
                GestureDetector(
                  onTap: () {
                    _showAddDialog(context);
                  },
                  child: Container(
                    height: 50,
                    color: kIvoryColor,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Text("데이터 초기화",
                            style: TextStyle(
                                fontSize: kSubTitleFontSize - 3,
                                color: Colors.red)),
                        Expanded(child: SizedBox()),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: kPurpleColor,
                          size: kSubTitleFontSize,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  _buildContents(IconData icon, String text, VoidCallback callback,
      {String subData}) {
    return GestureDetector(
      onTap: callback,
      child: Container(
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
            (subData == null)
                ? Container()
                : Text(subData,
                    style: TextStyle(
                        fontSize: kSubTitleFontSize - 3,
                        color: Colors.grey,
                        fontWeight: FontWeight.w200)),
            SizedBox(
              width: 10,
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: kPurpleColor,
              size: kSubTitleFontSize,
            )
          ],
        ),
      ),
    );
  }

  _showAddDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: kIvoryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
                height: 206,
                width: 320,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: 156,
                      padding: EdgeInsets.fromLTRB(26, 15, 26, 13),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "정말 초기화 하시겠습니까?.",
                              style: TextStyle(
                                  color: kPurpleColor,
                                  fontSize: kSubTitleFontSize),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              height: 45,
                              child: FittedBox(
                                fit: BoxFit.cover,
                                child: Column(
                                  children: [
                                    Text("데이터를 초기화하면",
                                        style: TextStyle(color: kPurpleColor)),
                                    Text("모든 기록이 지워집니다.",
                                        style: TextStyle(color: kPurpleColor)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: kPurpleColor),
                      child: Row(
                        children: [
                          Expanded(
                              child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              child: Center(
                                  child: Text(
                                "취소",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: kWhiteIvoryColor),
                              )),
                            ),
                          )),
                          Container(
                              height: 14,
                              width: 4,
                              child: VerticalDivider(
                                width: 4,
                                color: kIvoryColor,
                              )),
                          Expanded(
                              child: GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
                                    context.read<UserProvider>().resetData();
                                    context.read<HabitProvider>().resetData();
                                    Fluttertoast.showToast(
                                        msg: "데이터가 초기화 되었습니다.",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.grey,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                    Navigator.of(context, rootNavigator: true)
                                        .pushReplacement(MaterialPageRoute(
                                            builder: (context) => Init(
                                                  isFirst: true,
                                                )));
                                  },
                                  child: Center(
                                    child: Text(
                                      "초기화",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Color(0xFFDE711E),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )))
                        ],
                      ),
                    ),
                  ],
                )),
          );
        });
  }
}
