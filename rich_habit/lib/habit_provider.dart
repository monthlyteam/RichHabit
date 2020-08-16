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

  //날짜 확인후 오 처음 들어오면 이전 습관 틀 제공
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
      DateTime date = nowDate;
      int weekDay = nowDate.weekday;
      //주기가 바뀐거 경우라면(Daily -> Weekly)
      int index = dailyHabit[nowDate]
          .indexWhere((element) => element.addedTimeID == addedTimeID);

      Habit changedHabit = dailyHabit[nowDate][index];
      changedHabit.goalIsWeek = true;
      changedHabit.goalAmount = newAmount;
      changedHabit.price = newPrice;

      int sum = 0;
      while (index != -1 || weekDay > 0) {
        sum += dailyHabit[date][index].nowAmount;
        dailyHabit[date].removeAt(index);
        date = date.subtract(Duration(days: 1));
        weekDay--;

        index = dailyHabit[date]
            .indexWhere((element) => element.addedTimeID == addedTimeID);
      }

      changedHabit.nowAmount = sum;
      weeklyHabit[nowWeekOfYear].add(changedHabit);
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
  /* Map<int:YEAR ,
        Map<int:Week,
          List[index 0: SaveMoney,
               index 1: List[index 0: '주기+습관이름', index 1: '절약금액']
          ]
        >
     >

     Year의 합은 일단 따로 꺼내서 계산.
   */
  Map<int, dynamic> showCumSavingHistory(DateTime addedTimeID) {
    Map<int, dynamic> map = {};
    int year = 0;
    int week = 0;
    double sumPrice = 0;
    weeklyHabit.forEach((key, value) {
      year = key ~/ 100;
      week = key % 100;
      map[year][week] = [];
      value.forEach((element) {
        if (addedTimeID == null || addedTimeID == element.addedTimeID) {
          sumPrice += element.saveMoney;
          map[year][week][1].add(['매주 ${element.name}', element.saveMoney]);
        }
      });

      if (map[year][week][0] == null)
        map[year][week][0] = sumPrice;
      else
        map[year][week][0] += sumPrice;

      sumPrice = 0;
    });

    dailyHabit.forEach((key, value) {
      year = key.year;
      week = isoWeekNumber(key);
      if (map[year][week] == null) {
        map[year][week] = [];
      }
      value.forEach((element) {
        if (addedTimeID == null || addedTimeID == element.addedTimeID) {
          sumPrice = element.saveMoney;
          map[year][week][1].add(['매일 ${element.name}', element.saveMoney]);
        }
      });

      if (map[year][week][0] == null)
        map[year][week][0] = sumPrice;
      else
        map[year][week][0] += sumPrice;

      sumPrice = 0;
    });

    return map;
  }

  //목표 유지율 표시(addedTimeID null이면 => 전체)
  List<double> getRetention(DateTime addedTimeID) {
    List<double> result = [];
    Map<int, double> retentions = {};
    int startWeek = 0;
    double habitRet = 0;
    int len = 0;

    weeklyHabit.forEach((key, value) {
      if (startWeek == 0) startWeek = key;
      value.forEach((element) {
        if (addedTimeID == null || addedTimeID == element.addedTimeID) {
          habitRet += element.retention;
          len++;
        }
      });
      retentions[key] = habitRet / len;
      habitRet = 0;
      len = 0;
    });

    int dailyKey = 0;
    dailyHabit.forEach((key, value) {
      if (dailyKey != 0 && dailyKey != key.year * 100 + isoWeekNumber(key)) {
        if (retentions.containsKey(dailyKey)) {
          retentions[dailyKey] += habitRet / len;
          retentions[dailyKey] /= 2;
        } else {
          retentions[dailyKey] = habitRet / len;
        }
        habitRet = 0;
        len = 0;
      }
      dailyKey = key.year * 100 + isoWeekNumber(key);

      value.forEach((element) {
        if (addedTimeID == null || addedTimeID == element.addedTimeID) {
          habitRet += element.retention;
          len++;
        }
      });
    });

    var sortedKey = retentions.keys.toList()..sort();
    for (int i = 0; i < sortedKey.length; i++) {
      result[i] = retentions[sortedKey[i]];
    }
    return result;
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
