import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/rendering/sliver_persistent_header.dart';
import 'package:flutter_group_sliver/flutter_group_sliver.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:richhabit/main_page.dart';
import 'package:richhabit/screens/trigger_next.dart';
import 'package:richhabit/widget/bottom_positioned_box.dart';
import 'dart:math';
import 'package:richhabit/habit_provider.dart';
import 'package:provider/provider.dart';
import '../constants.dart';

class Trigger extends StatefulWidget {
  final bool isFirst;
  Trigger({this.isFirst});

  @override
  State createState() => _TriggerState();
}

class _TriggerState extends State<Trigger> with SingleTickerProviderStateMixin {
  List<List<dynamic>> triggersRough =
      new List<List<dynamic>>(); //[name,icon,isSelceted]

  final textFieldController = TextEditingController();
  AnimationController controller;
  Animation<double> offsetAnimation;
  TextStyle txtstyle;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 500),
        vsync: this); //SingleTickerProviderSteteMixin과 연관이있는데 잘모르겠다

    txtstyle = TextStyle(color: kPurpleColor, fontWeight: FontWeight.w600);
    for (var i = 0; i < triggerList.length; i++) {
      if (!_isExisting(triggerList[i][0])) {
        triggersRough.add([triggerList[i][0], triggerList[i][1], false]);
      }
    }
  }

  List<List<dynamic>> _selectedListGenerator(
    List<List<dynamic>> triggersRough) {
      List<List<dynamic>> list = List<List<dynamic>>();
      for (var i = 0; i < triggersRough.length; i++) {
        if (triggersRough[i][2] == true) list.add(triggersRough[i].sublist(0, 2));
      }
    return list;
  }

  Future<double> whenNotZero(Stream<double> source) async {
    await for (double value in source) {
      if (value > 0) return value;
    }
  }
  @override
  Widget build(BuildContext context) {
    offsetAnimation = Tween(begin: 0.0, end: 10.0)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(controller)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              controller.reverse();
            }
          });
    return FutureBuilder<double>(
      future: whenNotZero(Stream<double>.periodic(Duration(microseconds: 100),
              (x) => MediaQuery.of(context).size.width)),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
        size = MediaQuery.of(context).size; //새로운 핸드폰이지만 init을 거치지 않는다면? ex)login기능 구현시.. 오류가능성있음.

        return Scaffold(
          backgroundColor: kPurpleColor,
          body: WillPopScope(
            onWillPop: () async {
              if(widget.isFirst) {
                Navigator.of(context, rootNavigator: true)
                    .pushReplacement(MaterialPageRoute(
                    builder: (context) => MainPage()));
              }else{
                context.read<HabitProvider>().resetData();
                Navigator.of(context).pop();
              }
              return true;
            },
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  top: 290,
                  height: 290,
                  width: size.width,
                  child: Container(
                    color: kPurpleColor,
                  ),
                ),
                CustomScrollView(
                  shrinkWrap: false,
                  slivers: <Widget>[
                    SliverPersistentHeader(
                      pinned: true,
                      floating: false,
                      delegate: TriggerPageHeader(
                        minExtent: 260.0,
                        maxExtent: 300.0,
                      ),
                    ),
                    SliverGroupBuilder(
                      decoration: BoxDecoration(
                        color: kIvoryColor,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      child: SliverGrid(
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: size.width / 2,
                          mainAxisSpacing: 10.0,
                          crossAxisSpacing: 10.0,
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
                                    behavior: HitTestBehavior.translucent,
                                    onTap: () {
                                      //                                if(index == triggersRough.length-1){
                                      //                                  _showAddDialog(context);
                                      //                                }else{
                                      setState(() {
                                        for (var i = 0;
                                            i < triggersRough.length;
                                            i++) {
                                          triggersRough[i][2] = false;
                                        }

                                        triggersRough[index][2] =
                                            !triggersRough[index][2];
                                      });
                                    },
                                    //                              },
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
                                        children: triggersRough[index][2]
                                            ? [
                                                Center(
                                                    child: SvgPicture.asset(
                                                        triggersRough[index][1])),
                                                Container(
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.black
                                                          .withOpacity(0.5),
                                                    ),
                                                    child: SvgPicture.asset(
                                                        "assets/images/check.svg",
                                                        height: 80,
                                                        width: 80,
                                                        color: kPurpleColor),
                                                    height: 160,
                                                    width: 160,
                                                    alignment: Alignment.center)
                                              ]
                                            : [
                                                Center(
                                                    child: SvgPicture.asset(
                                                        triggersRough[index][1]))
                                              ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  FittedBox(
                                      fit: BoxFit.fitHeight,
                                      child: Text(
                                        triggersRough[index][0],
                                        style: txtstyle,
                                      )),
                                ],
                              ),
                            );
                          },
                          childCount: triggersRough.length,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        color: kIvoryColor,
                        height: 80,
                        width: size.width,
                      ),
                    ),
                  ],
                ),
                BottomPositionedBox("다음", () {
                  bool isAnythingSelected = false;
                  for (var i = 0; i < triggersRough.length; i++) {
                    if (triggersRough[i][2] == true) {
                      isAnythingSelected = true;
                      break;
                    }
                  }
                  if (isAnythingSelected == false) {
                    Fluttertoast.showToast(
                        msg: "최소 한개를 선택해주세요!",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.grey,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TriggerNext(
                                selectedItem:
                                    _selectedListGenerator(triggersRough))));
                  }
                })
              ],
            ),
          ));
        }else {
          return CircularProgressIndicator();
        }
      }
    );
  }

  bool _isExisting(String name) {
    List<String> habitNameList = new List<String>();
    context
        .read<HabitProvider>()
        .weeklyHabit
        .forEach((k, v) => habitNameList.add(v[0].name));
    context
        .read<HabitProvider>()
        .dailyHabit
        .forEach((k, v) => habitNameList.add(v[0].name));
    for (var i = 0; i < habitNameList.length; i++) {
      if (habitNameList[i] == name) {
        return true;
      }
    }
    return false;
  }
}

