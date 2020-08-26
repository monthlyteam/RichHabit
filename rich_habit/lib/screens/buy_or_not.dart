import 'package:flutter/material.dart';
import 'package:richhabit/constants.dart';

class BuyOrNot extends StatefulWidget {
  @override
  _BuyOrNotState createState() => _BuyOrNotState();
}

class _BuyOrNotState extends State<BuyOrNot> {
  var priceController = TextEditingController(text: "2000000");
  var maintainController = TextEditingController(text: "0");
  var focus = FocusNode();
  var _percent = 5;
  var _year = 20;
  var _cycle = 1;
  double _price = 0;

  @override
  void initState() {
    super.initState();
    priceController.selection = TextSelection.fromPosition(
        TextPosition(offset: priceController.text.length));
    maintainController.selection = TextSelection.fromPosition(
        TextPosition(offset: maintainController.text.length));
    _calPrice();
  }

  List<DropdownMenuItem> _getPercent() => List.generate(20, (index) {
        return DropdownMenuItem(
          child: Container(
            width: 30.0,
            child: Text(
              "${index + 1}",
              textAlign: TextAlign.end,
              style: TextStyle(
                  fontSize: 20,
                  color: kWhiteIvoryColor,
                  fontWeight: FontWeight.bold),
            ),
          ),
          value: index + 1,
        );
      });

  List<DropdownMenuItem> _getYear() => List.generate(6, (index) {
        return DropdownMenuItem(
          child: Container(
            width: 30.0,
            child: Text(
              "${(index + 1) * 5}",
              textAlign: TextAlign.end,
              style: TextStyle(
                  fontSize: 20.0,
                  color: kWhiteIvoryColor,
                  fontWeight: FontWeight.bold),
            ),
          ),
          value: (index + 1) * 5,
        );
      });

