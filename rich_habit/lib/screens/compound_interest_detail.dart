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
    // history = context.read<HabitProvider>().showCumSavingHistory(null);
    context.read<HabitProvider>().showCumSavingHistory(null);
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
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
            "${context.watch<HabitProvider>().cumSaving(addedTimeID).toStringAsFixed(0).replaceAllMapped(new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}원",
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
              decoration: BoxDecoration(
                color: kIvoryColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(19)),
              ),
              width: double.infinity,
              height: 80,
              child: SingleChildScrollView(
                child: Column(children: [
                  ConfigurableExpansionTile(
                    header: Text("Head"),
                    children: [
                      Text("HIHI"),
                      Text("HIHI"),
                      Text("HIHI"),
                    ],
                  ),
                  ConfigurableExpansionTile(
                    header: Text("Head"),
                    children: [
                      Text("HIHI"),
                      Text("HIHI"),
                      Text("HIHI"),
                    ],
                  ),
                  ConfigurableExpansionTile(
                    header: Text("Head"),
                    children: [
                      Text("HIHI"),
                      Text("HIHI"),
                      Text("HIHI"),
                    ],
                  ),
                  ConfigurableExpansionTile(
                    header: Row(children: [
                      CircleAvatar(
                        child: Icon(
                          Icons.keyboard_arrow_up,
                          color: kWhiteIvoryColor,
                        ),
                        backgroundColor: Colors.orange[700],
                        radius: 12,
                      ),
                      Text("Head"),
                    ]),
                    children: [
                      Text("HIHI"),
                      Text("HIHI"),
                      Text("HIHI"),
                    ],
                  ),
                  ConfigurableExpansionTile(
                    header: Text("Head"),
                    children: [
                      Text("HIHI"),
                      Text("HIHI"),
                      Text("HIHI"),
                    ],
                  ),
                  ConfigurableExpansionTile(
                    header: Text("Head"),
                    children: [
                      Text("HIHI"),
                      Text("HIHI"),
                      Text("HIHI"),
                    ],
                  ),
                  ConfigurableExpansionTile(
                    header: Text("Head"),
                    children: [
                      Text("HIHI"),
                      Text("HIHI"),
                      Text("HIHI"),
                    ],
                  ),
                ]),
              ),
            ),
          )
        ],
      ),
    );
  }
}
