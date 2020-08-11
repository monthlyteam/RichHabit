import 'package:flutter/material.dart';
import 'package:richhabit/constants.dart';

class BuyOrNot extends StatefulWidget {
  @override
  _BuyOrNotState createState() => _BuyOrNotState();
}

class _BuyOrNotState extends State<BuyOrNot> {
  var priceController = TextEditingController(text: "2000000");
  var maintainController = TextEditingController(text: "0");
  var _percent = 5;
  var _year = 20;
  var _cycle = 1;

  List<DropdownMenuItem> _getPercent() => List.generate(20, (index) {
        return DropdownMenuItem(
          child: Container(
            width: 40.0,
            child: Text(
              "$index%",
              textAlign: TextAlign.end,
              style: TextStyle(
                  fontSize: 20.0,
                  color: kWhiteIvoryColor,
                  fontWeight: FontWeight.bold),
            ),
          ),
          value: index,
        );
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPurpleColor,
      appBar: AppBar(
        title: Text(
          "살까? 말까?",
          style: TextStyle(
              color: kWhiteIvoryColor,
              fontSize: kTitleFontSize,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: kPurpleColor,
        centerTitle: false,
        elevation: 0.0,
      ),
      body: SafeArea(
        child: ListView(
          children: [
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
                    children: [
                      Text(
                        "연 ",
                        style: TextStyle(
                            color: kWhiteIvoryColor, fontSize: kTitleFontSize),
                        textAlign: TextAlign.center,
                      ),
                      Container(
                        height: 30.0,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            dropdownColor: kDarkPurpleColor,
                            value: _percent,
                            icon: Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Icon(
                                Icons.arrow_drop_down,
                                color: kWhiteIvoryColor,
                              ),
                            ),
                            items: _getPercent(),
                            onChanged: (value) {
                              setState(() {
                                _percent = value;
                              });
                            },
                          ),
                        ),
                      ),
                      Text(
                        "월 복리로, 20년 후 가치",
                        style: TextStyle(
                            color: kWhiteIvoryColor, fontSize: kTitleFontSize),
                        textAlign: TextAlign.center,
                      )
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
                    "2,450,020원",
                    style: TextStyle(color: kWhiteIvoryColor, fontSize: 40.0),
                  ),
                  SizedBox(height: 90.0),
                  Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    decoration: BoxDecoration(
                        color: kIvoryColor,
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              "가    격 : ",
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
                                                color: kDarkPurpleColor),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 0.5,
                                                color: kDarkPurpleColor),
                                          ),
                                        ),
                                        keyboardType:
                                            TextInputType.numberWithOptions(
                                                decimal: true),
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            color: kPurpleColor,
                                            fontWeight: FontWeight.bold),
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
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            value: 0,
                                          ),
                                          DropdownMenuItem(
                                            child: Text(
                                              "매월",
                                              style: TextStyle(
                                                  fontSize: 18.0,
                                                  color: kPurpleColor,
                                                  fontWeight: FontWeight.bold),
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
                                        },
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 30.0,
                                      child: TextField(
                                        controller: maintainController,
                                        textAlign: TextAlign.end,
                                        maxLength: 14,
                                        decoration: InputDecoration(
                                          counterText: "",
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 0.5,
                                                color: kDarkPurpleColor),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 0.5,
                                                color: kDarkPurpleColor),
                                          ),
                                        ),
                                        keyboardType:
                                            TextInputType.numberWithOptions(
                                                decimal: true),
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            color: kPurpleColor,
                                            fontWeight: FontWeight.bold),
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
                        /*
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              height: 30.0,
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  dropdownColor: kWhiteIvoryColor,
                                  value: _value,
                                  items: [
                                    DropdownMenuItem(
                                      child: Text(
                                        "매년",
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            color: kPurpleColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      value: 0,
                                    ),
                                    DropdownMenuItem(
                                      child: Text(
                                        "매월",
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            color: kPurpleColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      value: 1,
                                    ),
                                    DropdownMenuItem(
                                        child: Text(
                                          "매주",
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              color: kPurpleColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        value: 2),
                                    DropdownMenuItem(
                                        child: Text(
                                          "매일",
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              color: kPurpleColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        value: 3)
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      _value = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),

                         */
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
          ],
        ),
      ),
    );
  }
}
