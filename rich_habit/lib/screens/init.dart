import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/rendering/sliver_persistent_header.dart';
import 'package:flutter_group_sliver/flutter_group_sliver.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:richhabit/habit.dart';
import 'package:richhabit/habit_provider.dart';
import 'package:provider/provider.dart';
import 'package:richhabit/main_page.dart';
import 'package:richhabit/screens/Init_next.dart';
import 'package:richhabit/widget/bottom_positioned_box.dart';
import 'dart:math';
import '../constants.dart';

class Init extends StatefulWidget {
  final bool isFirst;

  Init({this.isFirst});

  @override
  State createState() => InitState();
}

class InitState extends State<Init> with SingleTickerProviderStateMixin {

  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<List<dynamic>> habitsRough =
      new List<List<dynamic>>(); //[name,icon,isSelceted]

  final textFieldController = TextEditingController();
  AnimationController controller;
  Animation<double> offsetAnimation;
  TextStyle txtstyle;
  List<bool> _isSnackbarActive = new List<bool>.generate(2, (index) => false); // 0: 하나이상! 1: 이미추가!
  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        duration: const Duration(milliseconds: 500),
        vsync: this); //SingleTickerProviderSteteMixin과 연관이있는데 잘모르겠다
    txtstyle = TextStyle(color: kPurpleColor, fontWeight: FontWeight.w600);
    for (var i = 0; i < defualtHabitList.length; i++) {
      if (!_isExisting(habitName: defualtHabitList[i][0])) {
        habitsRough
            .add([defualtHabitList[i][0], defualtHabitList[i][1], false]);
      } else {
        habitsRough.add([defualtHabitList[i][0], defualtHabitList[i][1], true]);
      }
    }
