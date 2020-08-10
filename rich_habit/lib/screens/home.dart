import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:richhabit/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:table_calendar/table_calendar.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  DateTime current;
  DateTime _selDay;
  Map<DateTime, List<Habit>> habits = new Map<DateTime, List<Habit>>();
  Map<DateTime, List> _events;
  AnimationController _animationController;
  CalendarController _calendarController;

  @override
  void initState() {
    super.initState();
    current = DateTime.now();
    _selDay = DateTime(current.year, current.month, current.day);
    habits[_selDay] = [
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
    habits[_selDay.subtract(Duration(days: 1))] = [
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
    _events = {
      _selDay.subtract(Duration(days: 10)): [1],
      _selDay.subtract(Duration(days: 9)): [1],
      _selDay.subtract(Duration(days: 8)): [1],
      _selDay.subtract(Duration(days: 7)): [1],
      _selDay.subtract(Duration(days: 6)): [1],
      _selDay.subtract(Duration(days: 5)): [1],
      _selDay.subtract(Duration(days: 4)): [2],
      _selDay.subtract(Duration(days: 3)): [1],
      _selDay.subtract(Duration(days: 2)): [2],
      _selDay.subtract(Duration(days: 1)): [1],
      _selDay: [0],
    };

    _calendarController = CalendarController();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(BuildContext buildContext, DateTime day, List events) {
    print('CALLBACK: _onDaySelected');
    setState(() {
      if (isNow(day)) {
        print("같");
        _selDay = DateTime(day.year, day.month, day.day);
        Navigator.pop(buildContext);
      } else if (day.isAfter(DateTime.now())) {
        print("후");
      } else {
        print("전");
        _selDay = DateTime(day.year, day.month, day.day);
        Navigator.pop(buildContext);
      }
    });
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  void _onCalendarCreated(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onCalendarCreated');
  }

  List<Widget> _getTodayHabit() {
    try {
      return List.generate(habits[_selDay].length, (i) {
        Habit habit = habits[_selDay][i];
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
                          if (habits[_selDay][i].nowAmount > 0) {
                            habits[_selDay][i].nowAmount--;
                          }
                        });
                      },
                      iconSize: 30.0,
                      icon: SvgPicture.asset(
                        "assets/images/icon/remove_circle.svg",
                        height: 30.0,
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
                          habits[_selDay][i].nowAmount++;
                          if (habits[_selDay][i].nowAmount >
                              habits[_selDay][i].goalAmount) {
                            //habit 일 경우에만 하기
                            showDialog(
                                context: context,
                                builder: (BuildContext buildContext) {
                                  return _buildWarning(
                                      buildContext, habits[_selDay][i]);
                                });
                          }
                        });
                      },
                      iconSize: 30.0,
                      icon: SvgPicture.asset(
                        "assets/images/icon/plus_circle.svg",
                        height: 30.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      });
    } catch (e) {
      return [
        Container(
          child: Text(
            "입력된 값이 없습니다.",
            style:
                TextStyle(color: kWhiteIvoryColor, fontSize: kNormalFontSize),
          ),
        )
      ];
    }
  }

  Widget _buildWarning(BuildContext buildContext, Habit habit) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 540,
        decoration: BoxDecoration(
            color: kIvoryColor, borderRadius: BorderRadius.circular(20.0)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: kPadding,
            ),
            Container(
              height: 150,
              width: 150,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: kWhiteIvoryColor,
                borderRadius: BorderRadius.circular(150.0),
              ),
              child: SvgPicture.asset(
                habit.iconURL,
                height: 50.0,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              "${habit.name}",
              style: TextStyle(
                fontSize: 25,
                color: kPurpleColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              width: 30.0,
              child: Divider(
                color: kPurpleColor,
                thickness: 3,
              ),
            ),
            SizedBox(height: 30.0),
            Text(
              "내가 잃어버린 복리의 힘",
              style: TextStyle(fontSize: 16.0, color: kPurpleColor),
            ),
            Text(
              "2,268,200원",
              style: TextStyle(
                  fontSize: kTitleFontSize,
                  color: kPurpleColor,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40.0),
            Text("\"담배는 돈 뿐만 아니라 건강에도 최악!\n다음에는 꼭 목표를 지켜봐요\"",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16.0, color: kPurpleColor)),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 60.0,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: kPurpleColor,
                        borderRadius: BorderRadius.circular(20.0)),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(buildContext);
                      },
                      child: Text(
                        "다짐 후 창 닫기",
                        style: TextStyle(
                            fontSize: 16.0,
                            color: kIvoryColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableCalendarWithBuilders(BuildContext buildContext) {
    return Dialog(
      child: Container(
        color: kPurpleColor,
        width: MediaQuery.of(context).size.width,
        child: TableCalendar(
          initialSelectedDay: _selDay,
          rowHeight: 70.0,
          locale: 'ko_KR',
          calendarController: _calendarController,
          events: _events,
          initialCalendarFormat: CalendarFormat.month,
          formatAnimation: FormatAnimation.scale,
          startingDayOfWeek: StartingDayOfWeek.monday,
          availableGestures: AvailableGestures.horizontalSwipe,
          availableCalendarFormats: const {
            CalendarFormat.month: '',
            CalendarFormat.week: '',
          },
          calendarStyle: CalendarStyle(
            markersAlignment: Alignment.center,
            outsideDaysVisible: true,
          ),
          headerStyle: HeaderStyle(
            titleTextStyle: TextStyle(fontSize: 20.0, color: Colors.white),
            leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white),
            rightChevronIcon: Icon(Icons.chevron_right, color: Colors.white),
            centerHeaderTitle: true,
            formatButtonVisible: false,
          ),
          builders: CalendarBuilders(
            dayBuilder: (context, date, list) {
              return _buildCalText(date, Colors.white);
            },
            outsideDayBuilder: (context, date, list) {
              return _buildCalText(date, Colors.grey.withOpacity(0.5));
            },
            outsideWeekendDayBuilder: (context, date, list) {
              return _buildCalText(date, Colors.grey.withOpacity(0.5));
            },
            outsideHolidayDayBuilder: (context, date, list) {
              return _buildCalText(date, Colors.grey.withOpacity(0.5));
            },
            holidayDayBuilder: (context, date, list) {
              return _buildCalText(date, Colors.red);
            },
            todayDayBuilder: (context, date, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Divider(
                    color: Colors.white.withOpacity(0.5),
                    height: 0.5,
                    thickness: 0.5,
                  ),
                  SizedBox(
                    height: 2.0,
                  ),
                  Container(
                    height: 20.0,
                    width: 20.0,
                    decoration: BoxDecoration(
                        color: Color(0xffF58129),
                        borderRadius: BorderRadius.all(Radius.circular(30.0))),
                    child: Center(
                      child: Text(
                        '${date.day}',
                        style: TextStyle(fontSize: 12.0, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              );
            },
            selectedDayBuilder: (context, date, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Divider(
                    color: Colors.white.withOpacity(0.5),
                    thickness: 0.5,
                    height: 0.5,
                  ),
                  (isNow(date))
                      ? Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.5)),
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 2.0,
                                ),
                                Container(
                                  height: 20.0,
                                  width: 20.0,
                                  decoration: BoxDecoration(
                                      color: Color(0xffF58129),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30.0))),
                                  child: Center(
                                    child: Text(
                                      '${date.day}',
                                      style: TextStyle(
                                          fontSize: 12.0, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3)),
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 5.0,
                                ),
                                Text(
                                  "${date.day}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 12.0, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                ],
              );
            },
            markersBuilder: (context, date, events, holidays) {
              final children = <Widget>[];
              if (events.isNotEmpty) {
                print("${_calendarController.focusedDay.month.toString()}");
                if (date.month == _calendarController.focusedDay.month) {
                  children.add(
                    Positioned(
                      child: _buildEventsMarker(date, events),
                    ),
                  );
                }
              }
              return children;
            },
            dowWeekdayBuilder: (context, string) {
              return Text(
                string,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 12.0),
              );
            },
            dowWeekendBuilder: (context, string) {
              return Text(
                string,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red, fontSize: 12.0),
              );
            },
          ),
          onDaySelected: (date, events) {
            _onDaySelected(buildContext, date, events);
          },
          onVisibleDaysChanged: _onVisibleDaysChanged,
          onCalendarCreated: _onCalendarCreated,
        ),
      ),
    );
  }

  Widget _buildCalText(DateTime date, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Divider(
          color: Colors.white.withOpacity(0.5),
          thickness: 0.5,
          height: 0.5,
        ),
        SizedBox(
          height: 5.0,
        ),
        Text(
          "${date.day}",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12.0, color: color),
        ),
      ],
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    var image;
    switch (events[0]) {
      case 1: //완료
        image = Image.asset('assets/images/coin_1.png');
        break;
      case 2: //오버
        image = Image.asset('assets/images/coin_2.png');
        break;
      case 0: //안함
        image = Image.asset('assets/images/question_mark.png');
        break;
      default: //이상함
        image = Image.asset('assets/images/question_mark.png');
        break;
    }
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
        width: 30.0,
        height: 30.0,
        child: image,
      ),
    );
  }

  String getWeek(int weekNum) {
    String weekStr = "";
    switch (weekNum) {
      case 1:
        weekStr = "월요일";
        break;
      case 2:
        weekStr = "화요일";
        break;
      case 3:
        weekStr = "수요일";
        break;
      case 4:
        weekStr = "목요일";
        break;
      case 5:
        weekStr = "금요일";
        break;
      case 6:
        weekStr = "토요일";
        break;
      case 7:
        weekStr = "일요일";
        break;
      default:
        weekStr = "뭐징";
        break;
    }
    return weekStr;
  }

  bool isNow(DateTime dateTime) {
    DateTime now = DateTime.now();
    if (now.day == dateTime.day &&
        now.month == dateTime.month &&
        now.year == dateTime.year) {
      return true;
    } else {
      return false;
    }
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
                "${_selDay.month}월 ${_selDay.day}일 ${getWeek(_selDay.weekday)}",
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
                    setState(() {
                      _selDay = _selDay =
                          DateTime(current.year, current.month, current.day);
                    });
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
                  showDialog(
                      context: context,
                      builder: _buildTableCalendarWithBuilders);
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
