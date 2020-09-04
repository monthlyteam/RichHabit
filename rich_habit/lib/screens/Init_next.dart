import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
  import 'package:richhabit/constants.dart';
import 'package:richhabit/habit.dart';
import 'package:richhabit/habit_provider.dart';
import 'package:richhabit/main_page.dart';
import 'package:richhabit/screens/trigger.dart';
import 'package:richhabit/widget/bottom_positioned_box.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'dart:io' show Platform;
import 'package:scroll_to_index/scroll_to_index.dart';


class InitNext extends StatefulWidget{

  final List<List<dynamic>> selectedItem; //<String name, String URL>
  final bool isFirst;
  InitNext({@required this.selectedItem,@required this.isFirst});

  @override
  State createState() => _InitNextState();
}

class _InitNextState extends State<InitNext>{

  List<List<dynamic>> _selectedItem; //List<String,String>

  AutoScrollController _autoScrollController = new AutoScrollController();

  PageController pageController;
  List<TextEditingController> controllers = new List<TextEditingController>(3);
  bool goalIsWeek = false;
  bool usualIsWeek = false;
  List<Map> habitList;
  List<int> saveAmount;
  List<FocusNode> nodes;
  bool keyboardIsOpened;
  List<bool> _isSnackbarActive = new List<bool>.generate(4, (index) => false); //빠작올숫

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
  void dispose() {
    for(var i = 0 ; i < nodes.length;i++) nodes[i].dispose();
    for(var i = 0 ; i < controllers.length;i++) controllers[i].dispose();
    pageController.dispose();
    _autoScrollController.dispose();
    super.dispose();
  }

  Future _scrollToIndex(int index) async {
    await _autoScrollController.scrollToIndex(index,
        preferPosition: AutoScrollPosition.end);
  }

  Widget _wrapScrollTag({int index, Widget child}) {
    return AutoScrollTag(
      key: ValueKey(index),
      controller: _autoScrollController,
      index: index,
      child: child,
      highlightColor: Colors.black.withOpacity(0.1),
    );
  }

  @override
  Widget build(BuildContext context) {
    nodes[0].addListener(()async {
      if(nodes[0].hasFocus) {
        _scrollToIndex(0);
        setState(() {});
      }
    });
    nodes[1].addListener(()async {
      if(nodes[1].hasFocus) {
        _scrollToIndex(1);
        setState(() {});
      }
    });
    nodes[2].addListener(()async {
      if(nodes[2].hasFocus) {
        _scrollToIndex(2);
        setState(() {});
      }
    });

    keyboardIsOpened = MediaQuery.of(context).viewInsets.bottom != 0.0;

    return Container(
      color: Colors.red,
      height: 500,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: kIvoryColor,
        body: PageView(
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
      ),
    );
  }

