import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:richhabit/constants.dart';
import 'package:richhabit/screens/invest_detail.dart';

class Invest extends StatefulWidget {
  @override
  _InvestState createState() => _InvestState();
}

class _InvestState extends State<Invest> {
  bool searchToggle = true;
  final _textController = new TextEditingController();
  final items = [
    {
      'title': '적금',
      'summary':
          '적금은 소비자가 가장 쉽게 접근할 수 있는 금융상품입니다. 각 은행에서 적금 계좌를 개설하고 매 달 돈을 만기까지 꾸준히 입금하면 이자를 챙길 수 있습니다.',
      'author': 'RichHabitTeam',
      'imagepath': 'assets/images/bank.png',
      'mdpath': 'assets/markdowns/bank.md'
    },
    {
      'title': '주식',
      'summary':
          '주식 투자는 기업의 분할된 소유권에 대해 투자하는 방법입니다. 주식은 코스피, 코스닥과 같은 주식 시장에서 거래할 수 있는데, 증권사에 계좌를 만들면 각 증권사를 통해 매매할 수 있습니다.',
      'author': 'RichHabitTeam',
      'imagepath': 'assets/images/stock.png',
      'mdpath': 'assets/markdowns/stock.md'
    },
    {
      'title': '채권',
      'summary': '채권은 기업이나 국가에 돈을 빌려주고, 그 이자를 벌어들이는 방식입니다.',
      'author': 'RichHabitTeam',
      'imagepath': 'assets/images/bond.png',
      'mdpath': 'assets/markdowns/bond.md'
    },
    {
      'title': '펀드',
      'summary':
          '펀드는 주식과 채권에 대해 간접적으로 투자하는 방법입니다. 다수의 인원으로부터 투자 자금을 모으고 그 돈으로 다시 금융 상품에 투자하여 그 수익을 각 투자자들에게 분배합니다.',
      'author': 'RichHabitTeam',
      'imagepath': 'assets/images/fund.png',
      'mdpath': 'assets/markdowns/fund.md'
    },
    {
      'title': 'ETF',
      'summary': 'ETF는 주식시장에서 주식처럼 주식 시장에서 자유롭게 매수, 매매할 수 있는 펀드입니다.',
      'author': 'RichHabitTeam',
      'imagepath': 'assets/images/etf.png',
      'mdpath': 'assets/markdowns/etf.md'
    },
  ];
  List showItems = [];

  void _controlText() {
    if (_textController.selection.extentOffset == -1) {
      setState(() {
        searchToggle = true;
        build(context);
      });
    }

    setState(() {
      showItems = _search(_textController.text);
      build(context);
    });
  }

  List<Map<String, String>> _search(String keyword) {
    List<Map<String, String>> searchList = [];
    if (keyword == '') {
      return items;
    }

    items.forEach((element) {
      if (element['title'].contains(keyword)) searchList.add(element);
    });

    return searchList;
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    showItems = items;
    _textController.addListener(_controlText);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kPurpleColor,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: Container(
                color: kPurpleColor,
                child: CustomScrollView(
                  slivers: <Widget>[
                    searchToggle
                        ? SliverAppBar(
                            titleSpacing: 0.0,
                            centerTitle: false,
                            backgroundColor: kPurpleColor,
                            title: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: kPadding),
                                child: Text(
                                  "투자 방법",
                                  style: TextStyle(
                                      color: kWhiteIvoryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: kTitleFontSize),
                                )),
                            actions: <Widget>[
                              IconButton(
                                icon: Icon(Icons.search),
                                onPressed: () {
                                  setState(() {
                                    build(context);
                                    searchToggle = false;
                                  });
                                },
                              )
                            ],
                          )
                        : SliverAppBar(
                            titleSpacing: 0.0,
                            centerTitle: false,
                            backgroundColor: kPurpleColor,
                            title: Container(
                              width: double.infinity,
                              child: Center(
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.only(right: kPadding),
                                  child: CupertinoTextField(
                                    controller: _textController,
                                    autofocus: true,
                                    keyboardType: TextInputType.text,
                                    placeholder: '찾고 싶은 검색어를 입력해 주세요',
                                    prefix: SizedBox(
                                      width: 9,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            leading: IconButton(
                              icon: Icon(Icons.navigate_before,
                                  color: kWhiteIvoryColor, size: 40),
                              onPressed: () {
                                setState(() {
                                  build(context);
                                  searchToggle = true;
                                });
                              },
                            ),
                          ),
                    SliverList(
                      delegate: SliverChildListDelegate([
                        Container(
                          padding: EdgeInsets.only(left: kPadding),
                          child: Text(
                            "복리의 힘을 얻는 방법!",
                            style: TextStyle(
                                color: kWhiteIvoryColor,
                                fontSize: kSubTitleFontSize),
                          ),
                        ),
                        SizedBox(
                          height: kPadding,
                        ),
                      ]),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                          (context, index) => new GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => InvestDetail(
                                        title: showItems[index]['title'],
                                        mdpath: showItems[index]['mdpath']),
                                  ),
                                );
                                _textController.text = '';
                              },
                              child: Container(
                                child: Card(
                                    color: kIvoryColor,
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          child: Image(
                                              image: AssetImage(showItems[index]
                                                  ['imagepath']),
                                              height: 66,
                                              width: 66,
                                              fit: BoxFit.fill),
                                          padding: EdgeInsets.all(10),
                                        ),
                                        Flexible(
                                            child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              showItems[index]['title'],
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: kPurpleColor,
                                                fontSize: kSubTitleFontSize,
                                              ),
                                            ),
                                            Container(
                                                padding:
                                                    EdgeInsets.only(right: 10),
                                                child: Text(
                                                  showItems[index]['summary'],
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                    color: kPurpleColor,
                                                    fontSize: kNormalFontSize,
                                                  ),
                                                )),
                                            Row(
                                              children: <Widget>[
                                                Image(
                                                  image: AssetImage(
                                                      "assets/images/coin_1.png"),
                                                  height: 20,
                                                  width: 20,
                                                ),
                                                Text(
                                                  showItems[index]['author'],
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: kNormalFontSize,
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ))
                                      ],
                                    )),
                                padding: EdgeInsets.only(
                                  left: 20,
                                  right: 20,
                                ),
                              )),
                          childCount: showItems.length),
                    )
                  ],
                ))));
  }
}
