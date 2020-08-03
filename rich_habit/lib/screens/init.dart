//import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/rendering/sliver_persistent_header.dart';
import 'package:flutter_group_sliver/flutter_group_sliver.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:richhabit/screens/Init_next.dart';
import 'dart:math';

import '../constants.dart';
import '../constants.dart';
import '../constants.dart';
import '../constants.dart';
import '../constants.dart';
import '../constants.dart';
import '../constants.dart';
import '../constants.dart';
import '../constants.dart';
import '../constants.dart';
import '../constants.dart';
import '../constants.dart';
import '../constants.dart';
import '../constants.dart';
import '../constants.dart';
import '../constants.dart';
import '../constants.dart';
import '../constants.dart';
import '../constants.dart';
import '../constants.dart';
import '../constants.dart';
import '../constants.dart';
import '../constants.dart';



class Init extends StatefulWidget {

  @override
  State createState() => InitState();
}

class InitState extends State<Init>{

  Size size;
  List<SvgPicture> icons;
  List<Text> icons_name;
  List<bool> icons_selected;
  @override
  void initState() {
    super.initState();
    icons = new List<SvgPicture>();
    icons_name = new List<Text>();
    icons.add(new SvgPicture.asset('images/icon/beer.svg'));
    icons.add(new SvgPicture.asset('images/icon/beer.svg'));
    icons.add(new SvgPicture.asset('images/icon/beer.svg'));
    icons.add(new SvgPicture.asset('images/icon/coffee.svg'));
    icons.add(new SvgPicture.asset('images/icon/beer.svg'));
    icons.add(new SvgPicture.asset('images/icon/smoking.svg'));
    icons.add(new SvgPicture.asset('images/icon/smoking.svg'));
    icons.add(new SvgPicture.asset('images/icon/coffee.svg'));
    icons.add(new SvgPicture.asset('images/icon/smoking.svg'));
    icons.add(new SvgPicture.asset('images/icon/beer.svg'));
//    icons.add(new SvgPicture.asset('images/icon/plus.svg',color: kPurpleColor));
    TextStyle txtstyle = TextStyle(fontSize: 10, color: kPurpleColor, fontWeight: FontWeight.w600);
    icons_name.add(Text("음주",style: txtstyle));
    icons_name.add(Text("음주",style: txtstyle));
    icons_name.add(Text("커피",style: txtstyle));
    icons_name.add(Text("커피",style: txtstyle));
    icons_name.add(Text("음주",style: txtstyle));
    icons_name.add(Text("커피",style: txtstyle));
    icons_name.add(Text("흡연",style: txtstyle));
    icons_name.add(Text("커피",style: txtstyle));
    icons_name.add(Text("추가",style: txtstyle));
    icons_name.add(Text("추가",style: txtstyle));
    icons_selected = List<bool>.generate(icons_name.length, (index) => false);
//    for(var i=0;i < 3;i++){
//      this.icons += Image.asset()
//    }
  }

  Future<double> whenNotZero(Stream<double> source) async{
    await for (double value in source){
      if(value>0) return value;
      
    }
  }
  void flutterToast(){
    Fluttertoast.showToast(msg: 'Flutter',
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.redAccent,
        fontSize: 20.0,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT
    );
  }

