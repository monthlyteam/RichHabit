import 'dart:core';

import 'package:flutter/material.dart';
import 'package:richhabit/habit.dart';

class HabitProvider with ChangeNotifier {
  DateTime nowDate;
  int nowWeekOfYear; //2020년 3주차이면, 202003 으로 표시

  Map<DateTime, List<Habit>> triggerHabit = {};
  Map<DateTime, List<Habit>> dailyHabit = {};
  Map<int, List<Habit>> weeklyHabit = {};
  Map<DateTime, List<int>> warningCount = {}; //달력에 표시되는 아이콘

  HabitProvider() {
    var now = DateTime.now();
    nowDate = DateTime(now.year, now.month, now.day);
    nowWeekOfYear = (now.year * 100) + isoWeekNumber(now);
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

  void deleteHabit(DateTime addedTimeID, bool goalIsWeek) {
    if (goalIsWeek) {
      // weekly
      weeklyHabit[nowWeekOfYear]
          .removeWhere((element) => element.addedTimeID == addedTimeID);
    } else {
      //daily
      dailyHabit[nowDate]
          .removeWhere((element) => element.addedTimeID == addedTimeID);
    }

    notifyListeners();
  }

  //주기가 바뀐경우 Weekly => daily는 호출 없다고 가정
  void modifyHabit(DateTime addedTimeID, bool goalIsWeek, bool newCycle,
      int newAmount, double newPrice) {
    if (goalIsWeek == newCycle) {
      //주기가 바뀐게 아니라면
      if (goalIsWeek) {
        //weekly
        int index = weeklyHabit[nowWeekOfYear]
            .indexWhere((element) => element.addedTimeID == addedTimeID);
        weeklyHabit[nowWeekOfYear][index].goalAmount = newAmount;
        weeklyHabit[nowWeekOfYear][index].price = newPrice;
      } else {
        //daily
        int index = dailyHabit[nowDate]
            .indexWhere((element) => element.addedTimeID == addedTimeID);
        dailyHabit[nowDate][index].goalAmount = newAmount;
        dailyHabit[nowDate][index].price = newPrice;
      }
    } else {
      //주기가 바뀐거 경우라면(Daily -> Weekly)
      int thisWeek = nowDate.weekday;

      for (int i = 0; i > thisWeek; i++) {}
    }

    notifyListeners();
  }

  //이번달 예상 절약 금액(전부 null이면 전체)
  double thisMonthExpected(DateTime addedTimeID, bool goalIsWeek) {
    int maxDayOfMonth = DateTime(nowDate.year, nowDate.month + 1, 1)
        .subtract(Duration(days: 1))
        .day;

    if (addedTimeID == null) {
      double sum = 0;
      weeklyHabit[nowWeekOfYear].forEach((element) {
        sum += (element.expectedSaveMoney / 7) * maxDayOfMonth;
      });

      dailyHabit[nowDate].forEach((element) {
        sum += element.expectedSaveMoney * maxDayOfMonth;
      });

      return sum;
    } else {
      if (goalIsWeek) {
        //Weekly
        int index = weeklyHabit[nowWeekOfYear]
            .indexWhere((element) => element.addedTimeID == addedTimeID);

        return (weeklyHabit[nowWeekOfYear][index].expectedSaveMoney / 7) *
            maxDayOfMonth;
      } else {
        //daily
        int index = dailyHabit[nowDate]
            .indexWhere((element) => element.addedTimeID == addedTimeID);

        return dailyHabit[nowWeekOfYear][index].expectedSaveMoney *
            maxDayOfMonth;
      }
    }
  }

  //복리 가치 계산
  double compoundInterest(
      double thisMonthExpected, int year, int interestRate) {
    double money = 0;
    double v = 0;
    for (var i = 0; i < year * 12; i++) {
      v = money * interestRate / 12;
      money += thisMonthExpected + v;
    }

    return money;
  }

  //누적 절약 금액 계산
  double cumSaving() {
    double sum = 0;
    weeklyHabit.forEach((key, value) {
      value.forEach((element) {
        sum += element.saveMoney;
      });
    });

    dailyHabit.forEach((key, value) {
      value.forEach((element) {
        sum += element.saveMoney;
      });
    });
    return sum;
  }

  //해당 DateTime key값이 없으면 '물음표' 로 간주
  void onWarning() {
    if (warningCount.containsKey(nowDate)) {
      warningCount[nowDate][0]++;
    } else {
      warningCount[nowDate][0] = 1;
    }

    notifyListeners();
  }

  //총 누적 절약금액의 절약 기록 표시
  void showCumSavingHistory() {
    Map<int, Map<int, Map<int, List<String>>>> map = {};
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
