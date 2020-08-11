import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:richhabit/constants.dart';
import 'package:richhabit/main_page.dart';

class InitNext extends StatelessWidget {
  List<String> selectedItem;

  InitNext({@required this.selectedItem});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kIvoryColor,
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20,top: 50,bottom: 10),
              child: GestureDetector(
                  child:Icon(Icons.arrow_back_ios, color: kPurpleColor,size: 20), onTap: (){
                //가장 처음화면으로 돌아가기
                }
              ),
            ),
            Center(
              child: Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: kWhiteIvoryColor
                ),
                child: Center(
                  child: SvgPicture.asset('images/icon/custom_coin.svg',width: 70,), //습관정보 받아서 유동적으로 바뀌어야함
                ),
              ),
            ),
            SizedBox(height: 10,),
            Center(
              child: Text("흡연",style: TextStyle(fontSize: 25,color: kPurpleColor,fontWeight: FontWeight.bold),),
            ),
            SizedBox(height: 9.5,),
            Center(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(1)),
                    color: kPurpleColor
                ),
                height: 3,
                width: 33,
              ),
            ),
            SizedBox(
              height: 13.5,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top:Radius.circular(25)),
                  color: kWhiteIvoryColor
                ),
                padding: EdgeInsets.fromLTRB(20, 29.5, 20, 100),
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  children: [
                    Row(
                      children: [
                        SizedBox(height: 29.5,),
                        Text("①  평소 얼마나 자주 흡연을 하십니까?",style: TextStyle(color: kPurpleColor,fontSize: 16),),
                        SizedBox(height: 5.5,),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
    );

  }
}

//https://github.com/flutter/flutter/issues/18846
//https://medium.com/flutterpub/flutter-keyboard-actions-and-next-focus-field-3260dc4c694
