import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:richhabit/constants.dart';
import 'package:provider/provider.dart';
import 'package:richhabit/habit_provider.dart';

import '../habit.dart';

class HomeDetailEdit extends StatefulWidget {
  Habit habit;

  HomeDetailEdit({@required this.habit});

  @override
  _HomeDetailEditState createState() => _HomeDetailEditState();
}

class _HomeDetailEditState extends State<HomeDetailEdit> {
  TextEditingController _goalAmountCont;
  TextEditingController _priceCont;
  bool _goalIsWeek = false;

  @override
  void initState() {
    super.initState();
    _goalAmountCont =
        new TextEditingController(text: "${widget.habit.goalAmount}");
    _priceCont =
        new TextEditingController(text: "${widget.habit.price.round()}");
    _goalIsWeek = widget.habit.goalIsWeek;
  }

  @override
  Widget build(BuildContext context) {
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
                    Navigator.pop(context);
                  },
                  child: Text(
                    "취소",
                    style: TextStyle(color: kWhiteIvoryColor, fontSize: 16.0),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    print("삭제");
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
              height: 50.0,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25.0),
                  decoration: BoxDecoration(
                      color: kIvoryColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25.0),
                          topRight: Radius.circular(25.0))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "목표 주기 설정",
                        style: TextStyle(fontSize: 12.0, color: kPurpleColor),
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
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            child: Row(
                              children: [
                                _goalIsWeek
                                    ? Icon(
                                        Icons.radio_button_checked,
                                        color: kPurpleColor,
                                        size: 16,
                                      )
                                    : Icon(
                                        Icons.radio_button_unchecked,
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
                          ),
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
                                  fontSize: 16.0, color: kPurpleColor),
                              keyboardType: TextInputType.numberWithOptions(),
                            ),
                          ),
                          SizedBox(
                            width: 5.5,
                          ),
                          Text(
                            "회",
                            style:
                                TextStyle(fontSize: 16.0, color: kPurpleColor),
                          )
                        ],
                      ),
                      SizedBox(height: 18),
                      Text(
                        "1회당 평균 소비 비용 설정",
                        style: TextStyle(fontSize: 12.0, color: kPurpleColor),
                      ),
                      Row(
                        children: [
                          Container(
                            width: 152,
                            height: 23,
                            child: CupertinoTextField(
                              controller: _priceCont,
                              textInputAction: TextInputAction.next,
                              maxLines: 1,
                              padding: EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 2),
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  fontSize: 16.0, color: kPurpleColor),
                              keyboardType: TextInputType.numberWithOptions(),
                            ),
                          ),
                          SizedBox(
                            width: 5.5,
                          ),
                          Text(
                            "원",
                            style:
                                TextStyle(fontSize: 16.0, color: kPurpleColor),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.0),
                GestureDetector(
                  onTap: () {
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
                SizedBox(height: 50.0)
              ],
            ),
          ],
        ),
      ),
    );
  }
}
