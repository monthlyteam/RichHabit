import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:richhabit/constants.dart';
import 'package:richhabit/habit.dart';
import 'package:richhabit/habit_provider.dart';
import 'package:richhabit/screens/home.dart';
import 'package:richhabit/screens/trigger.dart';
import 'package:richhabit/widget/bottom_positioned_box.dart';
import 'package:provider/provider.dart';
import 'dart:math';


class InitNext extends StatefulWidget{

  final List<List<dynamic>> selectedItem; //<String name, String URL>
  final bool isFirst;
  InitNext({@required this.selectedItem,@required this.isFirst});

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
  List<FocusNode> nodes;
  bool whereFocus=false; //false:1번 true: 2번
  Color firstBlockColor = kPurpleColor;
  Color secondBlockColor = Colors.grey;
  @override
  void initState() {
    super.initState();
    this._selectedItem = widget.selectedItem;
    habitList = new List<Map>(_selectedItem.length);

    saveAmount = List<int>.generate(_selectedItem.length, (index) => 0);
    controllers = List<TextEditingController>.generate(3, (index) => TextEditingController());
    nodes = List<FocusNode>.generate(3, (index) => FocusNode());
    pageController = new PageController();
  }

  @override
  Widget build(BuildContext context) {
    nodes[0].addListener((){setState(() {
      firstBlockColor = kPurpleColor;
      secondBlockColor = Colors.grey;
//      if(!nodes[0].hasFocus){
//        if(controllers[0].text.isNotEmpty&&controllers[1].text.isNotEmpty){
//          FocusScope.of(context).requestFocus(nodes[2]);
//        }
//      }
    });});
    nodes[1].addListener((){setState(() {
      firstBlockColor = kPurpleColor;
      secondBlockColor = Colors.grey;
//      if(!nodes[1].hasFocus){
//        if(controllers[0].text.isNotEmpty&&controllers[1].text.isNotEmpty){
//          FocusScope.of(context).requestFocus(nodes[2]);
//        }
//      }
    });});
    nodes[2].addListener((){setState(() {
      firstBlockColor = Colors.grey;
      secondBlockColor = kPurpleColor;
    });});
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
              child: GestureDetector(behavior: HitTestBehavior.translucent,
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
                          style: TextStyle(color: firstBlockColor, fontSize: 16),
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
                            left: BorderSide(width: 1, color: firstBlockColor),
                          )),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  GestureDetector(behavior: HitTestBehavior.translucent,
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
                                                color: firstBlockColor,
                                                size: 16,
                                              ),
                                        SizedBox(width: 5.5),
                                        Text("매일",
                                            style: TextStyle(
                                                color: firstBlockColor,
                                                fontSize: 16,
                                                fontWeight: usualIsWeek?FontWeight.normal:FontWeight.bold)),
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
                                  GestureDetector(behavior: HitTestBehavior.translucent,
                                    child: Row(
                                      children: [
                                        usualIsWeek
                                            ? Icon(
                                                Icons.radio_button_checked,
                                                color: firstBlockColor,
                                                size: 16,
                                              )
                                            : Icon(
                                                Icons.radio_button_unchecked,
                                                color: firstBlockColor,
                                                size: 16,
                                              ),
                                        SizedBox(width: 5.5),
                                        Text("매주",
                                            style: TextStyle(
                                                color: firstBlockColor,
                                                fontSize: 16,
                                                fontWeight: usualIsWeek?FontWeight.bold:FontWeight.normal)),
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
                                      maxLength: 2,
                                      onChanged: (text){
                                        setState(() {
                                          _onInputChanged(index);
                                          },
                                        );
                                      },
                                      onEditingComplete: (){
                                        nodes[0].unfocus();
                                        FocusScope.of(context).requestFocus(nodes[1]);
                                      },
                                      textInputAction: TextInputAction.next,
                                      controller: controllers[0],
                                      padding: EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 2),
                                      textAlign: TextAlign.end,
                                      maxLines: 1,
                                      keyboardType: TextInputType.numberWithOptions(),
                                      focusNode: nodes[0],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5.5,
                                  ),
                                  Text(
                                    "회",
                                    style: TextStyle(color: firstBlockColor),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 19.5,
                              ),
                              Text("${_selectedItem[index][0]} 1회당 얼마를 쓰십니까?",style: TextStyle(color: firstBlockColor,fontSize: 12),),
                              SizedBox(height: 2.5,),
                              Row(
                                children: [
                                  Container(
                                    width: 152,
                                    height: 23,
                                    child: CupertinoTextField(
                                      maxLength: 8,
                                      focusNode: nodes[1],
                                      controller: controllers[1],
                                      onChanged: (text){
                                        setState(() {
                                          _onInputChanged(index);
                                        },
                                        );
                                      },onEditingComplete: (){
                                      nodes[1].unfocus();
                                      FocusScope.of(context).requestFocus(nodes[2]);}
                                      ,
                                      textInputAction: TextInputAction.next,
                                      maxLines: 1,
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
                                    style: TextStyle(color: firstBlockColor),
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
                          style: TextStyle(color: secondBlockColor, fontSize: 16),
                        ),
                        SizedBox(
                          height: 5.5,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 8),
                          padding: EdgeInsets.only(left: 20, top: 5, bottom: 5),
                          decoration: BoxDecoration(
                              border: Border(
                            left: BorderSide(width: 1, color: secondBlockColor),
                          )),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  GestureDetector(behavior: HitTestBehavior.translucent,
                                    child: Row(
                                      children:[
                                        usualIsWeek?
                                          Icon(Icons.radio_button_unchecked,color: Colors.grey,size: 16,)
                                         :goalIsWeek?
                                            Icon(Icons.radio_button_unchecked,color: secondBlockColor,size: 16,)
                                           :Icon(Icons.radio_button_checked,color: secondBlockColor,size: 16,)
                                        ,
                                        SizedBox(width:5.5),
                                        Text("매일", style: TextStyle(
                                            color: usualIsWeek?Colors.grey:secondBlockColor,
                                            fontSize: 16,
                                            fontWeight: goalIsWeek?FontWeight.normal:FontWeight.bold
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
                                  GestureDetector(behavior: HitTestBehavior.translucent,
                                    child: Row(
                                      children: [
                                        goalIsWeek
                                            ? Icon(
                                                Icons.radio_button_checked,
                                                color: secondBlockColor,
                                                size: 16,
                                              )
                                            : Icon(
                                                Icons.radio_button_unchecked,
                                                color: secondBlockColor,
                                                size: 16,
                                              ),
                                        SizedBox(width: 5.5),
                                        Text("매주",
                                            style: TextStyle(
                                                color: secondBlockColor,
                                                fontSize: 16,
                                                fontWeight : goalIsWeek?FontWeight.bold:FontWeight.normal)),
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
                                      maxLength: 2,
                                      focusNode: nodes[2],
                                      controller: controllers[2],
                                      onChanged: (text){
                                        setState(() {
                                          _onInputChanged(index);
                                        },
                                        );
                                      },
                                      maxLines: 1,
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
                                    style: TextStyle(color: secondBlockColor),
                                  )
                                ],
                              ),
                              SizedBox(height: 50),
                              Center(
                                child:
                                Column(
                                  children: [
                                    Text("\"평소 습관 보다 매달 ${saveAmount[index]}원을",style: TextStyle(fontSize: 16, color: kPurpleColor,fontWeight: FontWeight.w100 ),),
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
                          usualIsWeek: habitList[i]['usualIsWeek'],
                          goalIsWeek: habitList[i]['goalIsWeek'],

                          goalAmount: habitList[i]['goalAmount']
                      )
                  );
                }
                print("Weekly :${context.read<HabitProvider>().weeklyHabit}");
                print("Daily : ${context.read<HabitProvider>().dailyHabit}");
                if(widget.isFirst){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Trigger()));
                }else{
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
                }
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
                nodes[0].requestFocus();
                pageController.animateToPage(index+1,duration: Duration(milliseconds: 400),curve: Curves.easeInOut);
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
    index=pageController.page.toInt();
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
          }
          saveAmount[index] = (aDayCost-aDayCost_goal).floor().toInt()*30;
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
