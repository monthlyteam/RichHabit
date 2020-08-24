import 'package:flutter/material.dart';
import 'package:richhabit/constants.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:richhabit/screens/compound_interest_detail.dart';

import '../habit.dart';
import '../habit_provider.dart';

class CompoundInterest extends StatefulWidget {
  @override
  _CompoundInterestState createState() => _CompoundInterestState();
}

class _CompoundInterestState extends State<CompoundInterest> {
  int selIndex = 0;
  bool goalIsWeek = false;
  DateTime addedTimeID;
  DateTime current;
  DateTime today;
  List<Habit> dailyHabit;
  List<Habit> weeklyHabit;
  List<Habit> total;

  List<FlSpot> spots = [
    FlSpot(0, 80),
    FlSpot(1, 90),
    FlSpot(2, 30),
    FlSpot(3, 50),
    FlSpot(4, 95),
    FlSpot(5, 100),
    FlSpot(6, 85),
    FlSpot(7, 70),
    FlSpot(8, 73),
  ];
  List<Color> gradientColors = [
    const Color(0xff585A79),
    const Color(0xff585A79),
  ];
  @override
  void initState() {
    super.initState();
    current = DateTime.now();
    today = DateTime(current.year, current.month, current.day);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            toolbarHeight: 95.0,
            floating: true,
            backgroundColor: kPurpleColor,
            titleSpacing: 0.0,
            centerTitle: false,
            elevation: 0.0,
            title: Padding(
              padding: const EdgeInsets.only(left: kPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "내 절약 현황",
                    style: TextStyle(
                        color: kWhiteIvoryColor,
                        fontSize: kTitleFontSize,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  _buildCategories(context),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: kPadding, vertical: 2.0),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 10.0),
                      height: 125,
                      decoration: BoxDecoration(
                        color: kIvoryColor,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 40.0,
                                  alignment: Alignment.center,
                                  child: Text(
                                    "${today.month}월 예상 절약 금액",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: kPurpleColor, fontSize: 14.0),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "${context.watch<HabitProvider>().thisMonthExpected(addedTimeID, goalIsWeek).toStringAsFixed(1).replaceAllMapped(new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}원",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: kDarkPurpleColor,
                                          fontSize: kSubTitleFontSize,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: kPurpleColor,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 40.0,
                                  alignment: Alignment.center,
                                  child: Text(
                                    "연 5% 월 복리로\n 20년후 가치",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: kPurpleColor, fontSize: 14.0),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "${context.watch<HabitProvider>().compoundInterest(context.watch<HabitProvider>().thisMonthExpected(addedTimeID, goalIsWeek), 20, 5).toStringAsFixed(1).replaceAllMapped(new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}원",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: kDarkPurpleColor,
                                          fontSize: kSubTitleFontSize,
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
                    SizedBox(height: kPadding),
                    Container(
                      padding: EdgeInsets.all(10.0),
                      height: 90,
                      decoration: BoxDecoration(
                        color: kIvoryColor,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "누적 절약 금액",
                                style: TextStyle(
                                    fontSize: 16.0, color: kPurpleColor),
                              ),
                              Text(
                                "${context.watch<HabitProvider>().cumSaving(addedTimeID).toStringAsFixed(1).replaceAllMapped(new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}원",
                                style: TextStyle(
                                    fontSize: 25.0,
                                    color: kDarkPurpleColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Image.asset(
                                  "assets/images/coin_1.png",
                                  height: 52.0,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CompoundInterestDetail(
                                                  addedTimeID: addedTimeID)),
                                    );
                                  },
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    color: kPurpleColor,
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: kPadding),
                    _buildChart(addedTimeID),
                    SizedBox(height: 800),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories(BuildContext context) {
    dailyHabit = context.watch<HabitProvider>().dailyHabit[today];
    weeklyHabit = context
        .watch<HabitProvider>()
        .weeklyHabit[context.watch<HabitProvider>().isoWeekNumber(today)];
    if (dailyHabit != null) {
      total = dailyHabit;
    }
    if (weeklyHabit != null) {
      total += weeklyHabit;
    }
    for (final habit in total) {
      print("total : ${habit.name}");
    }
    return SizedBox(
      height: 30,
      child: NotificationListener<OverscrollIndicatorNotification>(
        // ignore: missing_return
        onNotification: (overScroll) {
          overScroll.disallowGlow();
        },
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: total.length + 1,
            itemBuilder: (context, index) => _buildCategoryItem(index)),
      ),
    );
  }

  Widget _buildCategoryItem(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selIndex = index;
          if (index == 0) {
            addedTimeID = null;
            goalIsWeek = false;
          } else {
            addedTimeID = total[index - 1].addedTimeID;
            goalIsWeek = total[index - 1].goalIsWeek;
          }
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 2.0),
        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20),
        decoration: selIndex == index
            ? BoxDecoration(
                color: kDarkPurpleColor,
                borderRadius: BorderRadius.circular(40.0))
            : BoxDecoration(),
        child: Text(
          index == 0 ? "전체" : total[index - 1].name,
          style: TextStyle(
              color: selIndex == index
                  ? kWhiteIvoryColor
                  : kIvoryColor.withOpacity(0.4),
              fontSize: 14.0,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildChart(DateTime addedTimeID) {
    return AspectRatio(
      aspectRatio: 1.70,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
          color: kIvoryColor,
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '목표 유지율',
                style: TextStyle(fontSize: 16, color: Color(0xff585A79)),
              ),
            ),
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.only(
                    right: 35.0, left: 15.0, top: 50, bottom: 12),
                child: LineChart(
                  _lineData(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  LineChartData _lineData() {
    return LineChartData(
      gridData: FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          textStyle: const TextStyle(
              color: Color(0xff585A79),
              fontWeight: FontWeight.bold,
              fontSize: 12),
          getTitles: (value) {
//            return value.toInt().toString();
            int center = (spots.length / 2).floor();
            if (value.toInt() == 0) {
              return '1주차';
            } else if (value.toInt() == center && spots.length > 2) {
              return (value.toInt() + 1).toString() + '주차';
            } else if (value.toInt() == spots.length - 1) {
              return '저번주';
            }
/*
            switch (value.toInt()) {
              case 0:
                return '1주차';
              case center:
                return '2';
              case 3:
                return 'SEP';
            }

 */
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: const TextStyle(
            color: Color(0xff585A79),
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return '0%';
              case 50:
                return '50%';
              case 100:
                return '100%';
            }
            return '';
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(show: false),
      lineTouchData: LineTouchData(
          getTouchedSpotIndicator:
              (LineChartBarData barData, List<int> spotIndexes) {
            return spotIndexes.map((spotIndex) {
              return TouchedSpotIndicatorData(
                FlLine(color: kDarkPurpleColor, strokeWidth: 2),
                FlDotData(
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                        radius: 6, color: kDarkPurpleColor, strokeWidth: 0.0);
                  },
                ),
              );
            }).toList();
          },
          touchSpotThreshold: 10.0,
          touchTooltipData: LineTouchTooltipData(
              tooltipPadding: EdgeInsets.all(4.0),
              tooltipRoundedRadius: 3.0,
              tooltipBgColor: kWhiteIvoryColor,
              getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                return touchedBarSpots.map((barSpot) {
                  final flSpot = barSpot;
                  return LineTooltipItem(
                    flSpot.y == 100.01
                        ? '${flSpot.x.toInt() + 1}주차 ${flSpot.y.toStringAsFixed(1)}+ %'
                        : '${flSpot.x.toInt() + 1}주차 ${flSpot.y.toStringAsFixed(1)} %',
                    const TextStyle(
                        color: kPurpleColor, fontWeight: FontWeight.bold),
                  );
                }).toList();
              })),
      minY: 0,
      maxY: 100,
      lineBarsData: [
        LineChartBarData(
          spots: getFlSpot(addedTimeID),
          colors: gradientColors,
          isCurved: true,
          isStrokeCapRound: true,
          barWidth: 3,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: false,
            colors:
                gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }

  List<FlSpot> getFlSpot(DateTime addedTimeID) {
    print("ID : $addedTimeID---");
    List<double> spotList;
    try {
      spotList = context.watch<HabitProvider>().getRetention(addedTimeID);
    } catch (e) {
      spotList = null;
    }
    print("len : ${spotList.length}");
    if (spotList == null || spotList.length == 0) {
      spots = [FlSpot(0, 0)];
    } else {
      spots = [];
      for (int i = 0; i < spotList.length; i++) {
//        print("spot : ${spotList[i]}");
        if (spotList[i] > 100.0) {
          spots.add(FlSpot(i.toDouble(), 100.01));
//          print("real : ${spots[i].y}");
        } else {
          spots.add(FlSpot(i.toDouble(), spotList[i]));
        }
      }
    }
    return spots;
  }
}