  void _calPrice() {
    double money = double.parse(priceController.text.toString());
    double maintainInput = double.parse(maintainController.text.toString());
    double maintain;
    double v = 0;
    switch (_cycle) {
      case 0: //매년
        maintain = maintainInput / 12;
        break;
      case 1: //매월
        maintain = maintainInput;
        break;
      case 2: //매주
        maintain = maintainInput / 7 * 30;
        break;
      case 3: //매일
        maintain = maintainInput * 30;
        break;
      default:
        print("틀림");
        break;
    }
    print("money : $money,main $maintain, year : $_year, per : $_percent");
    for (var i = 0; i < _year * 12; i++) {
      v = money * _percent / 100 / 12;
      money += maintain + v;
//      print("money $i : $money");
    }
    setState(() {
      _price = money;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            backgroundColor: kPurpleColor,
            titleSpacing: 0.0,
            centerTitle: false,
            elevation: 0.0,
            title: Padding(
              padding: const EdgeInsets.only(left: kPadding),
              child: Text(
                "살까? 말까?",
                style: TextStyle(
                    color: kWhiteIvoryColor,
                    fontSize: kTitleFontSize,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: kPadding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 60.0,
                      width: double.infinity,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "연",
                          style: TextStyle(
                              color: kWhiteIvoryColor, fontSize: 20.0),
                          textAlign: TextAlign.center,
                        ),
                        Container(
                          height: 30.0,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              dropdownColor: kDarkPurpleColor,
                              value: _percent,
                              icon: SizedBox(
                                width: 15.0,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Icon(
                                    Icons.arrow_drop_down,
                                    color: kWhiteIvoryColor,
                                  ),
                                ),
                              ),
                              items: _getPercent(),
                              onChanged: (value) {
                                setState(() {
                                  _percent = value;
                                });
                                _calPrice();
                              },
                            ),
                          ),
                        ),
                        Text(
                          "% 월 복리로,  ",
                          style: TextStyle(
                              color: kWhiteIvoryColor, fontSize: 20.0),
                          textAlign: TextAlign.center,
                        ),
                        Container(
                          height: 30.0,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              dropdownColor: kDarkPurpleColor,
                              value: _year,
                              icon: SizedBox(
                                width: 18.0,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Icon(
                                    Icons.arrow_drop_down,
                                    color: kWhiteIvoryColor,
                                  ),
                                ),
                              ),
                              items: _getYear(),
                              onChanged: (value) {
                                setState(() {
                                  _year = value;
                                });
                                _calPrice();
                              },
                            ),
                          ),
                        ),
                        Text(
                          "년 후 가치",
                          style: TextStyle(
                              color: kWhiteIvoryColor, fontSize: 20.0),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      width: 30.0,
                      child: Divider(
                        color: kWhiteIvoryColor,
                        thickness: 3,
                      ),
                    ),
                    SizedBox(height: 25.0),
                    Text(
                      "${_price.toStringAsFixed(0).replaceAllMapped(new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}원",
                      style: TextStyle(color: kWhiteIvoryColor, fontSize: 40.0),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 90.0),
                    Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 20.0),
                      decoration: BoxDecoration(
                          color: kIvoryColor,
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                "가",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: kPurpleColor,
                                ),
                              ),
                              Text(
                                "지",
                                style: TextStyle(
                                    fontSize: 18.0,
                                    color: kPurpleColor.withOpacity(0.0)),
                              ),
                              Text(
                                "격",
                                style: TextStyle(
                                    fontSize: 18.0, color: kPurpleColor),
                              ),
                              Text(
                                " : ",
                                style: TextStyle(
                                    fontSize: 18.0, color: kPurpleColor),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 30.0,
                                        child: TextField(
                                          controller: priceController,
                                          textAlign: TextAlign.end,
                                          maxLength: 14,
                                          decoration: InputDecoration(
                                            counterText: "",
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 0.5,
                                                  color: kDarkPurpleColor
                                                      .withOpacity(0.4)),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 0.5,
                                                  color: kDarkPurpleColor),
                                            ),
                                          ),
                                          keyboardType:
                                              TextInputType.numberWithOptions(),
                                          textInputAction: TextInputAction.next,
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              color: kPurpleColor,
                                              fontWeight: FontWeight.bold),
                                          onChanged: (text) {
                                            if (text != null) {
                                              _calPrice();
                                            }
                                          },
                                          onSubmitted: (_) =>
                                              FocusScope.of(context)
                                                  .requestFocus(focus),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      " 원",
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          color: kPurpleColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15.0),
                          Row(
                            children: [
                              Text(
                                "유지비 : ",
                                style: TextStyle(
                                    fontSize: 18.0, color: kPurpleColor),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      height: 30.0,
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton(
                                          dropdownColor: kWhiteIvoryColor,
                                          value: _cycle,
                                          icon: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: Icon(
                                              Icons.arrow_drop_down,
                                              color: kPurpleColor,
                                            ),
                                          ),
                                          items: [
                                            DropdownMenuItem(
                                              child: Text(
                                                "매년",
                                                style: TextStyle(
                                                    fontSize: 18.0,
                                                    color: kPurpleColor,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              value: 0,
                                            ),
                                            DropdownMenuItem(
                                              child: Text(
                                                "매월",
                                                style: TextStyle(
                                                    fontSize: 18.0,
                                                    color: kPurpleColor,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              value: 1,
                                            ),
                                            DropdownMenuItem(
                                                child: Text(
                                                  "매주",
                                                  style: TextStyle(
                                                      fontSize: 18.0,
                                                      color: kPurpleColor,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                value: 2),
                                            DropdownMenuItem(
                                                child: Text(
                                                  "매일",
                                                  style: TextStyle(
                                                      fontSize: 18.0,
                                                      color: kPurpleColor,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                value: 3)
                                          ],
                                          onChanged: (value) {
                                            setState(() {
                                              _cycle = value;
                                            });
                                            _calPrice();
                                          },
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: 30.0,
                                        child: TextField(
                                          controller: maintainController,
                                          focusNode: focus,
                                          textAlign: TextAlign.end,
                                          textInputAction: TextInputAction.done,
                                          maxLength: 14,
                                          decoration: InputDecoration(
                                            counterText: "",
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 0.5,
                                                  color: kDarkPurpleColor
                                                      .withOpacity(0.4)),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 0.5,
                                                  color: kDarkPurpleColor),
                                            ),
                                          ),
                                          keyboardType:
                                              TextInputType.numberWithOptions(),
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              color: kPurpleColor,
                                              fontWeight: FontWeight.bold),
                                          onChanged: (text) {
                                            if (text != null) {
                                              _calPrice();
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                    Text(
                                      " 원",
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          color: kPurpleColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5.0),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Text(
                      "\"리치해빗은 현명한 소비를 권장합니다!\"",
                      style: TextStyle(color: kWhiteIvoryColor, fontSize: 14.0),
                    ),
                    SizedBox(
                      height: 50.0,
                    )
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
