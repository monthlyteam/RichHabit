import 'package:flutter/material.dart';
import 'package:richhabit/constants.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: kPurpleColor,
            titleSpacing: 0.0,
            centerTitle: false,
            elevation: 0.0,
            title: Padding(
              padding: const EdgeInsets.only(left: kPadding),
              child: Text(
                "7월 20일 월요일",
                style: TextStyle(
                    fontSize: kTitleFontSize,
                    color: kWhiteIvoryColor,
                    fontWeight: FontWeight.bold),
              ),
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: GestureDetector(
                  onTap: () {
                    print("오늘");
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: kDarkPurpleColor,
                        borderRadius: BorderRadius.all(Radius.circular(40.0))),
                    child: Text(
                      "오늘",
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  print("plus");
                },
                iconSize: 25.0,
                icon: Icon(
                  Icons.add_circle,
                  color: kWhiteIvoryColor,
                ),
              ),
              IconButton(
                onPressed: () {
                  print("cal");
                },
                iconSize: 25.0,
                icon: Icon(
                  Icons.calendar_today,
                  color: kWhiteIvoryColor,
                ),
              )
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: EdgeInsets.all(kPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "오늘",
                      style: TextStyle(
                          fontSize: 20.0,
                          color: kWhiteIvoryColor,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: kPadding,
                    ),
                    Text(
                      "19주차",
                      style: TextStyle(
                          fontSize: 20.0,
                          color: kWhiteIvoryColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )
            ]),
          )
        ],
      ),
    );
  }
}
