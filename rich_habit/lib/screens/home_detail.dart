import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:richhabit/constants.dart';
import 'package:provider/provider.dart';

import '../habit.dart';

class HomeDetail extends StatelessWidget {
  Habit habit;

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
                InkWell(
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
                  Text(
                    "\"평균 목표 달성률 96%! 좀 더 절약해 보는게 어떤가요?\"",
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
                    child: Row(
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
                    height: 50.0,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
