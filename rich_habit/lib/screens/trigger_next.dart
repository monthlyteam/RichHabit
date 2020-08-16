import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:richhabit/constants.dart';
import 'package:richhabit/habit.dart';
import 'package:richhabit/habit_provider.dart';
import 'package:richhabit/main_page.dart';
import 'package:richhabit/widget/bottom_positioned_box.dart';
import 'package:provider/provider.dart';

class TriggerNext extends StatefulWidget{

  final List<List<dynamic>> selectedItem;

  TriggerNext({@required this.selectedItem});

  @override
  State createState() => _TriggerNextState();
}

class _TriggerNextState extends State<TriggerNext> {

  List<List<dynamic>> _selectedItem;

  PageController pageController;
  List<Map> triggerList;

  @override
  void initState() {
    super.initState();
    this._selectedItem = widget.selectedItem;
    triggerList = new List<Map>(_selectedItem.length);
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

    DateTime _dateTime = DateTime.now();

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
                    child: Center(
                      child: Icon(Icons.arrow_back_ios, color: kPurpleColor,size: 20)
                    )
                  ),
                  onTap: (){
                    if(index==0){
                      Navigator.of(context).pop();
                    }else{
                      pageController.animateToPage(index-1, duration: Duration(milliseconds: 400), curve: Curves.easeInOut);
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
                        Text("①  하루의 마지막 ${_selectedItem[index][0]}, 몇시에 하시나요?",style: TextStyle(color: kPurpleColor,fontSize: 16),),
                        SizedBox(height: 20,),
                        Center(
                          child: SizedBox(
                            height: 150,
                            width: size.width-100,
                            child: CupertinoDatePicker(
                              initialDateTime: _dateTime,
                              mode: CupertinoDatePickerMode.time,
                              onDateTimeChanged: (dateTime){
                                setState(() {
                                  _dateTime = dateTime;
                                });
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        (index == _selectedItem.length-1)?
        BottomPositionedBox("완료", (){
          triggerList[index] = ({"name": _selectedItem[index][0], "iconURL": _selectedItem[index][1],"isTrigger":true});
          for(var i = 0; i<triggerList.length ; i++){
            context.watch<HabitProvider>().addHabit(Habit(
                addedTimeID: DateTime.now(),
                isTrigger: triggerList[i]['isTrigger'],
                name: triggerList[i]['name'],
                iconURL: triggerList[i]['iconURL'],
                price: 0,
                usualAmount: 0,
                usualIsWeek: false,
                goalIsWeek: false,
                goalAmount: 0
              )
            );
          }
          Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage()));
          print(triggerList);
        })
            :BottomPositionedBox("다음",(){
            triggerList[index] = ({"name": _selectedItem[index][0], "iconURL": _selectedItem[index][1],"isTrigger":true});
            pageController.animateToPage(index+1,duration: Duration(milliseconds: 400),curve: Curves.easeInOut);//다음페이지로 넘어가는거 만들면됨
        })
      ],
    );
  }
}

/////////////////////////////////////////
//triggerList List<Map{"name":String, "iconURL":String, "isTrigger":bool}>
//BottomPositionedBox("완료",(){
//  이부분에서 provider에 triggerList[index] + DateTime.now 해서 Habit객체 만들어 넘겨줘야함.
//})

