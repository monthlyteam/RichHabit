import 'package:flutter/material.dart';
import 'package:richhabit/constants.dart';

import '../constants.dart';
import '../constants.dart';


class Profile extends StatelessWidget {


  String profileMessage;
  String name;
  String language;
  AssetImage profileImage;
  bool isAlarmOn;

//  ProfileData profileData;
//  Profile({this.profileData});

  @override
  Widget build(BuildContext context) {

    profileMessage = "절약해서 100억 한번 벌어보자";
    profileImage = AssetImage("assets/example/profileImage.jpg");
    name = "장영환";
    language = "한국어";
    bool isAlarmOn = true;

//    profileMessage = profileData.profileMessage;
//    profileImage = profileData.image;
//    name = profileData.name;
//    language = profileData.language;
//    bool isAlarmOn = profileData.isAlarmOn;


    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: kPurpleColor
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(20,40,20,50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("내 계정",style: TextStyle(fontWeight: FontWeight.bold,fontSize: kTitleFontSize+5,color: kIvoryColor),),
                  SizedBox(height: 30,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: null,
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          border: null,
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image : profileImage,
                            fit: BoxFit.cover,
                          )
                        )
                      ),
                      SizedBox(width: 10,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(name,style: TextStyle(fontSize: kTitleFontSize, color: kIvoryColor,fontWeight: FontWeight.bold),),
                              SizedBox(width: 6,),
                              GestureDetector(
                                child: Icon(Icons.edit,size: kTitleFontSize,color: kIvoryColor,),
                              )
                            ],
                          ),
                          SizedBox(height: 5,),
                          Text("\"$profileMessage\"",style: TextStyle(fontSize: kNormalFontSize, fontWeight: FontWeight.w200,color: kIvoryColor),)
                        ],
                      )
                    ],
                  ),
                ],
              )
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildContents(Icons.lock, "계정", () {}),
                _buildContents(Icons.cached, "문의 & 피드백", () {}),
                Container(
                  color: kPurpleColor,
                  height: 25,
                ),
                _buildContents(Icons.notifications, "알람", () {}, subData: isAlarmOn?"켜짐":"꺼짐"),
                _buildContents(Icons.language, "언어", () {}, subData: language),
                Container(
                  color: kPurpleColor,
                  height: 25,
                ),
                GestureDetector(
                  onTap: (){},
                  child: Container(
                    height: 50,
                    color: kIvoryColor,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Text("데이터 초기화",style: TextStyle(fontSize: kSubTitleFontSize-3, color: Colors.red)),
                        Expanded(
                            child:SizedBox()
                        ),
                        Icon(Icons.arrow_forward_ios, color: kPurpleColor,size: kSubTitleFontSize,),
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

  _buildContents(IconData icon, String text, VoidCallback callback, {String subData}){
    return GestureDetector(
      onTap: callback,
      child: Container(
        decoration: BoxDecoration(
          color: kIvoryColor,
          border: Border.symmetric(vertical: BorderSide(
            color: Colors.grey.withOpacity(0.1),
            width: 1
          ))
        ),
        height: 45,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Icon(icon, color: kPurpleColor,size: kTitleFontSize,),
            SizedBox(width: 12),
            Text(text,style: TextStyle(fontSize: kSubTitleFontSize-3, color: kPurpleColor)),
            Expanded(
                child:SizedBox()
            ),
            (subData == null)? Container(): Text(subData,style: TextStyle(fontSize: kSubTitleFontSize-3, color: Colors.grey,fontWeight: FontWeight.w200)),
            SizedBox(width: 10,),
            Icon(Icons.arrow_forward_ios, color: kPurpleColor,size: kSubTitleFontSize,)
          ],
        ),
      ),
    );
  }

}