//    for(var i = 0; i<habitsRough.length;i++){
    //    habitsRough[i].add(false);
    //}
  }


  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<double> whenNotZero(Stream<double> source) async {
    await for (double value in source) {
      if (value > 0) return value;
    }
  }

  List<List<dynamic>> _selectedListGenerator(List<List<dynamic>> habitsRough) {
    List<List<dynamic>> list = List<List<dynamic>>();
    for (var i = 0; i < habitsRough.length; i++) {
      if (habitsRough[i][2] == true &&
          !_isExisting(habitName: habitsRough[i][0])) {
        list.add(habitsRough[i].sublist(0, 2));
      }
    }
    return list;
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
            size = MediaQuery.of(context)
                .size; //새로운 핸드폰이지만 init을 거치지 않는다면? ex)login기능 구현시.. 오류가능성있음.

            return Scaffold(
              backgroundColor: kPurpleColor,
              resizeToAvoidBottomPadding: true,
              key: scaffoldKey,
              body: WillPopScope(
                onWillPop: () async {
                  widget.isFirst
                      ? Navigator.of(context).pop()
                      : Navigator.of(context, rootNavigator: true)
                          .pushReplacement(MaterialPageRoute(
                              builder: (context) => MainPage()));
                  return false;
                },
                child: Stack(
                  children: [
                    CustomScrollView(
                      shrinkWrap: false,
                      slivers: <Widget>[
                        SliverPersistentHeader(
                          pinned: true,
                          floating: false,
                          delegate: InitPageHeader(
                              minExtent: 260.0,
                              maxExtent: 300.0,
                              isFirst: widget.isFirst),
                        ),
                        SliverGroupBuilder(
                          decoration: BoxDecoration(
                            color: kIvoryColor,
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          child: SliverGrid(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 10.0,
                                  crossAxisSpacing: 10.0,
                                  childAspectRatio: ((size.width-10)/2)/208, // 가로/세로
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                return Container(
                                  padding: EdgeInsets.only(top: 20),
                                  child: Column(
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () {
                                          if (index == habitsRough.length - 1) {
                                            _showAddDialog(context);
                                          } else {
                                            if (_isExisting(
                                                habitName: habitsRough[index]
                                                    [0])) {
                                              if(_isSnackbarActive[1] == false) {
                                                scaffoldKey.currentState.removeCurrentSnackBar();
                                                _isSnackbarActive[1] = true;
                                                scaffoldKey.currentState.showSnackBar(
                                                    SnackBar(
                                                      content: Text("이미 추가한 습관이에요!"),
                                                      duration: Duration(milliseconds: 1300),
                                                    )
                                                ).closed
                                                    .then((SnackBarClosedReason reason) {
                                                  _isSnackbarActive[1] = false;
                                                });
                                              }
                                            } else {
                                              setState(() {
                                                habitsRough[index][2] =
                                                    !habitsRough[index][2];
                                              });
                                            }
                                          }
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: kWhiteIvoryColor,
                                          ),
                                          height: 160,
                                          width: 160,
                                          alignment: Alignment.center,
                                          child: Stack(
                                            children: habitsRough[index][2]
                                                ? [
                                                    Center(
                                                        child: SvgPicture.asset(
                                                            habitsRough[index]
                                                                [1])),
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
                                                          color: kWhiteIvoryColor),
                                                      height: 160,
                                                      width: 160,
                                                      alignment:
                                                          Alignment.center,
                                                    )
                                                  ]
                                                : [
                                                    Center(
                                                        child: SvgPicture.asset(
                                                            habitsRough[index]
                                                                [1]))
                                                  ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        height:18,
                                        child: FittedBox(
                                            fit: BoxFit.fitHeight,
                                            child: Text(
                                              habitsRough[index][0],
                                              style: txtstyle,
                                            )),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              childCount: habitsRough.length,
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
                    BottomPositionedBox("다 체크 했어요!  →", () {
                      bool isAnythingSelected = false;
                      for (var i = 0; i < habitsRough.length; i++) {
                        if (habitsRough[i][2] == true &&
                            !_isExisting(habitName: habitsRough[i][0])) {
                          isAnythingSelected = true;
                          break;
                        }
                      }
                      if (isAnythingSelected == false) {
                        if(_isSnackbarActive[0] == false) {
                          scaffoldKey.currentState.removeCurrentSnackBar();
                          _isSnackbarActive[0] = true;
                          scaffoldKey.currentState.showSnackBar(
                              SnackBar(
                                content: Text("새로운 습관을 한개 이상 선택해주세요!"),
                                duration: Duration(milliseconds: 1300),
                              )
                          ).closed
                              .then((SnackBarClosedReason reason) {
                            _isSnackbarActive[0] = false;
                          });
                        }
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => InitNext(
                                    selectedItem:
                                        _selectedListGenerator(habitsRough),
                                    isFirst: widget.isFirst)));
                      }
                    }),
                  ],
                ),
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  bool _isExisting({String habitName}) {
    DateTime current = DateTime.now();
    DateTime _today = DateTime(current.year, current.month, current.day);
    int _thisWeek = context.read<HabitProvider>().isoWeekNumber(current);
    List<Habit> _existingHabitList = new List<Habit>();
    if (context.read<HabitProvider>().weeklyHabit[_thisWeek] != null)
      _existingHabitList
          .addAll(context.read<HabitProvider>().weeklyHabit[_thisWeek]);
    if (context.read<HabitProvider>().dailyHabit[_today] != null)
      _existingHabitList
          .addAll(context.read<HabitProvider>().dailyHabit[_today]);
    for (var i = 0; i < _existingHabitList.length; i++) {
      if (_existingHabitList[i].name == habitName) {
        return true;
      }
    }
    return false;
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
                height: 226,
                width: 320,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: 176,
                      padding: EdgeInsets.fromLTRB(26, 15, 26, 13),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 80,
                            width: 80,
                            padding: EdgeInsets.all(0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: kWhiteIvoryColor,
                            ),
                            child: Center(
                                child: SvgPicture.asset(
                                    'assets/images/icon/custom_coin.svg',
                                    width: 44)),
                          ),
                          SizedBox(
                            height: 10.5,
                          ),
                          Container(
                            width: 204,
//                          padding: EdgeInsets.symmetric(horizontal: 15),
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: RichText(
                                text: TextSpan(
                                    text: '새로운 습관의 ',
                                    style: TextStyle(
                                      color: kPurpleColor,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: '이름',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      TextSpan(text: '을 입력해 주세요!')
                                    ]),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 8.5,
                          ),
                          Container(
                            height: 25,
                            width: 264,
                            child: AnimatedBuilder(
                                animation: offsetAnimation,
                                builder: (buildContext, child) {
                                  return Container(
                                    padding: EdgeInsets.only(
                                        left: offsetAnimation.value + 15.0,
                                        right: 15.0 - offsetAnimation.value),
                                    child: CupertinoTextField(
                                      maxLength: 9,
                                      decoration: new BoxDecoration(
                                        color: Colors.white,
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 5),
                                      style: TextStyle(
                                          color: kPurpleColor,
                                          textBaseline: null),
                                      controller: textFieldController,
//                                    decoration: new InputDecoration(
//                                      fillColor: Colors.white,
//                                      filled: true,
//                                      focusedBorder: OutlineInputBorder(
//                                        borderSide: BorderSide(color: kPurpleColor, width: 1.0),
//                                      ),
//                                      enabledBorder: OutlineInputBorder(
//                                        borderSide: BorderSide(color: kPurpleColor.withOpacity(0.5), width: 1.0),
//                                      ),
//                                    ),
                                    ),
                                  );
                                }),
                          )
                        ],
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
                              textFieldController.clear();
                              Navigator.pop(context);
                            },
                            child: Container(
                              child: Center(
                                  child: Text(
                                "취소",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFDE711E)),
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
                                    if (textFieldController.text
                                        .trim()
                                        .isNotEmpty) {
                                      Navigator.pop(context);
                                      setState(() {
                                        habitsRough.insert(
                                            habitsRough.length - 1, [
                                          textFieldController.text,
                                          ('assets/images/icon/custom_coin.svg'),
                                          true
                                        ]);
                                      });
                                      textFieldController.clear();
                                    } else if (textFieldController.text
                                        .trim()
                                        .isEmpty) {
                                      controller.forward(from: 0.0);
                                    }
                                  },
                                  child: Center(
                                    child: Text(
                                      "저장",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: kIvoryColor,
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

class InitPageHeader implements SliverPersistentHeaderDelegate {
  final double minExtent;
  final double maxExtent;
  final bool isFirst;
  InitPageHeader(
      {this.minExtent, @required this.maxExtent, @required this.isFirst});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    Color txtColor = kWhiteIvoryColor.withOpacity(headerOpacity(shrinkOffset));
    return Container(
      padding: EdgeInsets.only(left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
//              SizedBox(height: 50),
          Padding(
            padding: EdgeInsets.only(top: 60, bottom: 10),
            child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                child:
                    Icon(Icons.arrow_back_ios, color: txtColor, size: 25),
                onTap: () {
                  isFirst
                      ?Navigator.of(context).pop()
                      :Navigator.of(context, rootNavigator: true)
                      .pushReplacement(MaterialPageRoute(
                          builder: (context) => MainPage()));
                }),
          ),
          SizedBox(
            height: 20,
          ),
          Text("습관 입력하기",
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
              Text("평소에 습관적으로 지출 하던 항목들 중",
                  style: TextStyle(
                      fontSize: 17,
                      color: txtColor,
                      fontWeight: FontWeight.w300)),
              Text("앞으로 절약해 갈 습관들을",
                  style: TextStyle(
                      fontSize: 17,
                      color: txtColor,
                      fontWeight: FontWeight.w300)),
              Text("전부 체크해주세요.",
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

//이모티콘 아래 글자크기 키웠을때 BottomOverflow 고쳐야함
//옆에 Stack헀더니 TopRight BerderRadius 어디감?
