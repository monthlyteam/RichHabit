import 'dart:core';

import 'package:flutter/material.dart';
import 'package:richhabit/habit.dart';

class HabitProvider with ChangeNotifier {
  DateTime nowDate;
  int nowWeekOfYear; //2020년 3주차이면, 202003 으로 표시

  Map<DateTime, List<Habit>> triggerHabit = {};
  Map<DateTime, List<Habit>> dailyHabit = {};
  Map<int, List<Habit>> weeklyHabit = {};
  Map<DateTime, List<int>> calendarIcon = {}; //달력에 표시되는 아이콘

  HabitProvider() {
    var now = DateTime.now();
    nowDate = DateTime(now.year, now.month, now.day);
    nowWeekOfYear = (now.year * 100) + isoWeekNumber(now);

    initHabit();
  }

  //날짜 확인후 처음 들어오면 이전 습관 틀 제공
  void initHabit() {
    var dailyKeys = dailyHabit.keys.toList();
    var weeklyKeys = weeklyHabit.keys.toList();

    DateTime lastDate = dailyKeys.last;
    int lastNowWeekOfYear = weeklyKeys.last;
    Habit initHabit;

    List<Habit> initTriggerHabitList = [];
    triggerHabit[lastDate].forEach((element) {
      initHabit = element;
      initHabit.nowAmount = 0;
      initTriggerHabitList.add(initHabit);
    });

    List<Habit> initDailyHabitList = [];
    dailyHabit[lastDate].forEach((element) {
      initHabit = element;
      initHabit.nowAmount = 0;
      initDailyHabitList.add(initHabit);
    });

    List<Habit> initWeeklyHabitList = [];
    weeklyHabit[lastNowWeekOfYear].forEach((element) {
      initHabit = element;
      initHabit.nowAmount = 0;
      initWeeklyHabitList.add(initHabit);
    });

    for (int i = 0; lastDate.add(Duration(days: i)) != nowDate; i++) {
      triggerHabit[lastDate.add(Duration(days: i + 1))] = initTriggerHabitList;
      dailyHabit[lastDate.add(Duration(days: i + 1))] = initDailyHabitList;
      calendarIcon[lastDate.add(Duration(days: i + 1))] = [0];
    }

    for (int i = 0; lastNowWeekOfYear + i != nowWeekOfYear; i++) {
      weeklyHabit[lastNowWeekOfYear + 1] = initWeeklyHabitList;
    }
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
      // TODO: 1.Modify Cycle Daily to Weekly
      for (int i = 0; i > thisWeek; i++) {}
    }

    notifyListeners();
  }

  void plusNowAmount(DateTime inputTime, DateTime addedTimeID, bool goalIsWeek,
      bool isTrigger) {
    if (isTrigger) {
      int index = triggerHabit[inputTime]
          .indexWhere((element) => element.addedTimeID == addedTimeID);

      triggerHabit[inputTime][index].nowAmount++;
    } else {
      if (goalIsWeek) {
        int isoWeekOfYear = isoWeekNumber(inputTime);
        //weekly
        int index = weeklyHabit[isoWeekOfYear]
            .indexWhere((element) => element.addedTimeID == addedTimeID);

        weeklyHabit[isoWeekOfYear][index].nowAmount++;
        if (weeklyHabit[isoWeekOfYear][index].nowAmount >
            weeklyHabit[isoWeekOfYear][index].goalAmount) {
          calendarIcon[inputTime] = [2];
        } else {
          calendarIcon[inputTime] = [1];
        }
      } else {
        //daily
        int index = dailyHabit[inputTime]
            .indexWhere((element) => element.addedTimeID == addedTimeID);

        dailyHabit[inputTime][index].nowAmount++;
        if (dailyHabit[inputTime][index].nowAmount >
            dailyHabit[inputTime][index].goalAmount) {
          calendarIcon[inputTime] = [2];
        } else {
          calendarIcon[inputTime] = [1];
        }
      }
    }

    notifyListeners();
  }

  void minusNowAmount(DateTime inputTime, DateTime addedTimeID, bool goalIsWeek,
      bool isTrigger) {
    if (isTrigger) {
      int index = triggerHabit[inputTime]
          .indexWhere((element) => element.addedTimeID == addedTimeID);

      triggerHabit[inputTime][index].nowAmount--;
    } else {
      if (goalIsWeek) {
        int isoWeekOfYear = isoWeekNumber(inputTime);
        //weekly
        int index = weeklyHabit[isoWeekOfYear]
            .indexWhere((element) => element.addedTimeID == addedTimeID);

        weeklyHabit[isoWeekOfYear][index].nowAmount--;
        if (weeklyHabit[isoWeekOfYear][index].nowAmount >
            weeklyHabit[isoWeekOfYear][index].goalAmount) {
          calendarIcon[inputTime] = [2];
        } else {
          calendarIcon[inputTime] = [1];
        }
      } else {
        //daily
        int index = dailyHabit[inputTime]
            .indexWhere((element) => element.addedTimeID == addedTimeID);

        dailyHabit[inputTime][index].nowAmount--;
        if (dailyHabit[inputTime][index].nowAmount >
            dailyHabit[inputTime][index].goalAmount) {
          calendarIcon[inputTime] = [2];
        } else {
          calendarIcon[inputTime] = [1];
        }
      }
    }

    notifyListeners();
  }

  //이번달 예상 절약 금액(addedTimeID null이면 => 전체)
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

  //누적 절약 금액 계산(addedTimeID null이면 => 전체)
  double cumSaving(DateTime addedTimeID) {
    double sum = 0;
    if (addedTimeID == null) {
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
    } else {
      dailyHabit.forEach((key, value) {
        value.forEach((element) {
          if (element.addedTimeID == addedTimeID) {
            sum += element.saveMoney;
          }
        });
      });

      weeklyHabit.forEach((key, value) {
        value.forEach((element) {
          if (element.addedTimeID == addedTimeID) {
            sum += element.saveMoney;
          }
        });
      });
    }

    return sum;
  }

  //총 누적 절약금액의 절약 기록 표시(addedTimeID null이면 => 전체)
  Map<dynamic, dynamic> showCumSavingHistory(DateTime addedTimeID) {
    Map<int, Map<int, Map<int, List<String>>>> map = {};
    // TODO: 2.Show cumSavingHistory

    return map;
  }

  //목표 유지율 표시(addedTimeID null이면 => 전체)
  List<double> getRetention(DateTime addedTimeID) {
    // TODO : 3.getRetention
    Map<int, double> retentions = {};
    if (addedTimeID == null) {
      int weeks = 0;
      double avg = 0;
      int len = 0;
      weeklyHabit.forEach((key, value) {
        value.forEach((element) {
          avg = 0;
          avg += element.retention;
        });
        len = value.length;
        retentions[weeks] = avg / len;
        weeks++;
      });

      weeks = 0;
      avg = 0;
      double dailyAvg = 0;
      dailyHabit.forEach((key, value) {
        value.forEach((element) {
          dailyAvg = 0;
          dailyAvg += element.retention;
        });
      });
    } else {}
    return null;
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
