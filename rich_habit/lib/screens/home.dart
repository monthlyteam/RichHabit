import 'package:flutter/material.dart';
import 'package:richhabit/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DateTime _selTime = DateTime(2020, 7, 30);
  Map<DateTime, List<Habit>> habits = new Map<DateTime, List<Habit>>();
  @override
  void initState() {
    habits[DateTime(2020, 7, 30)] = [
      new Habit(
          name: "양치질",
          iconURL: "assets/images/icon/smoking.svg",
          price: 0,
          usualIsWeek: false,
          usualAmount: 1,
          goalIsWeek: false,
          goalAmount: 1),
      new Habit(
          name: "흡연",
          iconURL: "assets/images/icon/smoking.svg",
          price: 4500,
          usualIsWeek: false,
          usualAmount: 3,
          goalIsWeek: false,
          goalAmount: 2)
    ];
    super.initState();
  }

  List<Widget> _getTodayHabit() {
    return List.generate(habits[_selTime].length, (i) {
      Habit habit = habits[_selTime][i];
      TextStyle textStyle = new TextStyle(color: kPurpleColor, fontSize: 15);
      TextStyle countStyle = new TextStyle(
          color: kPurpleColor, fontSize: 25.0, fontWeight: FontWeight.bold);
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: GestureDetector(
          onTap: () {
            print("눌림");
          },
          child: Container(
            height: 70.0,
            decoration: BoxDecoration(
                color: kIvoryColor,
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      setState(() {
                        habits[_selTime][i].nowAmount--;
                      });
                    },
                    iconSize: 30.0,
                    icon: Icon(
                      Icons.remove_circle,
                      color: Color(0xffFEC447),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SvgPicture.asset(
                              habit.iconURL,
                              height: 25.0,
                            ),
                            Text(
                              habit.name,
                              style: TextStyle(
                                  fontSize: 15.0, color: kPurpleColor),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                "현재 ",
                                style: textStyle,
                              ),
                              Text(
                                "${habit.nowAmount}",
                                style: countStyle,
                              ),
                              Text(
                                "번  /  ",
                                style: textStyle,
                              ),
                              Text(
                                "목표 ",
                                style: textStyle,
                              ),
                              Text(
                                "${habit.goalAmount}",
                                style: countStyle,
                              ),
                              Text(
                                "번",
                                style: textStyle,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        habits[_selTime][i].nowAmount++;
                      });
                    },
                    iconSize: 30.0,
                    icon: Icon(
                      Icons.add_circle,
                      color: Color(0xffFEC447),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            floating: true,
            backgroundColor: kPurpleColor,
            titleSpacing: 0.0,
            centerTitle: false,
            elevation: 0.0,
            title: Padding(
              padding: const EdgeInsets.only(left: kPadding),
              child: Text(
                "7월 20일 월요일",
                style: TextStyle(
                    fontSize: kTitleFontSize,
                    color: kWhiteIvoryColor,
                    fontWeight: FontWeight.bold),
              ),
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: GestureDetector(
                  onTap: () {
                    print("오늘");
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: kDarkPurpleColor,
                        borderRadius: BorderRadius.all(Radius.circular(40.0))),
                    child: Text(
                      "오늘",
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  print("plus");
                },
                iconSize: 25.0,
                icon: Icon(
                  Icons.add_circle,
                  color: kWhiteIvoryColor,
                ),
              ),
              IconButton(
                onPressed: () {
                  print("cal");
                },
                iconSize: 25.0,
                icon: Icon(
                  Icons.calendar_today,
                  color: kWhiteIvoryColor,
                ),
              )
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: EdgeInsets.all(kPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "오늘",
                      style: TextStyle(
                          fontSize: 20.0,
                          color: kWhiteIvoryColor,
                          fontWeight: FontWeight.bold),
                    ),
                    Column(
                      children: _getTodayHabit(),
                    ),
                    SizedBox(
                      height: kPadding,
                    ),
                    Text(
                      "7월 4주차",
                      style: TextStyle(
                          fontSize: 20.0,
                          color: kWhiteIvoryColor,
                          fontWeight: FontWeight.bold),
                    ),
                    Column(
                      children: _getTodayHabit(),
                    ),
                    Column(
                      children: _getTodayHabit(),
                    ),
                    Column(
                      children: _getTodayHabit(),
                    ),
                    Column(
                      children: _getTodayHabit(),
                    ),
                    Column(
                      children: _getTodayHabit(),
                    ),
                    Column(
                      children: _getTodayHabit(),
                    )
                  ],
                ),
              )
            ]),
          )
        ],
      ),
    );
  }
}

class Habit {
  String name;
  String iconURL;
  double price; //습관 1회당 가격

  int warningCount = 0; //경고 누적 수

  bool usualIsWeek; // 평상시 횟수 단위 Daily = false, Weekly = true
  int usualAmount; //평상시 습관 양

  bool goalIsWeek; // 목표 횟수 단위
  int goalAmount; // 목표 습관 양

  int nowAmount = 0; // 현재 습관 양

  Habit({
    @required this.name,
    @required this.iconURL,
    @required this.price,
    @required this.usualIsWeek,
    @required this.usualAmount,
    @required this.goalIsWeek,
    @required this.goalAmount,
  });

  double get retention //목표 유지율
      => ((usualAmount - nowAmount) / (usualAmount - goalAmount)) * 100.0;

  double get saveMoney //절약 금액
      => (usualAmount - nowAmount) * price;
}
