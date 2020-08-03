import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:richhabit/constants.dart';
import 'package:richhabit/screens/buy_or_not.dart';
import 'package:richhabit/screens/compound_interest.dart';
import 'package:richhabit/screens/home.dart';
import 'package:richhabit/screens/invest.dart';
import 'package:richhabit/screens/profile.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RichHabit',
      theme: ThemeData(),
      home: InitPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class InitPage extends StatefulWidget {
  @override
  _InitPageState createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  int _selectedIndex = 2;

  final _buyOrNot = GlobalKey<NavigatorState>();
  final _compoundInterest = GlobalKey<NavigatorState>();
  final _home = GlobalKey<NavigatorState>();
  final _invest = GlobalKey<NavigatorState>();
  final _profile = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: kPurpleColor));
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: IndexedStack(
          index: _selectedIndex,
          children: <Widget>[
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
              key: _home,
              onGenerateRoute: (route) => MaterialPageRoute(
                settings: route,
                builder: (context) => Home(),
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
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: kWhiteIvoryColor,
        elevation: 0.0,
        items: [
          new BottomNavigationBarItem(
            icon: new Icon(
              Icons.question_answer,
              size: 24.0,
              color: _selectedIndex == 0 ? kSelectedColor : kPurpleColor,
            ),
            title: Text("Buy or Not"),
          ),
          new BottomNavigationBarItem(
            icon: new Icon(
              Icons.insert_chart,
              size: 24.0,
              color: _selectedIndex == 1 ? kSelectedColor : kPurpleColor,
            ),
            title: Text("Compound Interest"),
          ),
          new BottomNavigationBarItem(
            icon: new Icon(
              Icons.monetization_on,
              size: 24.0,
              color: _selectedIndex == 2 ? kSelectedColor : kPurpleColor,
            ),
            title: Text("Home"),
          ),
          new BottomNavigationBarItem(
            icon: new Icon(
              Icons.chrome_reader_mode,
              size: 24.0,
              color: _selectedIndex == 3 ? kSelectedColor : kPurpleColor,
            ),
            title: Text("Invest"),
          ),
          new BottomNavigationBarItem(
            icon: new Icon(
              Icons.person,
              size: 24.0,
              color: _selectedIndex == 4 ? kSelectedColor : kPurpleColor,
            ),
            title: Text("Profile"),
          ),
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedFontSize: 0.0,
        unselectedFontSize: 0.0,
        onTap: (val) => _onTap(val, context),
      ),
    );
  }

  void _onTap(int val, BuildContext context) {
    if (_selectedIndex == val) {
      switch (val) {
        case 0:
          _buyOrNot.currentState.popUntil((route) => route.isFirst);
          break;
        case 1:
          _compoundInterest.currentState.popUntil((route) => route.isFirst);
          break;
        case 2:
          _home.currentState.popUntil((route) => route.isFirst);
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
