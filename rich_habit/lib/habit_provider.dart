import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:richhabit/habit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HabitProvider with ChangeNotifier {
  DateTime nowDate;
  int nowWeekOfYear; //2020년 3주차이면, 202003 으로 표시
  SharedPreferences sp;

  Map<DateTime, List<Habit>> triggerHabit = Map<DateTime, List<Habit>>();
  Map<DateTime, List<Habit>> dailyHabit = Map<DateTime, List<Habit>>();
  Map<int, List<Habit>> weeklyHabit = Map<int, List<Habit>>();
  Map<DateTime, List<int>> calendarIcon =
      Map<DateTime, List<int>>(); //달력에 표시되는 아이콘

  HabitProvider(
      {this.sp,
      this.triggerHabit,
      this.dailyHabit,
      this.weeklyHabit,
      this.calendarIcon}) {
    var now = DateTime.now();
    nowDate = DateTime(now.year, now.month, now.day);
    nowWeekOfYear = isoWeekNumber(now);

    initHabit();
  }

  void initHabit() async {
    var calendarKeys = calendarIcon.keys.toList();
    //유저가 데이터가 있고, 오늘 처음 접속이면
    //빈 날짜에 Habit을 채움
    if (calendarKeys.length == 0) {
      calendarIcon[nowDate] = [0]; //처음 접속일 경우
    } else if (calendarKeys.last != nowDate) {
      var triggerKeys = triggerHabit.keys.toList();
      var dailyKeys = dailyHabit.keys.toList();
      var weeklyKeys = weeklyHabit.keys.toList();

      DateTime lastDate;
      int lastNowWeekOfYear;

      List<Habit> initTriggerHabitList = [];
      List<Habit> initDailyHabitList = [];
      List<Habit> initWeeklyHabitList = [];

      Habit initHabit;

      if (triggerKeys.length != 0) {
        lastDate = triggerKeys.last;
        triggerHabit[lastDate].forEach((element) {
          initHabit = Habit.fromJson(element.toJson());
          initHabit.nowAmount = 0;
          initTriggerHabitList.add(initHabit);
        });

        for (int i = 1; lastDate.add(Duration(days: i - 1)) != nowDate; i++) {
          triggerHabit[lastDate.add(Duration(days: i))] = initTriggerHabitList
              .map((e) => Habit.fromJson(e.toJson()))
              .toList();
        }
      }

      if (dailyKeys.length != 0) {
        lastDate = dailyKeys.last;
        dailyHabit[lastDate].forEach((element) {
          initHabit = Habit.fromJson(element.toJson());
          initHabit.nowAmount = 0;
          initDailyHabitList.add(initHabit);
        });

        for (int i = 1; lastDate.add(Duration(days: i - 1)) != nowDate; i++) {
          dailyHabit[lastDate.add(Duration(days: i))] = initDailyHabitList
              .map((e) => Habit.fromJson(e.toJson()))
              .toList();
        }
      }

      if (weeklyKeys.length != 0) {
        lastNowWeekOfYear = weeklyKeys.last;
        if (lastNowWeekOfYear != nowWeekOfYear) {
          weeklyHabit[lastNowWeekOfYear].forEach((element) {
            initHabit = Habit.fromJson(element.toJson());
            initHabit.nowAmount = 0;
            initWeeklyHabitList.add(initHabit);
          });

          for (int i = lastNowWeekOfYear + 1; i - 1 != nowWeekOfYear; i++) {
            weeklyHabit[i] = initWeeklyHabitList
                .map((e) => Habit.fromJson(e.toJson()))
                .toList();
          }
        }
      }

      for (int i = 1;
          calendarKeys.last.add(Duration(days: i - 1)) != nowDate;
          i++) {
        calendarIcon[calendarKeys.last.add(Duration(days: i))] = [0];
      }

      _setLocalDB();
      notifyListeners();
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
    _setLocalDB();
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

    _setLocalDB();
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

    _setLocalDB();
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
      } else {
        //daily
        int index = dailyHabit[inputTime]
            .indexWhere((element) => element.addedTimeID == addedTimeID);

        dailyHabit[inputTime][index].nowAmount++;
      }
    }

    _checkCalendarIcon(inputTime);
    _setLocalDB();
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
      } else {
        //daily
        int index = dailyHabit[inputTime]
            .indexWhere((element) => element.addedTimeID == addedTimeID);

        dailyHabit[inputTime][index].nowAmount--;
      }
    }

    _checkCalendarIcon(inputTime);
    _setLocalDB();
    notifyListeners();
  }

  //데이터 초기화
  void resetData() {
    triggerHabit = Map<DateTime, List<Habit>>();
    dailyHabit = Map<DateTime, List<Habit>>();
    weeklyHabit = Map<int, List<Habit>>();
    calendarIcon = Map<DateTime, List<int>>();

    calendarIcon[nowDate] = [0]; //처음 접속일 경우

    sp.clear();
    notifyListeners();
  }

  //이번달 예상 절약 금액(addedTimeID null이면 => 전체)
  double thisMonthExpected(DateTime addedTimeID, bool goalIsWeek) {
    int maxDayOfMonth = DateTime(nowDate.year, nowDate.month + 1, 1)
        .subtract(Duration(days: 1))
        .day;

    if (addedTimeID == null) {
      double sum = 0;
      if (weeklyHabit[nowWeekOfYear] != null) {
        weeklyHabit[nowWeekOfYear].forEach((element) {
          sum += (element.expectedSaveMoney / 7) * maxDayOfMonth;
        });
      }
      if (dailyHabit[nowDate] != null) {
        dailyHabit[nowDate].forEach((element) {
          sum += element.expectedSaveMoney * maxDayOfMonth;
        });
      }

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

        return dailyHabit[nowDate][index].expectedSaveMoney * maxDayOfMonth;
      }
    }
  }

  //복리 가치 계산
  double compoundInterest(
      double thisMonthExpected, int year, int interestRate) {
    double money = thisMonthExpected;
    double v = 0;
    for (var i = 0; i < year * 12; i++) {
      v = money * interestRate / 100 / 12;
      money += thisMonthExpected + v;
    }

    return money;
  }

  //누적 절약 금액 계산(addedTimeID null이면 => 전체)
  double cumSaving(DateTime addedTimeID) {
    double sum = 0;
    if (addedTimeID == null) {
      if (weeklyHabit.isNotEmpty) {
        weeklyHabit.forEach((key, value) {
          if (key != nowWeekOfYear && _checkWeekIsEmpty(key)) {
            value.forEach((element) {
              sum += element.saveMoney;
            });
          }
        });
      }

      if (dailyHabit.isNotEmpty) {
        dailyHabit.forEach((key, value) {
          if (key != nowDate && calendarIcon[key][0] != 0) {
            value.forEach((element) {
              sum += element.saveMoney;
            });
          }
        });
      }
    } else {
      if (dailyHabit.isNotEmpty) {
        dailyHabit.forEach((key, value) {
          if (key != nowDate && calendarIcon[key][0] != 0) {
            value.forEach((element) {
              if (element.addedTimeID == addedTimeID) {
                sum += element.saveMoney;
              }
            });
          }
        });
      }

      if (weeklyHabit.isNotEmpty) {
        weeklyHabit.forEach((key, value) {
          if (key != nowWeekOfYear && _checkWeekIsEmpty(key)) {
            value.forEach((element) {
              if (element.addedTimeID == addedTimeID) {
                sum += element.saveMoney;
              }
            });
          }
        });
      }
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
    Map<int, Map<int, List<dynamic>>> map = Map<int, Map<int, List<dynamic>>>();

    int year = 0;
    int week = 0;
    double sumPrice = 0;

    if (weeklyHabit.isNotEmpty) {
      weeklyHabit.forEach((key, value) {
        if (key != nowWeekOfYear && _checkWeekIsEmpty(key)) {
          year = key ~/ 100;
          week = key % 100;

          if (!map.containsKey(year)) map[year] = {};

          if (!map[year].containsKey(week)) map[year][week] = [null, []];

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
        }
      });
    }

    if (dailyHabit.isNotEmpty) {
      dailyHabit.forEach((key, value) {
        if (key != nowDate && calendarIcon[key][0] != 0) {
          year = key.year;
          week = isoWeekNumber(key) % 100;

          if (!map.containsKey(year)) map[year] = {};

          if (!map[year].containsKey(week)) map[year][week] = [null, []];

          value.forEach((element) {
            if (addedTimeID == null || addedTimeID == element.addedTimeID) {
              sumPrice += element.saveMoney;
              map[year][week][1]
                  .add(['${key.day}일 ${element.name}', element.saveMoney]);
            }
          });

          if (map[year][week][0] == null)
            map[year][week][0] = sumPrice;
          else
            map[year][week][0] += sumPrice;

          sumPrice = 0;
        }
      });
    }

    return map;
  }

  //목표 유지율 표시(addedTimeID null이면 => 전체)
  List<double> getRetention(DateTime addedTimeID) {
    List<double> result = [];
    Map<int, double> retentions = {};
    int startWeek = 0;
    double habitRet = 0;
    int len = 0;

    if (weeklyHabit.isNotEmpty) {
      weeklyHabit.forEach((key, value) {
        if (!(key >= nowWeekOfYear)) {
          if (startWeek == 0) startWeek = key;
          value.forEach((element) {
            if (_checkWeekIsEmpty(key) &&
                (addedTimeID == null || addedTimeID == element.addedTimeID)) {
              habitRet += element.retention;
              len++;
            }
          });

          if (len != 0) retentions[key] = habitRet / len;

          habitRet = 0;
          len = 0;
        }
      });
    }

    int dailyKey = 0;

    if (dailyHabit.isNotEmpty) {
      dailyHabit.forEach((key, value) {
        if (!(dailyKey >= nowWeekOfYear)) {
          if (len != 0 && dailyKey != 0 && dailyKey != isoWeekNumber(key)) {
            if (retentions.containsKey(dailyKey)) {
              retentions[dailyKey] += habitRet / len;
              retentions[dailyKey] /= 2;
            } else {
              retentions[dailyKey] = habitRet / len;
            }
            habitRet = 0;
            len = 0;
          }
          dailyKey = isoWeekNumber(key);

          value.forEach((element) {
            if (calendarIcon[key][0] != 0 &&
                (addedTimeID == null || addedTimeID == element.addedTimeID)) {
              habitRet += element.retention;
              len++;
            }
          });
        }
      });
    }

    DateTime startDate = triggerHabit.keys.first;
    int week = isoWeekNumber(startDate);

    for (int i = 0;
        isoWeekNumber(startDate.add(Duration(days: i))) < nowWeekOfYear;
        i += 7) {
      week = isoWeekNumber(startDate.add(Duration(days: i)));
      if (!(retentions.containsKey(week))) retentions[week] = -1;
    }

    var sortedKey = retentions.keys.toList()..sort();
    for (int i = 0; i < sortedKey.length; i++)
      result.add(retentions[sortedKey[i]]);

    return result;
  }

  int isoWeekNumber(DateTime date) {
    int daysToAdd = DateTime.thursday - date.weekday;
    DateTime thursdayDate = daysToAdd > 0
        ? date.add(Duration(days: daysToAdd))
        : date.subtract(Duration(days: daysToAdd.abs()));
    int dayOfYearThursday = _dayOfYear(thursdayDate);

    return thursdayDate.year * 100 +
        (1 + ((dayOfYearThursday - 1) / 7).floor());
  }

  int _dayOfYear(DateTime date) {
    return 1 + date.difference(DateTime(date.year, 1, 1)).inDays;
  }

  //해당 주의 월요일 표시
  DateTime weekNumberToDate(int weekNumber) {
    int year = weekNumber ~/ 100;
    int week = weekNumber % 100;

    DateTime tempDate = DateTime(year, 1, 1);
    if ((isoWeekNumber(tempDate) % 100) == 1) {
      tempDate = tempDate.subtract(Duration(days: tempDate.weekday - 1));
      return tempDate.add(Duration(days: (week - 1) * 7));
    } else {
      tempDate = tempDate.add(Duration(days: 8 - tempDate.weekday));
      return tempDate.add(Duration(days: (week - 1) * 7));
    }
  }

  void _checkCalendarIcon(DateTime inputTime) {
    int inputTimeWeekOfYear = isoWeekNumber(inputTime);
    calendarIcon[inputTime] = [1];

    if (dailyHabit.containsKey(inputTime)) {
      dailyHabit[inputTime].forEach((element) {
        if (element.nowAmount > element.goalAmount)
          calendarIcon[inputTime] = [2];
      });
    }

    if (weeklyHabit.containsKey(inputTimeWeekOfYear)) {
      DateTime tempTime;
      weeklyHabit[inputTimeWeekOfYear].forEach((element) {
        if (element.nowAmount > element.goalAmount) {
          for (int i = nowDate.weekday; i > 0; i--) {
            tempTime = nowDate.subtract(Duration(days: nowDate.weekday - i));

            if (calendarIcon[tempTime][0] != 0) calendarIcon[tempTime] = [2];
          }
        }
      });
    }
  }

  void _setLocalDB() {
    Map<String, dynamic> jsonMap = {};
    var json;

    //Trigger
    if (triggerHabit.isNotEmpty) {
      triggerHabit.forEach((key, value) {
        jsonMap[key.toString()] = value.map((e) => e.toJson()).toList();
      });
      json = jsonEncode(jsonMap);
      sp.setString('trigger', json);
    }

    //Daily
    jsonMap = {};
    if (dailyHabit.isNotEmpty) {
      dailyHabit.forEach((key, value) {
        jsonMap[key.toString()] = value.map((e) => e.toJson()).toList();
      });

      json = jsonEncode(jsonMap);
      sp.setString('daily', json.toString());
    }

    //Weekly
    jsonMap = {};
    if (weeklyHabit.isNotEmpty) {
      weeklyHabit.forEach((key, value) {
        jsonMap[key.toString()] = value.map((e) => e.toJson()).toList();
      });

      json = jsonEncode(jsonMap);
      sp.setString('weekly', json);
    }

    //Calendar
    jsonMap = {};
    if (calendarIcon.isNotEmpty) {
      calendarIcon.forEach((key, value) {
        jsonMap[key.toString()] = value;
      });

      json = jsonEncode(jsonMap);
      sp.setString('calendar', json);
    }
  }

  bool _checkWeekIsEmpty(int weekOfYear) {
    DateTime monOfWeek = weekNumberToDate(weekOfYear);
    bool check = false;

    for (int i = 0; i < 7; i++) {
      if (calendarIcon.containsKey(monOfWeek.add(Duration(days: i)))) {
        if (calendarIcon[monOfWeek.add(Duration(days: i))][0] != 0) {
          check = true;
        }
      }
    }

    return check;
  }
}
