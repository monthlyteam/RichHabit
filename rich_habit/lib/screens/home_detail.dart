import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:richhabit/constants.dart';
import 'package:provider/provider.dart';
import 'package:richhabit/habit_provider.dart';
import 'package:richhabit/user_provider.dart';
import 'package:intl/intl.dart';

import '../habit.dart';
import 'home_detail_edit.dart';

class HomeDetail extends StatelessWidget {
  final Habit habit;

  HomeDetail({@required this.habit});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 20.0,
                  width: 20.0,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    iconSize: 20.0,
                    padding: EdgeInsets.all(0.0),
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: kWhiteIvoryColor,
                    ),
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () async {
                    var isChanged = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomeDetailEdit(
                                habit: habit,
                              )),
                    );
                    if (isChanged == null || isChanged) {
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    "편집",
                    style: TextStyle(color: kWhiteIvoryColor, fontSize: 16.0),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              height: 150,
              width: 150,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: kIvoryColor),
              child: Center(
                child: SvgPicture.asset(
                  habit.iconURL,
                  height: 70.0,
                  width: 70.0,
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              "${habit.name}",
              style: TextStyle(
                  fontSize: 25.0,
                  color: kWhiteIvoryColor,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              width: 32,
              child: Divider(
                thickness: 3.0,
                height: 3.0,
                color: kWhiteIvoryColor,
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  habit.isTrigger
                      ? Container()
                      : Text(
                          "\"평균 목표 달성률 ${_getPercent(context)}\"",
                          style: TextStyle(
                              fontSize: 14.0,
                              color: kWhiteIvoryColor.withOpacity(0.8)),
                          textAlign: TextAlign.center,
                        ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 85.0,
                          decoration: BoxDecoration(
                              color: kIvoryColor,
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Column(
                              children: [
                                Text(
                                  "설정 횟수",
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: kPurpleColor.withOpacity(0.5)),
                                ),
                                Text(
                                  "${habit.goalIsWeek ? "매주 " : "매일 "}" +
                                      "${habit.goalAmount}회",
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: kPurpleColor,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      Expanded(
                        child: Container(
                          height: 85.0,
                          decoration: BoxDecoration(
                              color: kIvoryColor,
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Column(
                              children: [
                                Text(
                                  "평소 횟수",
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: kPurpleColor.withOpacity(0.5)),
                                ),
                                Text(
                                  "${habit.usualIsWeek ? "매주 " : "매일 "}" +
                                      "${habit.usualAmount}회",
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: kPurpleColor,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    height: 40.0,
                    decoration: BoxDecoration(
                        color: kIvoryColor,
                        borderRadius: BorderRadius.circular(5.0)),
                    child: habit.isTrigger
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "알람 시간",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: kPurpleColor.withOpacity(0.5),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                  context.watch<UserProvider>().pushAlarmTime !=
                                          null
                                      ? "${DateFormat.jm().format(context.watch<UserProvider>().pushAlarmTime)}"
                                      : "알람 시간이 없어요!",
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: kPurpleColor,
                                      fontWeight: FontWeight.bold))
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${habit.name} 1회 당 평균 소비 금액",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: kPurpleColor.withOpacity(0.5),
                                ),
                              ),
                              Text(
                                "${habit.price.round()}원",
                                style: TextStyle(
                                    fontSize: 16.0,
                                    color: kPurpleColor,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                  ),
                  SizedBox(
                    height: 40.0,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getPercent(BuildContext context) {
    var list = context.watch<HabitProvider>().getRetention(habit.addedTimeID);
    var avg = 0.0;
    var str = "좀 더 절약해 보는게 어떤가요?";
    if (list == null || list.length == 0) {
      str = "데이터를 더 모아주세요!";
    } else {
      avg = list.reduce((a, b) => a + b);
      avg = avg / list.length;
    }
    if (avg >= 100.0) {
      str = "현재 달성률을 유지하세요!";
    }
    return "${avg.toStringAsFixed(1)}%! $str";
  }
}