class TriggerPageHeader implements SliverPersistentHeaderDelegate {
  final double minExtent;
  final double maxExtent;
  TriggerPageHeader({
    this.minExtent,
    @required this.maxExtent,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    Color txtColor = kWhiteIvoryColor.withOpacity(headerOpacity(shrinkOffset));
    return Container(
      padding: EdgeInsets.only(left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 60, bottom: 10),
            child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: Icon(Icons.arrow_back_ios, color: txtColor, size: 25),
                onTap: () {
                  context.read<HabitProvider>().resetData();
                  Navigator.of(context).pop();
                }),
          ),
          SizedBox(
            height: 20,
          ),
          Text("습관 동반자 입력하기",
              style: TextStyle(
                  fontSize: kTitleFontSize,
                  color: txtColor,
                  fontWeight: FontWeight.bold)),
          SizedBox(
            height: 11,
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(1)),
                color: txtColor),
            height: 3,
            width: 33,
          ),
          SizedBox(height: 11),
          Container(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("이미 평소에 매일 하던 습관과 함께 기록해 가면",
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                      fontSize: 17,
                      color: txtColor,
                      fontWeight: FontWeight.w300)),
              Text("소비 습관 기록을 더 잘 할 수 있어요.",
                  style: TextStyle(
                      fontSize: 17,
                      color: txtColor,
                      fontWeight: FontWeight.w300)),
              Text("입력 알림도 같이 온답니다!",
                  style: TextStyle(
                      fontSize: 17,
                      color: txtColor,
                      fontWeight: FontWeight.w300)),
            ],
          )),
        ],
      ),
    );
  }

  double headerOpacity(double shrinkOffset) {
    return max(0, 1 - shrinkOffset / (maxExtent - minExtent + 50));
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