  WillPopScope _buildPage(BuildContext context, int index) {
    _autoScrollController = new AutoScrollController();
    return WillPopScope(
      onWillPop: () async{
        if (index == 0) {
          Navigator.of(context).pop();
        } else {
          _autoScrollController.dispose();
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
        return true;
      },
      child: GestureDetector(
        onTap: (){FocusScope.of(context).requestFocus(new FocusNode());},
        child: Stack(
          children: [
            CustomScrollView(
              shrinkWrap: false,
              controller: _autoScrollController,
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: Container(
                    color: kIvoryColor,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 20, top: 60, bottom: 10),
                            child: Container(
                              height: 20,
                              width: 20,
                              child: GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  child: Container(
                                      child: Icon(Icons.arrow_back_ios, color: kPurpleColor, size: 25)
                                  ),
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
                            height: 20,
                          ),
                          Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.vertical(top: Radius.circular(25)),
                                  color: kWhiteIvoryColor),
                              padding: EdgeInsets.fromLTRB(20, 30, 20, 100),
                              child: Column(
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
                                                      color: kPurpleColor,
                                                      size: 16,
                                                    ),
                                                    SizedBox(width: 5.5,height: 1,),
                                                    Text("매일",
                                                        style: TextStyle(
                                                            color: kPurpleColor,
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
                                                height: 1,
                                              ),
                                              GestureDetector(behavior: HitTestBehavior.translucent,
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
                                                    SizedBox(width: 5.5,height: 1,),
                                                    Text("매주",
                                                        style: TextStyle(
                                                            color: kPurpleColor,
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
                                                child : CupertinoTextField(
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
                                                height: 1,
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
                                          Text("${_selectedItem[index][0]} 1회당 얼마를 쓰십니까?",style: TextStyle(color: kPurpleColor,fontSize: 14),),
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
                                                width: 5.5,height: 1,
                                              ),
                                              _wrapScrollTag(
                                                index: 0,
                                                child: Text(
                                                  "원",
                                                  style: TextStyle(color: kPurpleColor),
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
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
                                                        Icon(Icons.radio_button_unchecked,color: kPurpleColor,size: 16,)
                                                            :Icon(Icons.radio_button_checked,color: kPurpleColor,size: 16,)
                                                        ,
                                                        SizedBox(width:5.5,height:1),
                                                        Text("매일", style: TextStyle(
                                                            color: usualIsWeek?Colors.grey:kPurpleColor,
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
                                                      width: 20.5,height: 1
                                                  ),
                                                  GestureDetector(behavior: HitTestBehavior.translucent,
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
                                                        SizedBox(width: 5.5,height: 1,),
                                                        Text("매주",
                                                            style: TextStyle(
                                                                color: kPurpleColor,
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
                                                    width: 5.5,height: 1,
                                                  ),
                                                  _wrapScrollTag(
                                                    index:1,
                                                    child: Text(
                                                      "회",
                                                      style: TextStyle(color: kPurpleColor),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              SizedBox(height: 50),
                                            ]
                                        )
                                    ),
                                    Center(
                                        child:
                                        Column(
                                          children: [
                                            Text("\"평소 습관 보다 매달 약 ${saveAmount[index].toString().replaceAllMapped(new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}원을",style: TextStyle(fontSize: 18, color: kPurpleColor,fontWeight: FontWeight.w100 ),),
                                            Text("절약하는 목표입니다.\"",style: TextStyle(fontSize: 18, color: kPurpleColor,fontWeight: FontWeight.w100 ),),
                                            _wrapScrollTag(
                                                index: 2,
                                                child: SizedBox(height:50)),
                                            SizedBox(height: 50,),
                                          ],

                                        )
                                    ),
                                  ]
                              )
                          ),
                        ]
                    ),
                  ),
                ),
              ],
            ),
            bottomWidget(index,context)
          ],
        ),
      ),
    );
  }
  _onInputChanged(int index){
    index=pageController.page.toInt();
    try{
      if(controllers[0].text.trim().isNotEmpty&&controllers[1].text.trim().isNotEmpty&controllers[2].text.trim().isNotEmpty){
        if(int.parse(controllers[0].text)>0&&int.parse(controllers[1].text)>0&&int.parse(controllers[2].text)>=0){
          double aDayCost;
          double aDayCostGoal;
          if (int.parse(controllers[2].text)*pow(7,boolToInt(!goalIsWeek))<int.parse(controllers[0].text)*pow(7,boolToInt(!usualIsWeek))) {
            if(usualIsWeek){
              aDayCost = int.parse(controllers[0].text) * int.parse(controllers[1].text)/7;
            }else{
              aDayCost = int.parse(controllers[0].text) * int.parse(controllers[1].text) * 1.0;
            }
            if(goalIsWeek){
              aDayCostGoal=int.parse(controllers[2].text)*int.parse(controllers[1].text)/7;
            }else{
              aDayCostGoal=int.parse(controllers[2].text) * int.parse(controllers[1].text)*1.0;
            }
          }
          saveAmount[index] = (aDayCost-aDayCostGoal).floor().toInt()*30;
        }
      }
    }catch(e){}
  }

  int boolToInt(bool flag){
    if(flag) return 1;
    else return 0;
  }

