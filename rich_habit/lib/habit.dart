import 'package:flutter/cupertino.dart';

class Habit {
  DateTime addedTimeID; //추가한 날의 시간

  String name;
  String iconURL;
  double price; //습관 1회당 가격
  bool isTrigger;

  bool usualIsWeek; // 평상시 횟수 단위 Daily = false, Weekly = true
  int usualAmount; //평상시 습관 양

  bool goalIsWeek; // 목표 횟수 단위 Daily = false, Weekly = true
  int goalAmount; // 목표 습관 양

  int nowAmount = 0; // 현재 습관 양

  Habit({
    @required this.addedTimeID,
    this.isTrigger = false,
    @required this.name,
    @required this.iconURL,
    this.price,
    this.usualIsWeek,
    this.usualAmount,
    this.goalIsWeek,
    this.goalAmount,
  });

  double get retention //목표 유지율
      => ((usualAmount - nowAmount) / (usualAmount - goalAmount)) * 100.0;

  double get saveMoney //절약 금액
      => (usualAmount - nowAmount) * price;

  double get expectedSaveMoney //예상 절약 금액
      => (usualAmount - goalAmount) * price;

  void addNowAmount() {
    nowAmount++;
  }

  void subNowAmount() {
    nowAmount--;
  }

  void modifyGoalCycle(bool isWeek) {
    this.goalIsWeek = isWeek;
  }

  void modifyGoalAmount(int goalAmount) {
    this.goalAmount = goalAmount;
  }

  void modifyPrice(double price) {
    this.price = price;
  }
}