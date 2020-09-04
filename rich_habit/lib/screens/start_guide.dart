import 'dart:io';

import 'package:flutter/material.dart';
import 'package:richhabit/constants.dart';
import 'package:richhabit/screens/init.dart';

class StartGuide extends StatefulWidget {
  @override
  _StartGuideState createState() => _StartGuideState();
}

class _StartGuideState extends State<StartGuide> {
  int currentPage = 0;
  List<Map<String, String>> splashData = [
    {
      "text": "리치해빗에 오신 걸 환영합니다!\n소비 습관을 기록하며 부자 되는 습관을 만들어봐요!",
      "image": "assets/guide/guide1.png"
    },
    {
      "text": "내가 절약한 현황을 통계로 볼 수 있어요.\n아낀 돈을 투자하면? 복리의 가치도 함께!",
      "image": "assets/guide/guide2.png"
    },
    {
      "text": "습관적 소비 외의 소비가 고민될 땐?\n입력한 소비의 가치를 복리로 계산해 줘요!",
      "image": "assets/guide/guide3.png"
    },
    {
      "text": "투자 방법도 알아봐요.\n복리의 힘을 직접! 내 걸로!",
      "image": "assets/guide/guide4.png"
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteIvoryColor,
      body: WillPopScope(
        onWillPop: (){
          exit(0);
        },
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Container(
                    height: 0.6 * MediaQuery.of(context).size.height,
                    child: PageView.builder(
                      onPageChanged: (value) {
                        setState(() {
                          currentPage = value;
                        });
                      },
                      itemCount: splashData.length,
                      itemBuilder: (context, index) => SplashContent(
                        image: splashData[currentPage]["image"],
                        text: splashData[currentPage]['text'],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        splashData.length,
                        (index) => buildDot(index: index),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Container(
                        height: 60,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: kDarkPurpleColor.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 15,
                              offset: Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: FlatButton(
                          color: kIvoryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "리치해빗 바로 시작하기",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: kDarkPurpleColor,
                                    fontSize: 16),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.arrow_forward,
                                size: 19,
                              ),
                            ],
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Init(isFirst: true)));
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AnimatedContainer buildDot({int index}) {
    return AnimatedContainer(
      child: FlatButton(
        onPressed: () {
          setState(() {
            currentPage = index;
          });
        },
      ),
      duration: Duration(milliseconds: 200),
      margin: EdgeInsets.only(right: 5),
      height: 6,
      width: currentPage == index ? 20 : 6,
      decoration: BoxDecoration(
        color: currentPage == index ? kSelectedColor : kPurpleColor,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

class SplashContent extends StatelessWidget {
  final String text, image;

  const SplashContent({
    this.text,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 10,
        ),
        Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: kDarkPurpleColor,
            fontSize: 16,
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: kPurpleColor.withOpacity(0.3),
                spreadRadius: 5,
                blurRadius: 15,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Image.asset(
            image,
            height: 0.45 * MediaQuery.of(context).size.height,
          ),
        ),
      ],
    );
  }
}