  Widget bottomWidget(int index,BuildContext context){
    if(keyboardIsOpened) {
      if(Platform.isIOS) {
        int currentNode = 0;
        if (nodes[0].hasFocus)
          currentNode = 0;
        else if (nodes[1].hasFocus)
          currentNode = 1;
        else if (nodes[2].hasFocus) currentNode = 2;
        return Positioned(
          bottom: 0,
          height: 40,
          child: Container(
            alignment: Alignment.centerRight,
            width: size.width,
            height: 40,
            decoration: BoxDecoration(
                color: Color.fromRGBO(240, 240, 240, 1),
                border: Border(top: BorderSide(
                    color: Colors.grey.withOpacity(0.4), width: 1))
            ),
            padding: EdgeInsets.symmetric(vertical: 3, horizontal: 20),
            child: Row(
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    if (currentNode != 0) {
                      nodes[currentNode].unfocus();
                      FocusScope.of(context).requestFocus(nodes[currentNode - 1]);
                    }
                  },
                  child: Container(
                      height: 34,
                      child: FittedBox(
                          fit: BoxFit.fitHeight,
                          child: Icon(Icons.keyboard_arrow_up,color: (currentNode == 0) ? Colors.grey.withOpacity(0.6):Colors.blueAccent)
                      )
                  ),
                ),
                SizedBox(width: 5,),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    if (currentNode != 2) {
                      nodes[currentNode].unfocus();
                      FocusScope.of(context).requestFocus(nodes[currentNode + 1]);
                    }
                  },
                  child: Container(
                      height: 34,
                      child: FittedBox(
                        fit: BoxFit.fitHeight,
                        child: Icon(Icons.keyboard_arrow_down,color: (currentNode == 2) ? Colors.grey.withOpacity(0.6):Colors.blueAccent)
                      )
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    nodes[currentNode].unfocus();
                    if (currentNode == 0 || currentNode == 1) {
                      FocusScope.of(context).requestFocus(nodes[currentNode + 1]);
                    }
                  },
                  child: Container(
                      height: 20,
                      child: FittedBox(
                        fit: BoxFit.fitHeight,
                        child: (currentNode == 2) ? Text(
                          "완료", style: TextStyle(color: Colors.blueAccent),) : Text(
                            "다음", style: TextStyle(color: Colors.blueAccent)),
                      )
                  ),
                ),
              ],
            ),
          ),
        );
      }else return Container();
    }else{
      return (index != _selectedItem.length-1)
          ?BottomPositionedBox("다음",(){
            _autoScrollController.dispose();
        try{
          if(controllers[0].text.trim().isEmpty||controllers[1].text.trim().isEmpty||controllers[2].text.trim().isEmpty){
            if(_isSnackbarActive[0] ==false) {
              _isSnackbarActive[0] = true;
              Scaffold
                  .of(context)
                  .showSnackBar(
                    SnackBar(
                      content: Text("정보를 빠짐없이 입력해주세요!"),
                      duration: Duration(milliseconds: 1300),
                    )
                  )
                  .closed
                  .then((SnackBarClosedReason reason) {
                _isSnackbarActive[0] = false;
              });
            }
          }else if(int.parse(controllers[0].text)>0&&int.parse(controllers[1].text)>0&&int.parse(controllers[2].text)>=0){// 범위에 맞는 값을 입력헀는가?
            if (int.parse(controllers[2].text)*pow(7,boolToInt(!goalIsWeek))<int.parse(controllers[0].text)*pow(7,boolToInt(!usualIsWeek))) { //목표치가 현재보다 낮은가?
              habitList[index] = ({"name": _selectedItem[index][0], "iconURL": _selectedItem[index][1], "price": int.parse(controllers[1].text),"usualIsWeek": usualIsWeek, "usualAmount": int.parse(controllers[0].text), "goalIsWeek": goalIsWeek, "goalAmount": int.parse(controllers[2].text),"isTrigger":false});
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
              if(_isSnackbarActive[1] ==false) {
                _isSnackbarActive[1] = true;
                Scaffold
                    .of(context)
                    .showSnackBar(
                    SnackBar(
                      content: Text("목표치는 평소보다 작게 설정해주세요."),
                      duration: Duration(milliseconds: 1300),
                    )
                )
                    .closed
                    .then((SnackBarClosedReason reason) {
                  _isSnackbarActive[1] = false;
                });
              }
            }
          }else{
            if(_isSnackbarActive[2] ==false) {
              _isSnackbarActive[2] = true;
              Scaffold
                  .of(context)
                  .showSnackBar(
                  SnackBar(
                    content: Text("올바른 값을 입력해주세요!"),
                    duration: Duration(milliseconds: 1300),
                  )
              )
                  .closed
                  .then((SnackBarClosedReason reason) {
                _isSnackbarActive[2] = false;
              });
            }
          }
        }catch(e){
          print(e);
          if(_isSnackbarActive[3] ==false) {
            _isSnackbarActive[3] = true;
            Scaffold
                .of(context)
                .showSnackBar(
                SnackBar(
                  content: Text("올바른 값을 입력해주세요! 숫자만 입력할 수 있습니다."),
                  duration: Duration(milliseconds: 1300),
                )
            )
                .closed
                .then((SnackBarClosedReason reason) {
              _isSnackbarActive[3] = false;
            });
          }
        }
      })
          :BottomPositionedBox("완료",(){
        try{//try-catch로 숫자가 아닌것이 입력되는걸 잡음
          if(controllers[0].text.trim().isEmpty||controllers[1].text.trim().isEmpty||controllers[2].text.trim().isEmpty){//값이 비어있는경우
            if(_isSnackbarActive[0] ==false) {
              _isSnackbarActive[0] = true;
              Scaffold
                  .of(context)
                  .showSnackBar(
                  SnackBar(
                    content: Text("정보를 빠짐없이 입력해주세요!"),
                    duration: Duration(milliseconds: 1300),
                  )
              )
                  .closed
                  .then((SnackBarClosedReason reason) {
                _isSnackbarActive[0] = false;
              });
            }
          }else if(int.parse(controllers[0].text)>0&&int.parse(controllers[1].text)>0&&int.parse(controllers[2].text)>=0){ //값이 최솟값 이상인경우
            if (int.parse(controllers[2].text)*pow(7,boolToInt(!goalIsWeek))<int.parse(controllers[0].text)*pow(7,boolToInt(!usualIsWeek))) {//목표량이 현재보다 낮은경우
              habitList[index] = ({
                "name": _selectedItem[index][0],
                "iconURL": _selectedItem[index][1],
                "price": int.parse(controllers[1].text),
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
                        price: habitList[i]['price']*1.0,
                        usualAmount: habitList[i]['usualAmount'],
                        usualIsWeek: habitList[i]['usualIsWeek'],
                        goalIsWeek: habitList[i]['goalIsWeek'],
                        goalAmount: habitList[i]['goalAmount']
                    )
                );
              }
              if(widget.isFirst){
                Navigator.push(context, MaterialPageRoute(builder: (context) => Trigger(isFirst: widget.isFirst,)));
              }else{
                Navigator.of(context,rootNavigator: true).pushReplacement(MaterialPageRoute(builder: (context)=>MainPage()));
              }
            }else{//목표량이 현재보다 높은경우
              if(_isSnackbarActive[1] ==false) {
                _isSnackbarActive[1] = true;
                Scaffold
                    .of(context)
                    .showSnackBar(
                    SnackBar(
                      content: Text("목표치는 평소보다 작게 설정해주세요."),
                      duration: Duration(milliseconds: 1300),
                    )
                )
                    .closed
                    .then((SnackBarClosedReason reason) {
                  _isSnackbarActive[1] = false;
                });
              }
            }
          }else {//값이 최소값 미만인경우
            if(_isSnackbarActive[2] ==false) {
              _isSnackbarActive[2] = true;
              Scaffold
                  .of(context)
                  .showSnackBar(
                  SnackBar(
                    content: Text("올바른 값을 입력해주세요!"),
                    duration: Duration(milliseconds: 1300),
                  )
              )
                  .closed
                  .then((SnackBarClosedReason reason) {
                _isSnackbarActive[2] = false;
              });
            }
          }
        }catch(e){
          print(e);
          if(_isSnackbarActive[3] ==false) {
            _isSnackbarActive[3] = true;
            Scaffold
                .of(context)
                .showSnackBar(
                SnackBar(
                  content: Text("올바른 값을 입력해주세요! 숫자만 입력할 수 있습니다."),
                  duration: Duration(milliseconds: 1300),
                )
            )
                .closed
                .then((SnackBarClosedReason reason) {
              _isSnackbarActive[3] = false;
            });
          }
        }
      });
    }
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
