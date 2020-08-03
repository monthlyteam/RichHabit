import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/rendering/sliver_persistent_header.dart';
import 'package:flutter_group_sliver/flutter_group_sliver.dart';
import 'package:flutter_svg/flutter_svg.dart';
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



class Init extends StatefulWidget {

  @override
  State createState() => InitState();
}

class InitState extends State<Init>{

  List<SvgPicture> icons;
  List<Text> icons_name;
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
//    icons.add(new SvgPicture.asset('images/icon/plus.svg',color: kDarkPurpleColor));
    TextStyle txtstyle = TextStyle(fontSize: 17, color: kPurpleColor, fontWeight: FontWeight.w600);
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

//    for(var i=0;i < 3;i++){
//      this.icons += Image.asset()
//    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kDarkPurpleColor,
        body : CustomScrollView(
          slivers: <Widget>[
            SliverPersistentHeader(
              pinned : false,
              floating: true,
              delegate: InitPageHeader(
                minExtent : 200.0,
                maxExtent : 300.0,
              ),
            ),
            SliverGroupBuilder(
              margin: EdgeInsets.zero,
              decoration: BoxDecoration(
                color: kIvoryColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
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
                        Container(
//                      padding: EdgeInsets.fromLTRB(10, 10, , bottom),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: kWhiteIvoryColor
                          ),
                          height: 160,
                          width: 160,
//                      margin: EdgeInsets.fromLTRB(15,10,15,10),
                          alignment: Alignment.center,

                          child: Center(child: icons[index]),
                        ),
                        icons_name[index],
                      ],
                    );
                  },
                  childCount: icons_name.length,
                ),
              ),
            )
          ],
        )
    );
  }
}

class InitPageHeader implements SliverPersistentHeaderDelegate{

  final double minExtent;
  final double maxExtent;

  InitPageHeader({
    this.minExtent,
    @required this.maxExtent
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {

    return Container(
        padding: EdgeInsets.only(left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 50),
            GestureDetector(child:Icon(Icons.arrow_back_ios, color: kIvoryColor,size: 20), onTap: (){}),
            SizedBox(height: 20,),
            Text("습관 입력하기",style: TextStyle(fontSize: 25, color: kIvoryColor)),
            SizedBox(height: 11,),
            Image.asset("images/icon/beer.svg"),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(1)),
                color: kIvoryColor
              ),
              height: 3,
              width: 33,
            ),
            SizedBox(height: 11),
            Container(
              width: 280,
              child: Text("평소에 습관적으로 지출 하던 항목들을 전부 체크해주세요.",style: TextStyle(fontSize: 17,color: kIvoryColor,fontWeight: FontWeight.w300))
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




//onTap: () {
//Navigator.push(
//context,
//MaterialPageRoute(builder: (context) => InitNext()),
//);
//},