import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:richhabit/constants.dart';
import 'package:provider/provider.dart';
import 'package:richhabit/habit_provider.dart';
import 'package:richhabit/user_provider.dart';

import '../habit.dart';

class HomeDetailEdit extends StatefulWidget {
  final Habit habit;

  HomeDetailEdit({@required this.habit});

  @override
  _HomeDetailEditState createState() => _HomeDetailEditState();
}

class _HomeDetailEditState extends State<HomeDetailEdit> {
  TextEditingController _goalAmountCont;
  TextEditingController _priceCont;
  DateTime _dateTime;
  var focus = FocusNode();
  bool _goalIsWeek;
  double _height;

  @override
  void initState() {
    super.initState();
    _goalAmountCont =
        new TextEditingController(text: "${widget.habit.goalAmount}");
    _priceCont =
        new TextEditingController(text: "${widget.habit.price.round()}");
    _goalIsWeek = widget.habit.goalIsWeek;

    _dateTime = context.read<UserProvider>().pushAlarmTime;
    if (_dateTime == null) {
      _dateTime = DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    print("init : $_dateTime");
    var height = MediaQuery.of(context).size.height;
    var padding = MediaQuery.of(context).padding;
    _height = height - padding.top - padding.bottom;
    _height = _height - 300.0 - 225.0 - 100.0;
    if (_height <= 40.0) {
      _height = 40.0;
    }
    print(_height);
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context, false);
                  },
                  child: Text(
                    "취소",
                    style: TextStyle(color: kWhiteIvoryColor, fontSize: 16.0),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _showDelDialog(context);
                  },
                  child: Text(
                    "삭제",
                    style: TextStyle(color: kSelectedColor, fontSize: 16.0),
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
                  widget.habit.iconURL,
                  height: 70.0,
                  width: 70.0,
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              "${widget.habit.name}",
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
            SizedBox(
              height: _height,
            ),
            Container(
//              height: _height - 300.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 20, horizontal: 25.0),
                    decoration: BoxDecoration(
                        color: kIvoryColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25.0),
                            topRight: Radius.circular(25.0))),
                    child: widget.habit.isTrigger
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "알람 시간 설정",
                                style: TextStyle(
                                    fontSize: 12.0, color: kPurpleColor),
                              ),
                              Center(
                                child: SizedBox(
                                  height: 150,
                                  child: CupertinoTheme(
                                    data: CupertinoThemeData(
                                      textTheme: CupertinoTextThemeData(
                                        dateTimePickerTextStyle: TextStyle(
                                          color: kPurpleColor,
                                        ),
                                      ),
                                    ),
                                    child: CupertinoDatePicker(
                                      initialDateTime: _dateTime,
                                      mode: CupertinoDatePickerMode.time,
                                      onDateTimeChanged: (dateTime) {
                                        setState(() {
                                          _dateTime = dateTime;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "목표 주기 설정",
                                style: TextStyle(
                                    fontSize: 12.0, color: kPurpleColor),
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    child: Row(
                                      children: [
                                        _goalIsWeek
                                            ? Icon(
                                                Icons.radio_button_unchecked,
                                                color: kPurpleColor,
                                                size: 16,
                                              )
                                            : Icon(
                                                Icons.radio_button_checked,
                                                color: kPurpleColor,
                                                size: 16,
                                              ),
                                        SizedBox(width: 5.5),
                                        Text("매일",
                                            style: TextStyle(
                                                color: kPurpleColor,
                                                fontSize: 16,
                                                fontWeight: _goalIsWeek
                                                    ? FontWeight.normal
                                                    : FontWeight.bold)),
                                      ],
                                    ),
                                    onTap: () {
                                      setState(() {
                                        _goalIsWeek = false;
                                      });
                                    },
                                  ),
                                  SizedBox(
                                    width: 20.5,
                                  ),
                                  widget.habit.goalIsWeek
                                      ? GestureDetector(
                                          behavior: HitTestBehavior.translucent,
                                          child: Row(
                                            children: [
                                              _goalIsWeek
                                                  ? Icon(
                                                      Icons
                                                          .radio_button_checked,
                                                      color: kPurpleColor,
                                                      size: 16,
                                                    )
                                                  : Icon(
                                                      Icons
                                                          .radio_button_unchecked,
                                                      color: kPurpleColor,
                                                      size: 16,
                                                    ),
                                              SizedBox(width: 5.5),
                                              Text("매주",
                                                  style: TextStyle(
                                                      color: kPurpleColor,
                                                      fontSize: 16,
                                                      fontWeight: _goalIsWeek
                                                          ? FontWeight.bold
                                                          : FontWeight.normal)),
                                            ],
                                          ),
                                          onTap: () {
                                            setState(() {
                                              _goalIsWeek = true;
                                            });
                                          },
                                        )
                                      : Container(),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 152,
                                    height: 23,
                                    child: CupertinoTextField(
                                        controller: _goalAmountCont,
                                        textInputAction: TextInputAction.next,
                                        maxLength: 2,
                                        maxLines: 1,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 2, horizontal: 2),
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            color: kPurpleColor),
                                        keyboardType:
                                            TextInputType.numberWithOptions(),
                                        onSubmitted: (_) =>
                                            FocusScope.of(context)
                                                .requestFocus(focus)),
                                  ),
                                  SizedBox(
                                    width: 5.5,
                                  ),
                                  Text(
                                    "회",
                                    style: TextStyle(
                                        fontSize: 16.0, color: kPurpleColor),
                                  )
                                ],
                              ),
                              SizedBox(height: 18),
                              Text(
                                "1회당 평균 소비 비용 설정",
                                style: TextStyle(
                                    fontSize: 12.0, color: kPurpleColor),
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 152,
                                    height: 23,
                                    child: CupertinoTextField(
                                      focusNode: focus,
                                      controller: _priceCont,
                                      textInputAction: TextInputAction.done,
                                      maxLines: 1,
                                      padding: EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 2),
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          fontSize: 16.0, color: kPurpleColor),
                                      keyboardType:
                                          TextInputType.numberWithOptions(),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5.5,
                                  ),
                                  Text(
                                    "원",
                                    style: TextStyle(
                                        fontSize: 16.0, color: kPurpleColor),
                                  )
                                ],
                              ),
                            ],
                          ),
                  ),
                  SizedBox(height: 10.0),
                  GestureDetector(
                    onTap: () {
                      if (widget.habit.isTrigger) {
                        context.read<UserProvider>().pushAlarmTime = _dateTime;
                        print(
                            "time : ${context.read<UserProvider>().pushAlarmTime}");
                      } else {
                        context.read<HabitProvider>().modifyHabit(
                            widget.habit.addedTimeID,
                            widget.habit.goalIsWeek,
                            _goalIsWeek,
                            double.parse(_goalAmountCont.text),
                            double.parse(_priceCont.text));
                      }
                      Navigator.pop(context, false);
                      print("저장");
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 45,
                      decoration: BoxDecoration(
                          color: kDarkPurpleColor,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(25.0),
                              bottomRight: Radius.circular(25.0))),
                      child: Text(
                        "저장",
                        style: TextStyle(
                            fontSize: 16.0,
                            color: kWhiteIvoryColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 50.0)
          ],
        ),
      ),
    );
  }

  void _showDelDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext buildContext) {
          return Dialog(
            backgroundColor: kIvoryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
                height: 226,
                width: 320,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: 176,
                      padding: EdgeInsets.fromLTRB(26, 15, 26, 13),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 80,
                            width: 80,
                            padding: EdgeInsets.all(0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: kWhiteIvoryColor,
                            ),
                            child: Center(
                                child: SvgPicture.asset(
                                    '${widget.habit.iconURL}',
                                    width: 44)),
                          ),
                          SizedBox(
                            height: 10.5,
                          ),
                          Container(
                            alignment: Alignment.center,
//                          padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Text(
                              "${widget.habit.name}을(를) 삭제하시겠습니까?",
                              style: TextStyle(
                                  fontSize: 14.0, color: kPurpleColor),
                            ),
                          ),
                          SizedBox(height: 8.5),
                        ],
                      ),
                    ),
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: kPurpleColor),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(buildContext);
                              },
                              child: Container(
                                child: Center(
                                  child: Text(
                                    "취소",
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        color: kIvoryColor),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 14,
                            width: 4,
                            child: VerticalDivider(
                              width: 4,
                              color: kIvoryColor,
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                context.read<HabitProvider>().deleteHabit(
                                    widget.habit.addedTimeID,
                                    widget.habit.goalIsWeek);
                                Navigator.pop(buildContext);
                                Navigator.pop(context, true);
                              },
                              child: Center(
                                child: Text(
                                  "삭제",
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: kSelectedColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          );
        });
  }
}
