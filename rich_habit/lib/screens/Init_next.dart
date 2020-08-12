import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:richhabit/constants.dart';
import 'package:richhabit/main_page.dart';
import 'package:richhabit/widget/bottom_positioned_box.dart';

class InitNext extends StatelessWidget {

  final List<List<dynamic>> selectedItem;
  PageController pageController;
  InitNext({@required this.selectedItem});

  @override
  Widget build(BuildContext context) {
    pageController = new PageController();
    return Scaffold(
      backgroundColor: kIvoryColor,
      body: Stack(
        children: [
          PageView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context,position){
              return _buildPage(context,position);
            },itemCount: selectedItem.length,
            controller: pageController,
          ),
        ],
      ),
    );
  }

  Stack _buildPage(BuildContext context,int index){
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20,top: 50,bottom: 10),
              child: GestureDetector(
                  child:Container(
                    width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: kIvoryColor
                      ),
                      child: Center(child: Icon(Icons.arrow_back_ios, color: kPurpleColor,size: 20))), onTap: (){
                    if(index==0){
                      Navigator.of(context).pop();
                    }else{
                      pageController.animateToPage(pageController.page.toInt()-1, duration: Duration(milliseconds: 400), curve: Curves.easeInOut);
                    }
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
                  child: selectedItem[index][1],
                ),
              ),
            ),
            SizedBox(height: 10,),
            Center(
              child: Text(selectedItem[index][0],style: TextStyle(fontSize: 25,color: kPurpleColor,fontWeight: FontWeight.bold),),
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
                        Text("①  평소 얼마나 자주 소비하십니까?",style: TextStyle(color: kPurpleColor,fontSize: 16),),
                        SizedBox(height: 5.5,),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        (index == selectedItem.length-1)?
          BottomPositionedBox("완료",(){
//            if(){
//              입력안된 인덱스 있으면 거기로 점프
//            }else if(){
//              입력안된 인덱스 없으면 provider로 값 넘겨줌
//            }
            Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage()));
          })
          :BottomPositionedBox("다음",(){
            pageController.animateToPage(pageController.page.toInt()+1,duration: Duration(milliseconds: 400),curve: Curves.easeInOut);//다음페이지로 넘어가는거 만들면됨
        })
      ],
    );
  }

  Future<void> _changePage() {

  }
}

//https://github.com/flutter/flutter/issues/18846
//https://medium.com/flutterpub/flutter-keyboard-actions-and-next-focus-field-3260dc4c694
