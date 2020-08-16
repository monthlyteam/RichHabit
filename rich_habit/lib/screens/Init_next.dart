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

class InitNext extends StatefulWidget{

  final List<List<dynamic>> selectedItem;

  InitNext({@required this.selectedItem});

  @override
  State createState() => _InitNextState();
}

class _InitNextState extends State<InitNext> {

  List<List<dynamic>> _selectedItem;

  PageController pageController;
  List<TextEditingController> controllers = new List<TextEditingController>(3);
  bool goalIsWeek = false;
  bool usualIsWeek = false;
  List<Map> habitList;

  @override
  void initState() {
    super.initState();
    this._selectedItem = widget.selectedItem;
    habitList = new List<Map>(_selectedItem.length);
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
            itemBuilder: (context,position){
              return _buildPage(context,position);
            },itemCount: _selectedItem.length,
            controller: pageController,
          ),
        ],
      ),
    );
  }


  Stack _buildPage(BuildContext context,int index){
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20,top: 50,bottom: 10),
              child: GestureDetector(
                  child:Container(
                    width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: kIvoryColor
                      ),
                      child: Center(child: Icon(Icons.arrow_back_ios, color: kPurpleColor,size: 20))), onTap: (){
                    if(index==0){
                      Navigator.of(context).pop();
                    }else{
                      pageController.animateToPage(index-1, duration: Duration(milliseconds: 400), curve: Curves.easeInOut);
                      controllers[0]..text = habitList[index-1]['usualAmount'].toString();
                      controllers[1]..text = habitList[index-1]['price'].toString();
                      controllers[2]..text = habitList[index-1]['goalAmount'].toString();
                    }
                }
              ),
            ),
            Center(
              child: Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: kWhiteIvoryColor
                ),
                child: Center(
                  child: SvgPicture.asset(_selectedItem[index][1]),
                ),
              ),
            ),
            SizedBox(height: 10,),
            Center(
              child: Text(_selectedItem[index][0],style: TextStyle(fontSize: 25,color: kPurpleColor,fontWeight: FontWeight.bold),),
            ),
            SizedBox(height: 9.5,),
            Center(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(1)),
                    color: kPurpleColor
                ),
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
                  borderRadius: BorderRadius.vertical(top:Radius.circular(25)),
                  color: kWhiteIvoryColor
                ),
                padding: EdgeInsets.fromLTRB(20, 20, 20, 100),
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("①  평소 얼마나 자주 소비하십니까?",style: TextStyle(color: kPurpleColor,fontSize: 16),),
                        SizedBox(height: 5.5,),
                        Container(
                          margin: EdgeInsets.only(left: 8),
                          padding: EdgeInsets.only(left: 20,top: 5,bottom: 15),
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(width: 1,color: kPurpleColor),
                            )
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                    child: Row(
                                      children:[
                                        usualIsWeek?
                                        Icon(Icons.radio_button_unchecked,color: kPurpleColor,size: 16,)
                                        :Icon(Icons.radio_button_checked,color: kPurpleColor,size: 16,),
                                        SizedBox(width:5.5),
                                        Text("매일", style: TextStyle(color: kPurpleColor,fontSize: 16,fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    onTap: (){
                                      setState(() {
                                        usualIsWeek = false;
                                      });
                                    },
                                  ),
                                  SizedBox(width: 20.5,),
                                  GestureDetector(
                                    child: Row(
                                      children:[
                                        usualIsWeek?
                                        Icon(Icons.radio_button_checked,color: kPurpleColor,size: 16,)
                                            :Icon(Icons.radio_button_unchecked,color: kPurpleColor,size: 16,),
                                        SizedBox(width:5.5),
                                        Text("매주", style: TextStyle(color: kPurpleColor,fontSize: 16,fontWeight: FontWeight.normal)),
                                      ],
                                    ),
                                    onTap: (){
                                      setState(() {
                                        usualIsWeek = true;
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

                                      controller: controllers[0],
                                      padding: EdgeInsets.symmetric(vertical: 2,horizontal: 2),
                                      textAlign: TextAlign.end,
                                      keyboardType: TextInputType.numberWithOptions(signed: false, decimal: false),
                                    ),
                                  ),
                                  SizedBox(width: 5.5,),
                                  Text("회",style: TextStyle(color: kPurpleColor),)
                                ],
                              ),
                              SizedBox(
                                height: 19.5,
                              ),
                              Text("흡연 1회당 얼마를 쓰십니까?",style: TextStyle(color: kPurpleColor,fontSize: 12),),
                              SizedBox(height: 2.5,),
                              Row(
                                children: [
                                  Container(
                                    width: 152,
                                    height: 23,
                                    child: CupertinoTextField(
                                      controller: controllers[1],
                                      padding: EdgeInsets.symmetric(vertical: 2,horizontal: 2),
                                      textAlign: TextAlign.end,
                                      keyboardType: TextInputType.numberWithOptions(signed: false, decimal: false),
                                    ),
                                  ),
                                  SizedBox(width: 5.5,),
                                  Text("원",style: TextStyle(color: kPurpleColor),)
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
                        Text("② 앞으로의 목표치를 정해주세요!",style: TextStyle(color: kPurpleColor,fontSize: 16),),
                        SizedBox(height: 5.5,),
                        Container(
                          margin: EdgeInsets.only(left: 8),
                          padding: EdgeInsets.only(left: 20,top: 5,bottom: 5),
                          decoration: BoxDecoration(
                              border: Border(
                                left: BorderSide(width: 1,color: kPurpleColor),
                              )
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                    child: Row(
                                      children:[
                                        goalIsWeek?
                                        Icon(Icons.radio_button_unchecked,color: kPurpleColor,size: 16,)
                                            :Icon(Icons.radio_button_checked,color: kPurpleColor,size: 16,),
                                        SizedBox(width:5.5),
                                        Text("매일", style: TextStyle(color: kPurpleColor,fontSize: 16,fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    onTap: (){
                                      setState(() {
                                        goalIsWeek = false;
                                      });
                                    },
                                  ),
                                  SizedBox(width: 20.5,),
                                  GestureDetector(
                                    child: Row(
                                      children:[
                                        goalIsWeek?
                                        Icon(Icons.radio_button_checked,color: kPurpleColor,size: 16,)
                                            :Icon(Icons.radio_button_unchecked,color: kPurpleColor,size: 16,),
                                        SizedBox(width:5.5),
                                        Text("매주", style: TextStyle(color: kPurpleColor,fontSize: 16,fontWeight: FontWeight.normal)),
                                      ],
                                    ),
                                    onTap: (){
                                      setState(() {
                                        goalIsWeek = true;
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
                                      padding: EdgeInsets.symmetric(vertical: 2,horizontal: 2),
                                      textAlign: TextAlign.end,
                                      keyboardType: TextInputType.numberWithOptions(signed: false, decimal: false),
                                    ),
                                  ),
                                  SizedBox(width: 5.5,),
                                  Text("회",style: TextStyle(color: kPurpleColor),)
                                ],
                              ),
                              SizedBox(height: 50),
                              Center(
                                  child:
                                  Column(
                                    children: [
                                      Text("\"평소 습관 보다 매일 15,000원을",style: TextStyle(fontSize: 16, color: kPurpleColor,fontWeight: FontWeight.w100 ),),
                                      Text("절약하는 목표입니다.\"",style: TextStyle(fontSize: 16, color: kPurpleColor,fontWeight: FontWeight.w100 ),)
                                    ],
                                  )
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        (index == _selectedItem.length-1)?
          BottomPositionedBox("완료", (){
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
            }else{
              habitList[index] = ({"name": _selectedItem[index][0], "iconURL": _selectedItem[index][1], "price": int.parse(controllers[1].text),"usualIsWeek": usualIsWeek, "usualAmount": int.parse(controllers[0].text), "goalIsWeek": goalIsWeek, "goalAmount": int.parse(controllers[2].text),"isTrigger":false});
              for(var i = 0; i<habitList.length ; i++){
                context.watch<HabitProvider>().addHabit(Habit(addedTimeID: DateTime.now(),isTrigger: habitList[index]['isTrigger'],
                    name: habitList[index]['name'],
                    iconURL: habitList[index]['iconURL'],
                    price: habitList[index]['price'],
                    usualAmount: habitList[index]['usualAmount'],
                    usualIsWeek: habitList[index]['usualWeek'],
                    goalIsWeek: habitList[index]['goalIsWeek'],
                    goalAmount: habitList[index]['goalAmount']
                )
                );
              }
              Navigator.push(context, MaterialPageRoute(builder: (context) => Trigger()));
            }
            print(habitList);
          })
          :BottomPositionedBox("다음",(){
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
            }else{
              habitList[index] = ({"name": _selectedItem[index][0], "iconURL": _selectedItem[index][1], "price": int.parse(controllers[1].text),"usualIsWeek": usualIsWeek, "usualAmount": int.parse(controllers[0].text), "goalIsWeek": goalIsWeek, "goalAmount": int.parse(controllers[2].text),"isTrigger":false});
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
            }
        })
      ],
    );
  }
}

//https://github.com/flutter/flutter/issues/18846
//https://medium.com/flutterpub/flutter-keyboard-actions-and-next-focus-field-3260dc4c694
// Todo
// 오토포커싱
// 3개 다 입력하면 절약비용 나오기


/////////////////////////////////////////
//habitList : List<map{"name": String, "iconURL": String, "price": int,"usualIsWeek":bool, "usualAmount": int, "goalIsWeek": bool,
// "goalAmount": int,"isTrigger":bool}>
//BottomPositionedBox("완료",(){
//  이부분에서 provider에 habitList[index] + DateTime.now 해서 Habit객체 만들어 넘겨줘야함.
//})