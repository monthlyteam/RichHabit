import 'dart:core';

import 'package:flutter/material.dart';
import 'package:richhabit/habit.dart';

class HabitProvider with ChangeNotifier {
  DateTime nowDate;
  int nowWeekOfYear;

  Map<DateTime, List<Habit>> triggerHabit = {};
  Map<DateTime, List<Habit>> dailyHabit = {};
  Map<int, List<Habit>> weeklyHabit = {};

  HabitProvider() {
    var now = DateTime.now();
    nowDate = DateTime(now.year, now.month, now.day);
    nowWeekOfYear = isoWeekNumber(now);
  }

  void addHabit(Habit newHabit) {
    if (newHabit.isTrigger == true) {
      //triggerHabit
      if (triggerHabit.containsKey(nowDate)) {
        triggerHabit[nowDate].add(newHabit);
      } else {
        triggerHabit[nowDate] = [newHabit];
      }
    } else {
      //not triggerHabit
      if (newHabit.goalIsWeek == false) {
        //dailyHabit
        if (dailyHabit.containsKey(nowDate)) {
          dailyHabit[nowDate].add(newHabit);
        } else {
          dailyHabit[nowDate] = [newHabit];
        }
      } else {
        //weeklyHabit
        if (weeklyHabit.containsKey(nowWeekOfYear)) {
          weeklyHabit[nowWeekOfYear].add(newHabit);
        } else {
          weeklyHabit[nowWeekOfYear] = [newHabit];
        }
      }
    }
    notifyListeners();
  }

  void deleteHabit(String habitName, bool goalIsWeek) {
    if (goalIsWeek) {
      // weekly
      weeklyHabit[nowWeekOfYear]
          .removeWhere((element) => element.name == habitName);
    } else {
      //daily
      dailyHabit[nowDate].removeWhere((element) => element.name == habitName);
    }

    notifyListeners();
  }

  void modifyHabit(String habitName, bool goalIsWeek, bool newCycle,
      int newAmount, double newPrice) {
    if (goalIsWeek == newCycle) {
      //주기가 바뀐게 아니라면
      if (goalIsWeek) {
        //weekly
        int index = weeklyHabit[nowWeekOfYear]
            .indexWhere((element) => element.name == habitName);
        weeklyHabit[nowWeekOfYear][index].goalAmount = newAmount;
        weeklyHabit[nowWeekOfYear][index].price = newPrice;
      } else {
        //daily
        int index = dailyHabit[nowDate]
            .indexWhere((element) => element.name == habitName);
        dailyHabit[nowDate][index].goalAmount = newAmount;
        dailyHabit[nowDate][index].price = newPrice;
      }
    } else {
      //주기가 바뀐거 경우라면(Daily -> Weekly)
      /*
   Ex
   월요일에 흡연을 만들고
   화요일에 흡연을 삭제한다고 가정
   수요일에 새로운 흡연을 만들었을 때
   금요일에 주기를 변경한다면 내가 어떻게 같은 주기인걸 알까?
    */

    }
  }

  int isoWeekNumber(DateTime date) {
    int daysToAdd = DateTime.thursday - date.weekday;
    print('$daysToAdd , ${date.weekday}');
    DateTime thursdayDate = daysToAdd > 0
        ? date.add(Duration(days: daysToAdd))
        : date.subtract(Duration(days: daysToAdd.abs()));
    int dayOfYearThursday = _dayOfYear(thursdayDate);
    return 1 + ((dayOfYearThursday - 1) / 7).floor();
  }

  int _dayOfYear(DateTime date) {
    return date.difference(DateTime(date.year, 1, 1)).inDays;
  }
}
