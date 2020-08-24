import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:richhabit/constants.dart';
import 'package:richhabit/habit_provider.dart';
import 'package:richhabit/screens/buy_or_not.dart';
import 'package:richhabit/screens/compound_interest.dart';
import 'package:richhabit/screens/home.dart';
import 'package:richhabit/screens/invest.dart';
import 'package:richhabit/screens/profile.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  bool keyboardIsOpened = false;

  DateTime _current;

  final _buyOrNot = GlobalKey<NavigatorState>();
  final _compoundInterest = GlobalKey<NavigatorState>();
  final _home = GlobalKey<NavigatorState>();
  final _invest = GlobalKey<NavigatorState>();
  final _profile = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    var current = DateTime.now();
    _current = DateTime(current.year, current.month, current.day);
  }

  @override
  Widget build(BuildContext context) {
    keyboardIsOpened = MediaQuery.of(context).viewInsets.bottom != 0.0;
    print("key : $keyboardIsOpened");
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: kPurpleColor,
    ));
    return Scaffold(
      backgroundColor: kPurpleColor,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: IndexedStack(
          index: _selectedIndex,
          children: <Widget>[
            Navigator(
              key: _home,
              onGenerateRoute: (route) => MaterialPageRoute(
                settings: route,
                builder: (context) => Home(),
              ),
            ),
            Navigator(
              key: _buyOrNot,
              onGenerateRoute: (route) => MaterialPageRoute(
                settings: route,
                builder: (context) => BuyOrNot(),
              ),
            ),
            Navigator(
              key: _compoundInterest,
              onGenerateRoute: (route) => MaterialPageRoute(
                settings: route,
                builder: (context) => CompoundInterest(),
              ),
            ),
            Navigator(
              key: _invest,
              onGenerateRoute: (route) => MaterialPageRoute(
                settings: route,
                builder: (context) => Invest(),
              ),
            ),
            Navigator(
              key: _profile,
              onGenerateRoute: (route) => MaterialPageRoute(
                settings: route,
                builder: (context) => Profile(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        /*
        decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Color(0xff585a79).withOpacity(0.2),
                blurRadius: 10,
                offset: Offset(0, -3)),
          ],
        ),

         */
        child: _buildBottomBar(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: keyboardIsOpened ? Container() : _buildFab(context),
    );
  }

  Widget _buildFab(BuildContext context) {
    Image image = Image.asset("assets/images/coin_1.png");
    BoxShadow boxShadow = BoxShadow(
        color: Color(0xffffeb50), blurRadius: 20, offset: Offset(0, 8));
    var list = context.watch<HabitProvider>().calendarIcon[_current];
//    list.forEach((k, v) => print('$k: $v'));
//    print("current : $_current");
    switch (list[0]) {
      case 1: //완료
        image = Image.asset('assets/images/coin_1.png');
        break;
      case 2: //오버
        image = Image.asset('assets/images/coin_2.png');
        boxShadow = BoxShadow(
            color: Color(0xffC4B786), blurRadius: 20, offset: Offset(0, 8));
        break;
      case 0: //안함
        image = Image.asset('assets/images/coin_3.png');
        break;
      default: //이상함
        image = Image.asset('assets/images/question_mark.png');
        break;
    }
    return Container(
      height: 70.0,
      width: 70.0,
      /*
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Color(0xff585a79).withOpacity(0.2),
              blurRadius: 10,
              offset: Offset(0, -3)),
        ],
      ),

       */
      child: FloatingActionButton(
        backgroundColor: kWhiteIvoryColor,
        onPressed: () {
          _onTap(0);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: <BoxShadow>[
                _selectedIndex == 0
                    ? boxShadow
                    : BoxShadow(color: Color(0xffffffff).withOpacity(1.0)),
              ],
            ),
            child: image,
          ),
        ),
        elevation: 0.0,
        highlightElevation: 0.0,
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    final double height = 60.0;
    final double iconSize = 24.0;
    var barItem = [
      FABBottomAppBarItem(iconData: Icons.question_answer),
      FABBottomAppBarItem(iconData: Icons.insert_chart),
      FABBottomAppBarItem(
        iconData: Icons.chrome_reader_mode,
      ),
      FABBottomAppBarItem(
        iconData: Icons.person,
      ),
    ];
    Widget _buildTabItem({
      FABBottomAppBarItem item,
      int index,
    }) {
      Color color =
          _selectedIndex == (index + 1) ? kSelectedColor : kPurpleColor;
      return Expanded(
        child: SizedBox(
          height: height,
          child: InkWell(
            onTap: () {
              _onTap(index + 1);
              setState(() {
                _selectedIndex = index + 1;
              });
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(item.iconData, color: color, size: iconSize),
              ],
            ),
          ),
        ),
      );
    }

    List<Widget> items = List.generate(barItem.length, (int index) {
      return _buildTabItem(
        item: barItem[index],
        index: index,
      );
    });

    Widget _buildMiddleTabItem() {
      return Expanded(
        child: SizedBox(
          height: height,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: iconSize),
            ],
          ),
        ),
      );
    }

    items.insert(items.length >> 1, _buildMiddleTabItem());

    return BottomAppBar(
      elevation: 0.0,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items,
      ),
      color: kWhiteIvoryColor,
    );
  }

  void _onTap(int val) {
    if (_selectedIndex == val) {
      switch (val) {
        case 0:
          _home.currentState.popUntil((route) => route.isFirst);
          break;
        case 1:
          _buyOrNot.currentState.popUntil((route) => route.isFirst);
          break;
        case 2:
          _compoundInterest.currentState.popUntil((route) => route.isFirst);
          break;
        case 3:
          _invest.currentState.popUntil((route) => route.isFirst);
          break;
        case 4:
          _profile.currentState.popUntil((route) => route.isFirst);
          break;
        default:
      }
    } else {
      if (mounted) {
        setState(() {
          _selectedIndex = val;
        });
      }
    }
  }
}

class FABBottomAppBarItem {
  FABBottomAppBarItem({this.iconData, this.text});
  IconData iconData;
  String text;
}
