import 'package:flutter/material.dart';
import 'package:richhabit/constants.dart';
import 'package:provider/provider.dart';
import 'package:configurable_expansion_tile/configurable_expansion_tile.dart';

import '../habit_provider.dart';

class CompoundInterestDetail extends StatefulWidget {
  final DateTime addedTimeID;

  const CompoundInterestDetail({Key key, this.addedTimeID}) : super(key: key);

  @override
  _CompoundInterestDetailState createState() => _CompoundInterestDetailState();
}

class _CompoundInterestDetailState extends State<CompoundInterestDetail> {
  DateTime addedTimeID;
  Map<int, dynamic> history;

  @override
  void initState() {
    super.initState();
    addedTimeID = widget.addedTimeID;
    history = context.read<HabitProvider>().showCumSavingHistory(addedTimeID);
    print(history);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kPurpleColor,
        appBar: AppBar(
            backgroundColor: kPurpleColor,
            brightness: Brightness.light,
            elevation: 0.0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              color: kWhiteIvoryColor,
              iconSize: kSubTitleFontSize,
              onPressed: () {
                Navigator.pop(context);
              },
            )),
        body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          SizedBox(
            height: 30,
            width: double.infinity,
          ),
          Text(
            "총 누적 절약 금액",
            style: TextStyle(color: kWhiteIvoryColor, fontSize: 16),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            width: 32.5,
            child: Divider(
              color: kWhiteIvoryColor,
              thickness: 3,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            "${context.watch<HabitProvider>().cumSaving(addedTimeID).toStringAsFixed(1).replaceAllMapped(new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}원",
            style: TextStyle(
                color: kWhiteIvoryColor,
                fontSize: 25.0,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 50,
          ),
          Expanded(
              child: Container(
            padding: EdgeInsets.only(top: 25.0),
            decoration: BoxDecoration(
              color: kIvoryColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(19)),
            ),
            width: double.infinity,
            height: 80,
            child: SingleChildScrollView(
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _showHitsoryList(history)),
            ),
          ))
        ]));
  }
}

List<Widget> _showHitsoryList(Map<int, dynamic> history) {
  double tabsize = 16;
  List<Widget> result = [];
  Map<int, double> yearvalue = new Map();

  history.forEach((year, weeklist) {
    List<Widget> yearchildlist = [];
    yearvalue[year] = 0;

    weeklist.forEach((week, habitlist) {
      List<Widget> weekchildlist = [];
      yearvalue[year] += habitlist[0];

      habitlist[1].forEach((row) {
        String name = row[0];
        double value = row[1];

        weekchildlist.add(Row(
          children: [
            SizedBox(
              width: tabsize * 2,
            ),
            Text(
              "-  $name",
              style: TextStyle(
                  color: kDarkPurpleColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            Text("$value원",
                style: TextStyle(color: kDarkPurpleColor, fontSize: 16))
          ],
        ));
      });

      yearchildlist.add(ConfigurableExpansionTile(
        header: Row(
          children: [
            SizedBox(
              width: tabsize * 1,
            ),
            _toggleButton(false),
            Text(week.toString() + "주",
                style: TextStyle(
                    color: kDarkPurpleColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            Text(
                "${habitlist[0].toStringAsFixed(1).replaceAllMapped(new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}원",
                style: TextStyle(color: kDarkPurpleColor, fontSize: 16)),
          ],
        ),
        children: weekchildlist,
      ));
    });
    result.add(ConfigurableExpansionTile(
      header: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        _toggleButton(false),
        Text(
          "$year년",
          style: TextStyle(
              color: kDarkPurpleColor,
              fontSize: 16,
              fontWeight: FontWeight.bold),
        ),
        Text(
          "${yearvalue[year].toStringAsFixed(1).replaceAllMapped(new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}원",
          style: TextStyle(color: kDarkPurpleColor, fontSize: 16),
        ),
      ]),
      children: yearchildlist.reversed.toList(),
    ));
  });

  return result.reversed.toList();
}

CircleAvatar _toggleButton(bool opened) {
  double rad = 11.5;

  return opened
      ? CircleAvatar(
          child: Icon(
            Icons.keyboard_arrow_up,
            color: kWhiteIvoryColor,
          ),
          backgroundColor: Colors.orange[700],
          radius: rad,
        )
      : CircleAvatar(
          child: Icon(
            Icons.keyboard_arrow_down,
            color: kWhiteIvoryColor,
          ),
          backgroundColor: Colors.grey,
          radius: rad,
        );
}
