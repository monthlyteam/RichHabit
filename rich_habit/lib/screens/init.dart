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


class Init extends StatefulWidget {

  @override
  State createState() => InitState();
}

class InitState extends State<Init>{

  Size size;
  List<SvgPicture> icons;
  List<Text> icons_name;
  List<bool> icons_selected;
  final textFieldController = TextEditingController();

  TextStyle txtstyle;
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
    icons.add(new SvgPicture.asset('images/icon/plus.svg'));
    txtstyle = TextStyle(fontSize: 15, color: kPurpleColor, fontWeight: FontWeight.w600);
    icons_name.add(Text("음주",style: txtstyle));
    icons_name.add(Text("음주",style: txtstyle));
    icons_name.add(Text("커피",style: txtstyle));
    icons_name.add(Text("커피",style: txtstyle));
    icons_name.add(Text("음주",style: txtstyle));
    icons_name.add(Text("커피",style: txtstyle));
    icons_name.add(Text("흡연",style: txtstyle));
    icons_name.add(Text("커피",style: txtstyle));
    icons_name.add(Text("흡연",style: txtstyle));
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
                        pinned : true,
                        floating: true,
                        delegate: InitPageHeader(
                          minExtent : 220.0,
                          maxExtent : 300.0,
                        ),
                      ),
                      SliverGroupBuilder(
                        decoration: BoxDecoration(
                          color: kIvoryColor,
                          borderRadius: BorderRadius.vertical(top:Radius.circular(20)),
                        ),
                        child: SliverGrid(
                          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent:size.width/2,
                            mainAxisSpacing: 10.0,
                            crossAxisSpacing:20.0,
//                            childAspectRatio: size.width-40/(190+15), // 가로/세로
                            childAspectRatio: 0.85, // 가로/세로
                          ),
                          delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                                  return Container(
                                    padding: EdgeInsets.only(top: 20),
                                    child: Column(
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: () {
                                            if(index == icons.length-1){
                                              _showAddDialog(context);
                                            }else{
                                              setState(() {
                                                icons_selected[index] =
                                                !icons_selected[index];
                                              });
                                            }
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: kWhiteIvoryColor,
                                            ),
                                            height: 160,
                                            width: 160,
//                      margin: EdgeInsets.fromLTRB(15,10,15,10),
                                            alignment: Alignment.center,

                                            child: Stack(
                                              children:
                                              icons_selected[index] ?
                                              [Center(child:
                                              icons[index]),
                                                Container(
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.black
                                                          .withOpacity(0.5),
                                                    ),
                                                    height: 160,
                                                    width: 160
                                                )
                                              ]
                                                  : [
                                                Center(child: icons[index])
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10,),
                                        icons_name[index],
                                      ],
                                    ),
                                  );
                            },
                            childCount: icons_name.length,
                          ),
                        ),
                      ),
                      SliverAppBar(backgroundColor: kIvoryColor)
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
  _showAddDialog(BuildContext context){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: kIvoryColor,
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 226,
              width: 320,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 176,
                    padding: EdgeInsets.fromLTRB(41,15,41,13),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 80,
                          width: 80,
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: kWhiteIvoryColor,
                          ),
                          child: Image.asset('images/coin_1.png',fit: BoxFit.cover,),
                        ),
                        SizedBox(height: 10.5,),
                        RichText(
                          text: TextSpan(
                            text:'새로운 습관의 ',
                            style: TextStyle(fontSize: 16,color: kPurpleColor),
                            children: <TextSpan>[
                              TextSpan(text: '이름', style: TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(text : '을 입력해 주세요!')
                            ]
                          ),
                        ),
                        SizedBox(height: 8.5,),
                        Container(
                          height: 25,
                          width: 240,
                          child: TextField(
                            style: TextStyle(color: kPurpleColor),
                            controller: textFieldController,
                            decoration: new InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: kDarkPurpleColor, width: 1.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: kPurpleColor.withOpacity(0.5), width: 1.0),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: kPurpleColor
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: (){
                              print(textFieldController.text);
                              textFieldController.clear();
                              Navigator.pop(context);
                            },
                            child: Container(

                              child : Center(child: Text("취소", style: TextStyle(fontSize: kSubTitleFontSize,fontWeight: FontWeight.bold,color: Color(0xFFDE711E)),)),
                            ),
                          )
                        ),
                        Container(
                          height: 14,
                          width: 4,
                          child: VerticalDivider(
                            width: 4,
                            color: kIvoryColor,
                          )
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: (){
                            Navigator.pop(context);
                            setState((){
                            icons.insert(icons.length-1,new SvgPicture.asset('images/imsi.svg',fit: BoxFit.cover,));
                            icons_name.insert(icons_name.length-1,Text(textFieldController.text,style: txtstyle));
                            icons_selected.insert(icons_selected.length-1,true);
                            });
                            textFieldController.clear();
                            },
                            child: Center(
                              child: Text("저장",style: TextStyle(fontSize: kSubTitleFontSize,color: kIvoryColor,fontWeight: FontWeight.bold),),
                            )

                          )
                        )
                      ],
                    ),
                  ),
                ],
              )
            ),
          );
        });
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
    Color txtColor = kWhiteIvoryColor.withOpacity(headerOpacity(shrinkOffset));
    return Container(
        padding: EdgeInsets.only(left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 50),
            GestureDetector(child:Icon(Icons.arrow_back_ios, color: txtColor,size: 20), onTap: (){
              //가장 처음화면으로 돌아가기
            }),
            SizedBox(height: 20,),
            Text("습관 입력하기",style: TextStyle(fontSize: kTitleFontSize, color:txtColor, fontWeight: FontWeight.bold)),
            SizedBox(height: 11,),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(1)),
                color: txtColor
              ),
              height: 3,
              width: 33,
            ),
            SizedBox(height: 11),
            Container(
              width: 280,
              child: Text("평소에 습관적으로 지출 하던 항목들을 전부 체크해주세요.",style: TextStyle(fontSize: 17,color: txtColor,fontWeight: FontWeight.w300))
            ),
          ],
        ),
      );

    throw UnimplementedError();
  }

  double headerOpacity(double shrinkOffset){
    return max(0,1-shrinkOffset / (maxExtent-minExtent+70));
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
//옆에 Stack헀더니 TopRight BerderRadius 어디감?


