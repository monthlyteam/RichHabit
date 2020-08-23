import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:richhabit/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:richhabit/habit_provider.dart';
import 'package:richhabit/screens/home_detail.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import '../habit.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  DateTime current;
  DateTime _selDay;
  var selWeekOfYear;
  AnimationController _animationController;
  CalendarController _calendarController;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();

    print("Weekly Habits = ${context.read<HabitProvider>().weeklyHabit}");
    print("Daily Habits = ${context.read<HabitProvider>().dailyHabit}");
    print("Trigger Habits = ${context.read<HabitProvider>().triggerHabit}");
    current = DateTime.now();
    _selDay = DateTime(current.year, current.month, current.day);
    selWeekOfYear = context.read<HabitProvider>().isoWeekNumber(_selDay);
    print(selWeekOfYear);

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
      if (_isNow(day)) {
        print("같");
        _selDay = DateTime(day.year, day.month, day.day);
        selWeekOfYear = context.read<HabitProvider>().isoWeekNumber(_selDay);
        Navigator.pop(buildContext);
      } else if (day.isAfter(DateTime.now())) {
        print("후");
      } else {
        print("전");
        _selDay = DateTime(day.year, day.month, day.day);
        selWeekOfYear = context.read<HabitProvider>().isoWeekNumber(_selDay);
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

  List<Widget> _getHabitContainer(bool isWeek, bool isTrigger) {
    List<Habit> habits;
    if (isTrigger) {
      Map<DateTime, List<Habit>> triggerHabit =
          context.watch<HabitProvider>().triggerHabit;
      habits = triggerHabit[_selDay];
    } else if (isWeek) {
      Map<int, List<Habit>> weeklyHabit =
          context.watch<HabitProvider>().weeklyHabit;
      habits = weeklyHabit[selWeekOfYear];
    } else {
      Map<DateTime, List<Habit>> dailyHabit =
          context.watch<HabitProvider>().dailyHabit;
      habits = dailyHabit[_selDay];
    }
    //매일, 매주 인자로 받기
    try {
      return List.generate(habits.length, (i) {
        Habit habit = habits[i];
        TextStyle textStyle = new TextStyle(color: kPurpleColor, fontSize: 15);
        TextStyle countStyle = new TextStyle(
            color: kPurpleColor, fontSize: 25.0, fontWeight: FontWeight.bold);
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HomeDetail(
                          habit: habit,
                        )),
              );
            },
            child: Container(
              height: 85.0,
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
                          if (habit.nowAmount > 0) {
                            context.read<HabitProvider>().minusNowAmount(
                                _selDay, habit.addedTimeID, isWeek, isTrigger);
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
                          context.read<HabitProvider>().plusNowAmount(
                              _selDay, habit.addedTimeID, isWeek, isTrigger);
                          if (habit.nowAmount > habit.goalAmount &&
                              !isTrigger) {
                            //habit 일 경우에만 하기
                            showDialog(
                                context: context,
                                builder: (BuildContext buildContext) {
                                  return _buildWarning(buildContext, habit);
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
      if (isTrigger) {
        return [
          Container(
            child: Text(
              "입력된 값이 없습니다.",
              style:
                  TextStyle(color: kWhiteIvoryColor, fontSize: kNormalFontSize),
            ),
          )
        ];
      } else {
        return [Container()];
      }
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
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(buildContext);
                    },
                    child: Container(
                      height: 60.0,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: kPurpleColor,
                          borderRadius: BorderRadius.circular(20.0)),
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
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: kPurpleColor, borderRadius: BorderRadius.circular(20.0)),
        child: TableCalendar(
          initialSelectedDay: _selDay,
          rowHeight: 70.0,
          locale: 'ko_KR',
          calendarController: _calendarController,
          events: context.read<HabitProvider>().calendarIcon,
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
                  (_isNow(date))
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
                style: TextStyle(color: Color(0xffF58129), fontSize: 12.0),
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
        width: 25.0,
        height: 25.0,
        child: image,
      ),
    );
  }

  String _getWeek(int weekNum) {
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

  bool _isNow(DateTime dateTime) {
    DateTime now = DateTime.now();
    if (now.day == dateTime.day &&
        now.month == dateTime.month &&
        now.year == dateTime.year) {
      return true;
    } else {
      return false;
    }
  }

  String _getWeekStartDay() {
    var day = "";
    DateTime startOfWeek =
        _selDay.subtract(Duration(days: _selDay.weekday - 1));
    return "(${startOfWeek.month}월 ${startOfWeek.day}일~)";
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
                "${_selDay.month}월 ${_selDay.day}일 ${_getWeek(_selDay.weekday)}",
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
                      selWeekOfYear =
                          context.read<HabitProvider>().isoWeekNumber(_selDay);
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
                      children: _getHabitContainer(false, true),
                    ),
                    Column(
                      children: _getHabitContainer(false, false),
                    ),
                    SizedBox(
                      height: kPadding,
                    ),
                    context.watch<HabitProvider>().weeklyHabit[selWeekOfYear] ==
                                null ||
                            context
                                    .watch<HabitProvider>()
                                    .weeklyHabit[selWeekOfYear]
                                    .length ==
                                0
                        ? Container()
                        : Text(
                            "${selWeekOfYear - (_selDay.year * 100)} 주차 ${_getWeekStartDay()}",
                            style: TextStyle(
                                fontSize: 20.0,
                                color: kWhiteIvoryColor,
                                fontWeight: FontWeight.bold),
                          ),
                    Column(
                      children: _getHabitContainer(true, false),
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