  List<String> _selectedListGenerator(List<bool> selectedList){
    List<String> list = List<String>();
    for(var i=0;i<selectedList.length;i++){
      if(selectedList[i]==true) list.add(icons_name[i].data);
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<double>(
      future: whenNotZero(Stream<double>.periodic(Duration(microseconds: 100),
          (x) => MediaQuery.of(context).size.width
      )),
      builder: (context, snapshot) {
        if(snapshot.hasData){
          size = MediaQuery.of(context).size;

          return Scaffold(
              backgroundColor: kPurpleColor,
              resizeToAvoidBottomPadding: false,
              body : Stack(
                children: [
                  CustomScrollView(
                    shrinkWrap: true,
                    slivers: <Widget>[
                      SliverPersistentHeader(
                        pinned : false,
                        floating: true,
                        delegate: InitPageHeader(
                          minExtent : 220.0,
                          maxExtent : 300.0,
                        ),
                      ),
                      SliverGroupBuilder(
                        decoration: BoxDecoration(
                          color: kIvoryColor,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        padding: EdgeInsets.fromLTRB(10,20,10,70),//?뭔가이상함
                        child: SliverGrid(
                          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 300.0,
                            mainAxisSpacing: 20.0,
                            crossAxisSpacing: 20.0,
  //                  childAspectRatio: .0,
                          ),
                          delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                              return Column(
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        icons_selected[index] = !icons_selected[index];
                                      });
                                    },
                                    child: Container(
//                      padding: EdgeInsets.fromLTRB(10, 10, , bottom),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: kWhiteIvoryColor
                                      ),
                                      height: 160,
                                      width: 160,
//                      margin: EdgeInsets.fromLTRB(15,10,15,10),
                                      alignment: Alignment.center,

                                      child : Stack(
                                        children:
                                          icons_selected[index] ?
                                          [Center(child:
                                              icons[index]),
                                              Container(
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.black.withOpacity(0.5),
                                                ),
                                                height:160,
                                                width: 160
                                              )]
                                          : [Center(child: icons[index])],
                                      ),
                                    ),
                                  ),
                                  icons_name[index],
                                ],
                              );
                            },
                            childCount: icons_name.length,
                          ),
                        ),
                      ),
  //            Sliver
                    ],
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: GestureDetector(
                      onTap: () {
                        if(icons_selected.indexOf(true) == -1){
                          Fluttertoast.showToast(
                              msg: "최소 한개를 선택해주세요!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.grey,
                              textColor: Colors.white,
                              fontSize: 16.0
                          );
                        }else{
                          Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => InitNext(selectedItem: _selectedListGenerator(icons_selected),)));
                        }
                      },
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
                          child: Text("다 체크 했어요!  →",style: TextStyle(fontSize: kTitleFontSize,color: kWhiteIvoryColor,fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
        }else{
          return CircularProgressIndicator();
        }

      }
    );
  }

}

class InitPageHeader implements SliverPersistentHeaderDelegate{

  final double minExtent;
  final double maxExtent;

  InitPageHeader({
    this.minExtent,
    @required this.maxExtent,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {

    return Container(
        padding: EdgeInsets.only(left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 50),
            GestureDetector(child:Icon(Icons.arrow_back_ios, color: kWhiteIvoryColor,size: 20), onTap: (){
              //가장 처음화면으로 돌아가기
            }),
            SizedBox(height: 20,),
            Text("습관 입력하기",style: TextStyle(fontSize: kTitleFontSize, color: kWhiteIvoryColor,fontWeight: FontWeight.bold)),
            SizedBox(height: 11,),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(1)),
                color: kWhiteIvoryColor
              ),
              height: 3,
              width: 33,
            ),
            SizedBox(height: 11),
            Container(
              width: 280,
              child: Text("평소에 습관적으로 지출 하던 항목들을 전부 체크해주세요.",style: TextStyle(fontSize: 17,color: kWhiteIvoryColor,fontWeight: FontWeight.w300))
            ),
          ],
        ),
      );

    throw UnimplementedError();
  }

  double headerOpacity(double shrinkOffset){
//    return 1.0 - max(0.0,shrinkOffset) / maxExtent;
    return 1-max(0.0,shrinkOffset) / maxExtent;
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;

  @override
  // TODO: implement snapConfiguration
  FloatingHeaderSnapConfiguration get snapConfiguration => null;

  @override
  // TODO: implement stretchConfiguration
  OverScrollHeaderStretchConfiguration get stretchConfiguration => null;

}

//이모티콘 아래 글자크기 키웠을때 BottomOverflow 고쳐야함


