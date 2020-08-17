import 'package:flutter/material.dart';
import 'package:richhabit/constants.dart';
import 'package:provider/provider.dart';

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

  @override
  void initState() {
    super.initState();
    current = DateTime.now();
    today = DateTime(current.year, current.month, current.day);
    dailyHabit = context.read<HabitProvider>().dailyHabit[today];
    weeklyHabit = context.read<HabitProvider>().weeklyHabit[
        today.year * 100 + context.read<HabitProvider>().isoWeekNumber(today)];
    if (dailyHabit != null) {
      total = dailyHabit;
    }
    if (weeklyHabit != null) {
      total += weeklyHabit;
    }
    for (final habit in total) {
      print("total : ${habit.name}");
    }
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
                        children: [Text("lala")],
                      ),
                    ),
                    SizedBox(height: kPadding),
                    Container(
                      padding: EdgeInsets.all(10.0),
                      height: 180,
                      decoration: BoxDecoration(
                        color: kIvoryColor,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Row(
                        children: [Text("lala")],
                      ),
                    ),
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
}
