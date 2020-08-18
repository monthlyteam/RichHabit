import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:richhabit/constants.dart';
import 'package:richhabit/habit.dart';
import 'package:richhabit/habit_provider.dart';
import 'package:richhabit/screens/trigger.dart';
import 'package:richhabit/widget/bottom_positioned_box.dart';
import 'package:provider/provider.dart';
import 'dart:math';


class InitNext extends StatefulWidget{

  final List<List<dynamic>> selectedItem; //<String name, String URL>

  InitNext({@required this.selectedItem});

  @override
  State createState() => _InitNextState();
}

class _InitNextState extends State<InitNext> {

  List<List<dynamic>> _selectedItem; //List<String,String>

  PageController pageController;
  List<TextEditingController> controllers = new List<TextEditingController>(3);
  bool goalIsWeek = false;
  bool usualIsWeek = false;
  List<Map> habitList;
  List<int> saveAmount;
  @override
  void initState() {
    super.initState();
    this._selectedItem = widget.selectedItem;
    habitList = new List<Map>(_selectedItem.length);

    saveAmount = List<int>.generate(habitList.length, (index) => 0);
    controllers = List<TextEditingController>.generate(3, (index) => TextEditingController());
    pageController = new PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kIvoryColor,
      body: Stack(
        children: [
          PageView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, position) {
              return _buildPage(context, position);
            },
            itemCount: _selectedItem.length,
            controller: pageController,
          ),
        ],
      ),
    );
  }

  Stack _buildPage(BuildContext context, int index) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20, top: 50, bottom: 10),
              child: GestureDetector(
                  child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: kIvoryColor),
                      child: Center(
                          child: Icon(Icons.arrow_back_ios,
                              color: kPurpleColor, size: 20))),
                  onTap: () {
                    if (index == 0) {
                      Navigator.of(context).pop();
                    } else {
                      pageController.animateToPage(index - 1,
                          duration: Duration(milliseconds: 400),
                          curve: Curves.easeInOut);
                      controllers[0]
                        ..text = habitList[index - 1]['usualAmount'].toString();
                      controllers[1]
                        ..text = habitList[index - 1]['price'].toString();
                      controllers[2]
                        ..text = habitList[index - 1]['goalAmount'].toString();
                    }
                  }),
            ),
            Center(
              child: Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: kWhiteIvoryColor),
                child: Center(
                  child: SvgPicture.asset(_selectedItem[index][1]),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Text(
                _selectedItem[index][0],
                style: TextStyle(
                    fontSize: 25,
                    color: kPurpleColor,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 9.5,
            ),
            Center(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(1)),
                    color: kPurpleColor),
                height: 3,
                width: 33,
              ),
            ),
            SizedBox(
              height: 13.5,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(25)),
                    color: kWhiteIvoryColor),
                padding: EdgeInsets.fromLTRB(20, 20, 20, 100),
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "①  평소 얼마나 자주 소비하십니까?",
                          style: TextStyle(color: kPurpleColor, fontSize: 16),
                        ),
                        SizedBox(
                          height: 5.5,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 8),
                          padding:
                              EdgeInsets.only(left: 20, top: 5, bottom: 15),
                          decoration: BoxDecoration(
                              border: Border(
                            left: BorderSide(width: 1, color: kPurpleColor),
                          )),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                    child: Row(
                                      children: [
                                        usualIsWeek
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
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    onTap: () {
                                      setState(() {
                                        usualIsWeek = false;
                                        _onInputChanged(index);
                                      });
                                    },
                                  ),
                                  SizedBox(
                                    width: 20.5,
                                  ),
                                  GestureDetector(
                                    child: Row(
                                      children: [
                                        usualIsWeek
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
                                                fontWeight: FontWeight.normal)),
                                      ],
                                    ),
                                    onTap: () {
                                      setState(() {
                                        usualIsWeek = true;
                                        goalIsWeek = true;
                                        _onInputChanged(index);
                                      });
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  Container(
                                    width: 152,
                                    height: 23,
                                    child: CupertinoTextField(
                                      onChanged: (text){
                                        setState(() {
                                          _onInputChanged(index);
                                          },
                                        );
                                      },
                                      controller: controllers[0],
                                      padding: EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 2),
                                      textAlign: TextAlign.end,
                                      maxLines: 1,
                                      placeholder: "1이상",
                                      keyboardType: TextInputType.numberWithOptions(),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5.5,
                                  ),
                                  Text(
                                    "회",
                                    style: TextStyle(color: kPurpleColor),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 19.5,
                              ),
                              Text("${_selectedItem[index][0]} 1회당 얼마를 쓰십니까?",style: TextStyle(color: kPurpleColor,fontSize: 12),),
                              SizedBox(height: 2.5,),
                              Row(
                                children: [
                                  Container(
                                    width: 152,
                                    height: 23,
                                    child: CupertinoTextField(
                                      controller: controllers[1],
                                      onChanged: (text){
                                        setState(() {
                                          _onInputChanged(index);
                                        },
                                        );
                                      },
                                      maxLines: 1,
                                      placeholder: "1이상",
                                      padding: EdgeInsets.symmetric(vertical: 2,horizontal: 2),
                                      textAlign: TextAlign.end,
                                      keyboardType:
                                          TextInputType.numberWithOptions(),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5.5,
                                  ),
                                  Text(
                                    "원",
                                    style: TextStyle(color: kPurpleColor),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "② 앞으로의 목표치를 정해주세요!",
                          style: TextStyle(color: kPurpleColor, fontSize: 16),
                        ),
                        SizedBox(
                          height: 5.5,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 8),
                          padding: EdgeInsets.only(left: 20, top: 5, bottom: 5),
                          decoration: BoxDecoration(
                              border: Border(
                            left: BorderSide(width: 1, color: kPurpleColor),
                          )),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                    child: Row(
                                      children:[
                                        usualIsWeek?
                                          Icon(Icons.radio_button_unchecked,color: Colors.grey,size: 16,)
                                         :goalIsWeek?
                                            Icon(Icons.radio_button_unchecked,color: kPurpleColor,size: 16,)
                                           :Icon(Icons.radio_button_checked,color: kPurpleColor,size: 16,)
                                        ,
                                        SizedBox(width:5.5),
                                        Text("매일", style: TextStyle(
                                            color: usualIsWeek?Colors.grey:kPurpleColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold
                                          )
                                        ),
                                      ],
                                    ),
                                    onTap: (){
                                      if(!usualIsWeek)
                                      setState(() {
                                        goalIsWeek = false;
                                        _onInputChanged(index);
                                      });
                                    },
                                  ),
                                  SizedBox(
                                    width: 20.5,
                                  ),
                                  GestureDetector(
                                    child: Row(
                                      children: [
                                        goalIsWeek
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
                                                fontWeight: FontWeight.normal)),
                                      ],
                                    ),
                                    onTap: () {
                                      setState(() {
                                        goalIsWeek = true;
                                        _onInputChanged(index);
                                      });
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  Container(
                                    width: 152,
                                    height: 23,
                                    child: CupertinoTextField(
                                      controller: controllers[2],
                                      onChanged: (text){
                                        setState(() {
                                          _onInputChanged(index);
                                        },
                                        );
                                      },
                                      maxLines: 1,
                                      placeholder: "0이상",
                                      padding: EdgeInsets.symmetric(vertical: 2,horizontal: 2),
                                      textAlign: TextAlign.end,
                                      keyboardType:
                                          TextInputType.numberWithOptions(),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5.5,
                                  ),
                                  Text(
                                    "회",
                                    style: TextStyle(color: kPurpleColor),
                                  )
                                ],
                              ),
                              SizedBox(height: 50),
                              Center(
                                child:
                                Column(
                                  children: [
                                    Text("\"평소 습관 보다 매일 ${saveAmount[index]}원을",style: TextStyle(fontSize: 16, color: kPurpleColor,fontWeight: FontWeight.w100 ),),
                                    Text("절약하는 목표입니다.\"",style: TextStyle(fontSize: 16, color: kPurpleColor,fontWeight: FontWeight.w100 ),)
                                  ],
                                )
                              )
                            ]
                          )
                        )
                      ]
                    )
                  ]
                )
              )
            )
          ]
        ),
        (index == _selectedItem.length-1)?
        BottomPositionedBox("완료", (){
          try{//try-catch로 숫자가 아닌것이 입력되는걸 잡음
            if(controllers[0].text.trim().isEmpty||controllers[1].text.trim().isEmpty||controllers[2].text.trim().isEmpty){//값이 비어있는경우
              Fluttertoast.showToast(
                  msg: "정보를 빠짐없이 입력해주세요!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.grey,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
            }else if(int.parse(controllers[0].text)>0&&double.parse(controllers[1].text)>0&&int.parse(controllers[2].text)>=0){ //값이 최솟값 이상인경우
              if (int.parse(controllers[2].text)*pow(7,boolToInt(!goalIsWeek))<int.parse(controllers[0].text)*pow(7,boolToInt(!usualIsWeek))) {//목표량이 현재보다 낮은경우
                habitList[index] = ({
                  "name": _selectedItem[index][0],
                  "iconURL": _selectedItem[index][1],
                  "price": double.parse(controllers[1].text),
                  "usualIsWeek": usualIsWeek,
                  "usualAmount": int.parse(controllers[0].text),
                  "goalIsWeek": goalIsWeek,
                  "goalAmount": int.parse(controllers[2].text),
                  "isTrigger": false
                });
                for (var i = 0; i < habitList.length; i++) {

                  context.read<HabitProvider>().addHabit(
                      Habit(
                          addedTimeID: DateTime.now(),
                          isTrigger: habitList[i]['isTrigger'],
                          name: habitList[i]['name'],
                          iconURL: habitList[i]['iconURL'],
                          price: habitList[i]['price'],
                          usualAmount: habitList[i]['usualAmount'],
                          usualIsWeek: habitList[i]['usualWeek'],
                          goalIsWeek: habitList[i]['goalIsWeek'],

                          goalAmount: habitList[i]['goalAmount']
                      )
                  );
                }
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Trigger()));
              }else{//목표량이 현재보다 높은경우
                Fluttertoast.showToast(
                    msg: "목표치를 확인해주세요",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.grey,
                    textColor: Colors.white,

                    fontSize: 16.0
                );
              }
            }else {//값이 최소값 미만인경우
              Fluttertoast.showToast(
                  msg: "올바른 값을 입력해주세요!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.grey,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
            }
          }catch(e){
            print(e);
            Fluttertoast.showToast(
                msg: "올바른 값을 입력해주세요!\n숫자만 입력할 수 있습니다.",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.grey,
                textColor: Colors.white,
                fontSize: 16.0
            );
          }
        })

            :BottomPositionedBox("다음",(){
          try{
            if(controllers[0].text.trim().isEmpty||controllers[1].text.trim().isEmpty||controllers[2].text.trim().isEmpty){
              Fluttertoast.showToast(
                  msg: "정보를 빠짐없이 입력해주세요!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.grey,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
            }else if(int.parse(controllers[0].text)>0&&double.parse(controllers[1].text)>0&&int.parse(controllers[2].text)>=0){//목표량이 현재보다 낮은경우
              if (int.parse(controllers[2].text)*pow(7,boolToInt(!goalIsWeek))<int.parse(controllers[0].text)*pow(7,boolToInt(!usualIsWeek))) {
                habitList[index] = ({"name": _selectedItem[index][0], "iconURL": _selectedItem[index][1], "price": double.parse(controllers[1].text),"usualIsWeek": usualIsWeek, "usualAmount": int.parse(controllers[0].text), "goalIsWeek": goalIsWeek, "goalAmount": int.parse(controllers[2].text),"isTrigger":false});
                goalIsWeek = false;
                usualIsWeek = false;
                pageController.animateToPage(index+1,duration: Duration(milliseconds: 400),curve: Curves.easeInOut);//다음페이지로 넘어가는거 만들면됨
                if(habitList[index+1] != null){
                  controllers[0]..text = habitList[index+1]['usualAmount'].toString();
                  controllers[1]..text = habitList[index+1]['price'].toString();
                  controllers[2]..text = habitList[index+1]['goalAmount'].toString();
                }else{
                  controllers[0].clear();
                  controllers[1].clear();
                  controllers[2].clear();
                }

              }else{
                Fluttertoast.showToast(
                    msg: "목표치를 확인해주세요",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.grey,
                    textColor: Colors.white,
                    fontSize: 16.0
                );
              }
            }else{
              Fluttertoast.showToast(
                  msg: "올바른 값을 입력해주세요!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.grey,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
            }
          }catch(e){
            Fluttertoast.showToast(
                msg: "올바른 값을 입력해주세요.\n숫자만 입력할 수 있습니다.",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.grey,
                textColor: Colors.white,
                fontSize: 16.0
            );
          }
        })
      ]
    );


  }
  _onInputChanged(int index){
    try{
      if(controllers[0].text.trim().isNotEmpty&&controllers[1].text.trim().isNotEmpty&controllers[2].text.trim().isNotEmpty){
        if(int.parse(controllers[0].text)>0&&double.parse(controllers[1].text)>0&&int.parse(controllers[2].text)>=0){
          double aDayCost;
          double aDayCost_goal;
          if (int.parse(controllers[2].text)*pow(7,boolToInt(!goalIsWeek))<int.parse(controllers[0].text)*pow(7,boolToInt(!usualIsWeek))) {
            if(usualIsWeek){
              aDayCost=int.parse(controllers[0].text)*double.parse(controllers[1].text)/7;
            }else{
              aDayCost=int.parse(controllers[0].text)*double.parse(controllers[1].text);
            }
            if(goalIsWeek){
              aDayCost_goal=int.parse(controllers[2].text)*double.parse(controllers[1].text)/7;
            }else{
              aDayCost_goal=int.parse(controllers[2].text)*double.parse(controllers[1].text);
            }
            print("day : $aDayCost\ngoal : $aDayCost_goal");
          }
          saveAmount[index] = (aDayCost-aDayCost_goal).floor().toInt();
        }
      }
    }catch(e){}
  }
  int boolToInt(bool flag){
    if(flag) return 1;
    else return 0;
  }
}

//https://github.com/flutter/flutter/issues/18846
//https://medium.com/flutterpub/flutter-keyboard-actions-and-next-focus-field-3260dc4c694
// Todo
// 오토포커싱
// 입력값 체크하는거 함수화

//건의사항
//usual 매주여도 goal 매일 할수있도록
// 절약금 매일 말고 매달로 표시
